#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>

// Define APFEL I/O LHAPDF
#ifndef NOLHAPDF

// LHAPDF implementation
#include "LHAPDF/LHAPDF.h"

#if defined LHAPDF_MAJOR_VERSION && LHAPDF_MAJOR_VERSION == 6

// global objects
LHAPDF::PDF* _pdfs;
extern "C" {

  void   mkpdfs_(int *mem, int *size, char* setname, int len)
  {
    std::string str = setname;
    str.resize(*size);

    if (_pdfs) delete _pdfs;
    try { _pdfs =  LHAPDF::mkPDF(str, *mem); }
    catch(LHAPDF::Exception e) { std::cout << e.what() << std::endl; }
  }

  int numberpdf_()
  {
    return std::atoi(_pdfs->info().get_entry("NumMembers").c_str())-1;
  }

  double xfxq_(int *fl, double *x, double *Q)
  {
    return _pdfs->xfxQ(*fl, *x, *Q);
  }

  bool   islhapdf6_() { return true;  }
}
#else

extern "C" {
  void   mkpdfs_(int *size, char* setname, int len)
  {
    std::string str = setname;
    str.resize(*size);
    LHAPDF::initPDFSetByName(str);
  }

  double xfxq_(int *mem, int *fl, double *x, double *Q)
  {
    LHAPDF::initPDF(*mem);
    std::vector<double> pdf = LHAPDF::xfx(*x, *Q);
    return pdf[*fl+6];
  }

  int numberpdf_()
  {
    return LHAPDF::numberPDF();
  }

  bool   islhapdf6_() { return false; }
}

#endif

#else
extern "C" void stop() { printf(" [Error] LHAPDF support disabled with --disable-lhapdf.\n"); exit(-1); }
extern "C" void mkpdfs_(){ stop(); return ; }
extern "C" double xfxq_(){ stop(); return 0;}
extern "C" int numberpdf_(){ stop(); return 0;}
extern "C" bool islhapdf6_() { return true; }
#endif

// function to create folder for LHAPDFgrid.f
extern "C" void mkdir_(char* name, int length) { mkdir(name, 0777); }
