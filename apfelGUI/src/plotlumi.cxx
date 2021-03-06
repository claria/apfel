#include "plotlumi.h"
#include "ui_plotlumi.h"
#include "pdfdialog.h"
#include "common.h"
#include "utils.h"
#include <cmath>

#include <QGraphicsScene>
#include <QGraphicsItemGroup>
//#include <QGraphicsSvgItem>
#include <QFile>
//#include <QtSvg/QSvgWidget>
#include <QDebug>
#include <QFileDialog>
#include <QDesktopWidget>

#include "APFEL/APFEL.h"
#include "LHAPDF/LHAPDF.h"

PlotLumi::PlotLumi(QWidget *parent,std::vector<PDFDialog*> pdf) :
  QWidget(parent),
  ui(new Ui::PlotLumi),
  thread(NULL),
  fPDF(pdf),
  fPlotName("lumiplot.png"),
  fRef(0),
  fIsRunning(false)
{
  ui->setupUi(this);

  QRect frect = frameGeometry();
  frect.moveCenter(QDesktopWidget().availableGeometry().center());
  move(frect.topLeft());

  long int t = static_cast<long int> (time(NULL));
  QString str;
  str.append(QString("%1").arg(t));

  fPlotName = "luminplot_" + str + ".png";
  thread  = new lumithread(this,fPlotName);

  connect(thread, SIGNAL(finished()), this, SLOT(ThreadFinished()));
  connect(thread, SIGNAL(progress(int)), this, SLOT(ThreadProgress(int)));

  //ui->graphicsView->scale(1.2,1.2);

  ui->Qi->setEnabled(false);
  for (int i = 0; i < (int) fPDF.size(); i++)
    if (!fPDF[i]->isLHAPDF())
      ui->Qi->setEnabled(true);

  ui->xtitle->setText("M_{X}");
  ui->ytitle->setText("Ratio");
  ui->title->setText("Gluon - Gluon Luminosity");

  for (int i = 0; i < (int) fPDF.size(); i++)
    ui->referenceSet->addItem(fPDF[i]->PDFname());
}

PlotLumi::~PlotLumi()
{
  delete ui;
  if (thread)
    {
      thread->terminate();
      delete thread;
    }
}

void PlotLumi::on_referenceSet_currentIndexChanged(int index)
{
  fRef = index;
}

void PlotLumi::on_automaticrange_toggled(bool checked)
{
  if (checked == true)
    {
      ui->xmin->setEnabled(false);
      ui->xmax->setEnabled(false);
      ui->ymin->setEnabled(false);
      ui->ymax->setEnabled(false);
    }
  else
    {
      ui->xmin->setEnabled(true);
      ui->xmax->setEnabled(true);
      ui->ymin->setEnabled(true);
      ui->ymax->setEnabled(true);
    }
}

void PlotLumi::on_playButton_clicked()
{
  if (!fIsRunning)
    {
      fIsRunning = true;
      ui->playButton->setIcon(QIcon(":/images/Stop1NormalRed.png"));
      ui->playButton->setText("Stop");
      if (ui->graphicsView->scene()) ui->graphicsView->scene()->clear();
      QApplication::processEvents();
      thread->start();
    }
  else
    {
      fIsRunning = false;
      thread->stop();
      ui->playButton->setEnabled(false);
    }
}

void PlotLumi::on_saveButton_clicked()
{
  QString selectedFilter;
  QString path = QFileDialog::getSaveFileName(this,
                                              tr("Save as"),"",
                                              tr(".eps;;.ps;;.pdf;;.png;;.root;;.C"),&selectedFilter);
  if (path != 0) thread->SaveCanvas(path + selectedFilter);
}


void PlotLumi::ThreadFinished()
{
  ui->playButton->setIcon(QIcon(":/images/StepForwardNormalBlue.png"));
  ui->playButton->setText("Compute");
  fIsRunning = false;

  ui->playButton->setEnabled(true);
  ui->saveButton->setEnabled(true);

  // plot to canvas
  QGraphicsScene *scene = new QGraphicsScene(ui->graphicsView);
  //QGraphicsSvgItem * item = new QGraphicsSvgItem(fPlotName);
  QGraphicsPixmapItem *item = new QGraphicsPixmapItem(fPlotName);
  scene->addItem(item);
  ui->graphicsView->setScene(scene);
  ui->graphicsView->show();

  ui->progressBar->setValue(0);

  QFile::remove(fPlotName) ;
}

void PlotLumi::ThreadProgress(int i)
{
  ui->progressBar->setValue(i);
}

void PlotLumi::on_PDFflavor_currentIndexChanged(int index)
{
  QString titleY [] = {
  "Gluon - Gluon Luminosity",
  "Quark - Antiquark Luminosity",
  "Quark - Gluon Luminosity",
  "Charm - Anticharm Luminosity",
  "Bottom - Antibottom Luminosity",
  "Gluon - Charm Luminosity",
  "Bottom - Gluon Luminosity",
  "Quark - Quark Luminosity",
  "Photon - Photon Luminosity" };

  ui->title->setText(titleY[index]);
}

void PlotLumi::on_customcm_toggled(bool checked)
{
  if (checked == true)
    ui->cmenergyref->setEnabled(true);
  else
    ui->cmenergyref->setEnabled(false);
}

lumithread::lumithread(QObject *parent, QString filename):
  QThread(parent),
  fp((PlotLumi*)parent),
  fFileName(filename),
  fIsTerminated(false)
{
}

lumithread::~lumithread()
{
}

void lumithread::run()
{
  fC = new TCanvas();
  fC->SetTickx();
  fC->SetTicky();

  if (fp->ui->logx->isChecked())
    fC->SetLogx();

  if (fp->ui->logy->isChecked())
    fC->SetLogy();

  // Initialize PDFs

  const int N = fp->ui->xpoints->value();
  double xmin = 10;
  double xmax = 6e3;
  double ymin = 0.8;
  double ymax = 1.3;
  double eps = fp->ui->integration->text().toDouble();
  double S = 0;
  double Sset = pow(fp->ui->cmenergy->text().toDouble(), 2.0);
  double Sref = pow(fp->ui->cmenergyref->text().toDouble(), 2.0);
  if (!fp->ui->customcm->isChecked()) Sref = Sset;

  vector<string> lumis;
  lumis.push_back("GG");
  lumis.push_back("QQ");
  lumis.push_back("QG");
  lumis.push_back("GC");
  lumis.push_back("BG");
  lumis.push_back("CC");
  lumis.push_back("BB");
  lumis.push_back("Q2");
  lumis.push_back("PP");
  lumis.push_back("PG");

  if (!fp->ui->automaticrange->isChecked())
    {
      xmin = fp->ui->xmin->text().toDouble();
      xmax = fp->ui->xmax->text().toDouble();
      ymin = fp->ui->ymin->text().toDouble();
      ymax = fp->ui->ymax->text().toDouble();
    }    

  const double Qi = fp->ui->Qi->text().toDouble();

  TLegend *leg = new TLegend(0.12931,0.673729,0.507184,0.883475);
  leg->SetBorderSize(0);
  leg->SetFillColor(0);
  leg->SetFillStyle(0);   

  TMultiGraph *mg = new TMultiGraph();

  double *refx = new double[N];

  vector<int> indRef;
  indRef.push_back(fp->fRef);
  for (int i = 0; i < (int) fp->fPDF.size(); i++)
    if (i != fp->fRef) indRef.push_back(i);

  for (int set = 0; set < (int) fp->fPDF.size(); set++)
    {
      fp->fPDF[indRef[set]]->InitPDFset(Qi,xmax);
      if (set == 0)
        S = Sref;
      else
        S = Sset;

      TGraphErrors *g = new TGraphErrors(N);
      g->SetLineWidth(2);
      g->SetLineStyle(2);
      g->SetLineColor(fillcolor[set]+2);
      g->SetFillColor(fillcolor[set]);
      g->SetFillStyle(fillStyle[set]);

      TGraph *gcv = new TGraph(N);
      gcv->SetLineWidth(2);
      gcv->SetLineStyle(2);
      gcv->SetLineColor(fillcolor[set]+2);

      TGraph *gup = new TGraph(N);
      gup->SetLineWidth(2);
      gup->SetLineStyle(1);
      gup->SetLineColor(fillcolor[set]+2);

      TGraph *gdn = new TGraph(N);
      gdn->SetLineWidth(2);
      gdn->SetLineStyle(1);
      gdn->SetLineColor(fillcolor[set]+2);

      double *xmH = new double[N];
      for (int imH = 1; imH <= N; imH++)
        {
          if(fIsTerminated){ fIsTerminated = false; delete[] refx; return; }

          emit progress((imH-1)*100/N);
          double mH = xmin * pow(xmax/xmin, double(imH-1)/(N-1));
          xmH[imH-1] = mH;

	  double cverr = 0;
	  double cv = fp->fPDF[indRef[set]]->getLum(mH, S, lumis[fp->ui->PDFflavor->currentIndex()],eps,cverr);

	  if (set == 0) refx[imH-1] = cv;
	  if (fp->ui->ratio->isChecked())
	    {
	      cv /= refx[imH-1];
	      cverr /= refx[imH-1];
	    }

	  g->SetPoint(imH-1, xmH[imH-1], cv);
	  gcv->SetPoint(imH-1,xmH[imH-1], cv);

	  if (fp->ui->stddev->isChecked() && fp->fPDF[indRef[set]]->numberPDF() > 1)
	    {
	      g->SetPointError(imH-1,0,cverr);
	      gup->SetPoint(imH-1,xmH[imH-1], cv+cverr);
	      gdn->SetPoint(imH-1,xmH[imH-1], cv-cverr);
	    }
        }

      delete[] xmH;

      mg->Add(g,"le3");
      if (set == 0)
        mg->Add(gcv,"l");

      if (fp->ui->stddev->isChecked())
        {
          mg->Add(gup,"l");
          mg->Add(gdn,"l");
        }

      leg->AddEntry(g,TString(fp->fPDF[indRef[set]]->PDFname().toStdString()),"fl");

    }

  delete[] refx;

  mg->SetTitle(fp->ui->title->text().toStdString().c_str());
  mg->Draw("AL");

  mg->GetXaxis()->SetTitle(fp->ui->xtitle->text().toStdString().c_str());
  mg->GetXaxis()->CenterTitle(true);

  mg->GetYaxis()->SetTitle(fp->ui->ytitle->text().toStdString().c_str());
  mg->GetYaxis()->CenterTitle(true);

  mg->GetXaxis()->SetTitleSize(0.05);
  mg->GetXaxis()->SetLabelSize(0.05);
  mg->GetYaxis()->SetTitleSize(0.05);
  mg->GetYaxis()->SetLabelSize(0.05);

  mg->GetXaxis()->SetLimits(xmin,xmax);

  if (fp->ui->ratio->isChecked() == true)
    mg->GetYaxis()->SetRangeUser(ymin,ymax);
  else if (!fp->ui->automaticrange->isChecked())
    mg->GetYaxis()->SetRangeUser(ymin,ymax);

  leg->AddEntry("",TString("#sqrt{S} = " + QString::number(fp->ui->cmenergy->text().toDouble(),'g',3).toStdString() + " GeV"),"");
  leg->Draw("same");

  TLatex l; //l.SetTextAlign(12);
  l.SetTextSize(0.02);
  l.SetTextAngle(90);
  l.SetNDC();
  l.SetTextFont(72);
  l.SetTextColor(kBlack);
  l.DrawLatex(0.95,0.15,TString("Generated by APFEL" + TString(APFEL::GetVersion()) + ": V.Bertone, S.Carrazza, J.Rojo (arXiv:1310.1394)"));

  fC->SaveAs(fFileName.toStdString().c_str());

}

void lumithread::SaveCanvas(QString filename)
{
  fC->SaveAs(filename.toStdString().c_str());
}

void lumithread::stop()
{
  fIsTerminated = true;
}
