************************************************************************
*
*     CheckAPFEL.f:
*
*     Code that tests APFEL against a pretabulated set of results for:
*     - alpha_s,
*     - evolution,
*     - structure functions.
*
************************************************************************
      function CheckAPFEL()
*
      implicit none
**
*     Internal Variables
*
      integer ilha,iQ,iref
      double precision Q20,Q2(4),Q0,Q
      double precision xlha(9)
      double precision eps
      double precision toll
      double precision AlphaQCD,AlphaQED
      double precision xPDFj
      double precision F2light,F2charm,F2bottom,F2total
      double precision FLlight,FLcharm,FLbottom,FLtotal
      double precision F3light,F3charm,F3bottom,F3total
      double precision Ref(616)
      character*6 apfelversion
      logical succ
      parameter(eps=1d-10)
      parameter(toll=1d-6)
**
*     Output Variables
*
      logical CheckAPFEL
*
      data Q20  / 2d0 /
      data Q2   / 10d0, 100d0, 1000d0, 10000d0 /
      data xlha / 1d-5, 1d-4, 1d-3, 1d-2, 1d-1, 3d-1, 5d-1, 7d-1, 9d-1 /
      data Ref  / 
     1     2.442349d-01,
     1     1.193939d-03,  7.485935d-04,  6.869041d+00,  1.829460d+00,
     1     2.656613d+01,
     1     2.059303d+00,  6.988237d-01,  2.094048d-02,  2.779067d+00,
     1     3.876623d-01,  1.006200d-01,  6.704611d-04,  4.889528d-01,
     1     1.256974d-06,  3.480657d-08,  0.000000d+00,  1.291781d-06,
     1     6.082459d-03,  3.673987d-03,  4.311435d+00,  9.812364d-01,
     1     1.709241d+01,
     1     1.261344d+00,  3.491198d-01,  8.854254d-03,  1.619318d+00,
     1     2.664884d-01,  5.549607d-02,  3.046585d-04,  3.222891d-01,
     1     5.598434d-06,  6.595670d-08,  0.000000d+00,  5.664390d-06,
     1     3.154258d-02,  1.862850d-02,  2.635698d+00,  4.833360d-01,
     1     9.872000d+00,
     1     7.694275d-01,  1.511541d-01,  2.724934d-03,  9.233065d-01,
     1     1.678034d-01,  2.699601d-02,  1.043872d-04,  1.949038d-01,
     1     2.491742d-05,  5.059209d-08,  0.000000d+00,  2.496801d-05,
     1     1.600658d-01,  9.286229d-02,  1.506557d+00,  2.029548d-01,
     1     4.752753d+00,
     1     5.042107d-01,  5.021664d-02,  3.238022d-04,  5.547512d-01,
     1     9.453622d-02,  1.008401d-02,  1.414089d-05,  1.046344d-01,
     1     1.074162d-04, -8.526276d-08,  0.000000d+00,  1.073309d-04,
     1     5.924226d-01,  3.096037d-01,  4.697923d-01,  3.813648d-02,
     1     1.253566d+00,
     1     4.001067d-01,  4.740535d-03,  8.338509d-11,  4.048473d-01,
     1     3.948681d-02,  9.008050d-04,  8.354839d-13,  4.038762d-02,
     1     3.524933d-04, -8.802007d-08,  0.000000d+00,  3.524053d-04,
     1     5.532562d-01,  2.227810d-01,  6.641605d-02,  4.054517d-03,
     1     2.148372d-01,
     1     2.810472d-01,  3.778803d-04,  0.000000d+00,  2.814251d-01,
     1     1.391783d-02,  2.626936d-05,  0.000000d+00,  1.394410d-02,
     1     3.456557d-04, -1.528090d-08,  0.000000d+00,  3.456404d-04,
     1     2.609795d-01,  7.458363d-02,  6.246513d-03,  3.573108d-04,
     1     2.982527d-02,
     1     1.422937d-01,  5.533935d-05,  0.000000d+00,  1.423491d-01,
     1     3.877547d-03,  1.460818d-06,  0.000000d+00,  3.879008d-03,
     1     1.850429d-04, -2.078385d-09,  0.000000d+00,  1.850409d-04,
     1     6.207093d-02,  1.058890d-02,  2.033670d-04,  1.269359d-05,
     1     1.897703d-03,
     1     4.198172d-02,  3.461281d-06,  0.000000d+00,  4.198518d-02,
     1     5.306756d-04,  3.359298d-08,  0.000000d+00,  5.307092d-04,
     1     5.476675d-05, -1.416449d-10,  0.000000d+00,  5.476660d-05,
     1     2.065315d-03,  1.169151d-04,  1.785933d-07,  1.864313d-08,
     1     9.041930d-06,
     1     2.383137d-03,  1.092800d-08,  0.000000d+00,  2.383148d-03,
     1     6.605658d-06,  2.206940d-11,  0.000000d+00,  6.605680d-06,
     1     3.037889d-06, -6.765384d-13,  0.000000d+00,  3.037888d-06,
     1     1.762926d-01,
     1     1.954225d-03,  1.216954d-03,  1.480499d+01,  5.848240d+00,
     1     7.856866d+01,
     1     4.586623d+00,  2.392351d+00,  2.257678d-01,  7.204742d+00,
     1     8.645679d-01,  4.779515d-01,  3.459189d-02,  1.377111d+00,
     1     1.746129d-05,  8.735282d-07,  5.626028d-08,  1.839108d-05,
     1     9.179442d-03,  5.493776d-03,  7.969802d+00,  2.850759d+00,
     1     4.030636d+01,
     1     2.437475d+00,  1.143128d+00,  9.856550d-02,  3.679169d+00,
     1     4.565870d-01,  2.385162d-01,  1.594611d-02,  7.110494d-01,
     1     7.497539d-05,  1.534705d-06,  9.885523d-08,  7.660895d-05,
     1     4.313924d-02,  2.516133d-02,  4.048428d+00,  1.223070d+00,
     1     1.807759d+01,
     1     1.238558d+00,  4.740364d-01,  3.592723d-02,  1.748521d+00,
     1     2.134127d-01,  1.028021d-01,  6.186708d-03,  3.224015d-01,
     1     3.193569d-04,  9.257968d-07,  5.979543d-08,  3.203425d-04,
     1     1.923387d-01,  1.096654d-01,  1.856199d+00,  4.123880d-01,
     1     6.410515d+00,
     1     6.423070d-01,  1.523312d-01,  8.869353d-03,  8.035075d-01,
     1     8.335815d-02,  3.327694d-02,  1.653060d-03,  1.182882d-01,
     1     1.289154d-03, -2.187841d-06, -1.410750d-07,  1.286825d-03,
     1     5.809810d-01,  2.953382d-01,  4.384880d-01,  5.502951d-02,
     1     1.104450d+00,
     1     3.995610d-01,  1.795575d-02,  4.407810d-04,  4.179575d-01,
     1     2.301353d-02,  3.468075d-03,  7.905831d-05,  2.656066d-02,
     1     3.636153d-03, -1.691444d-06, -1.094519d-07,  3.634352d-03,
     1     4.561589d-01,  1.770018d-01,  5.062598d-02,  4.458013d-03,
     1     1.403667d-01,
     1     2.354978d-01,  1.286867d-03,  1.607580d-05,  2.368007d-01,
     1     6.772414d-03,  1.577137d-04,  1.107169d-06,  6.931235d-03,
     1     2.929828d-03, -2.396961d-07, -1.558730d-08,  2.929573d-03,
     1     1.872641d-01,  5.126992d-02,  4.097507d-03,  3.204371d-04,
     1     1.631027d-02,
     1     9.968665d-02,  9.077004d-05,  1.705720d-06,  9.977913d-02,
     1     1.632681d-03,  5.397222d-06,  4.428611d-08,  1.638122d-03,
     1     1.293479d-03, -2.727283d-08, -1.774266d-09,  1.293450d-03,
     1     3.796242d-02,  6.170205d-03,  1.134424d-04,  9.245070d-06,
     1     9.195681d-04,
     1     2.327397d-02,  2.916880d-06,  9.200687d-08,  2.327698d-02,
     1     1.868415d-04,  4.896462d-08,  8.962793d-10,  1.868914d-04,
     1     3.004704d-04, -1.465172d-09, -9.586952d-11,  3.004688d-04,
     1     9.480294d-04,  5.099695d-05,  7.581687d-08,  9.451960d-09,
     1     3.918338d-06,
     1     8.612141d-04,  3.980467d-09,  3.746194d-10,  8.612184d-04,
     1     1.693994d-06,  6.831281d-12,  7.535237d-13,  1.694001d-06,
     1     1.086137d-05, -4.910571d-12, -3.030964d-13,  1.086136d-05,
     1     1.394600d-01,
     1     2.604842d-03,  1.607062d-03,  2.424491d+01,  1.060348d+01,
     1     1.450155d+02,
     1     7.745659d+00,  4.548972d+00,  7.811260d-01,  1.307576d+01,
     1     1.274970d+00,  8.094015d-01,  1.625055d-01,  2.246877d+00,
     1     1.980266d-04,  1.008031d-05,  1.451002d-06,  2.095579d-04,
     1     1.175665d-02,  6.980479d-03,  1.178463d+01,  4.786239d+00,
     1     6.467983d+01,
     1     3.731985d+00,  2.037785d+00,  3.319515d-01,  6.101722d+00,
     1     5.772665d-01,  3.587954d-01,  7.027011d-02,  1.006332d+00,
     1     8.328198d-04,  1.669187d-05,  2.403359d-06,  8.519150d-04,
     1     5.229958d-02,  3.025818d-02,  5.303096d+00,  1.873904d+00,
     1     2.480222d+01,
     1     1.681619d+00,  7.796927d-01,  1.190119d-01,  2.580323d+00,
     1     2.266049d-01,  1.350105d-01,  2.561669d-02,  3.872320d-01,
     1     3.441665d-03,  8.060445d-06,  1.164314d-06,  3.450890d-03,
     1     2.150235d-01,  1.212482d-01,  2.100131d+00,  5.591278d-01,
     1     7.286525d+00,
     1     7.499243d-01,  2.276773d-01,  3.060342d-02,  1.008205d+00,
     1     7.167582d-02,  3.696330d-02,  6.674145d-03,  1.153133d-01,
     1     1.317426d-02, -2.511263d-05, -3.619901d-06,  1.314553d-02,
     1     5.656651d-01,  2.821564d-01,  4.102433d-01,  6.183702d-02,
     1     9.649397d-01,
     1     3.947862d-01,  2.415826d-02,  2.416752d-03,  4.213612d-01,
     1     1.576716d-02,  3.184673d-03,  5.015833d-04,  1.945341d-02,
     1     3.297578d-02, -1.609376d-05, -2.327398d-06,  3.295736d-02,
     1     3.925024d-01,  1.484172d-01,  4.110900d-02,  4.298394d-03,
     1     1.018794d-01,
     1     2.052105d-01,  1.647367d-03,  1.168594d-04,  2.069748d-01,
     1     4.132174d-03,  1.473844d-04,  1.795840d-05,  4.297517d-03,
     1     2.317946d-02, -1.996399d-06, -2.899033d-07,  2.317717d-02,
     1     1.457222d-01,  3.871874d-02,  2.993343d-03,  2.758751d-04,
     1     1.063916d-02,
     1     7.698680d-02,  1.075020d-04,  5.719453d-06,  7.710002d-02,
     1     8.945242d-04,  6.217648d-06,  5.224517d-07,  9.012643d-04,
     1     9.021676d-03, -2.021173d-07, -2.932669d-08,  9.021444d-03,
     1     2.630571d-02,  4.132118d-03,  7.380911d-05,  7.007634d-06,
     1     5.526199d-04,
     1     1.543201d-02,  2.834740d-06,  1.264216d-07,  1.543497d-02,
     1     8.961228d-05,  9.129481d-08,  3.737669d-09,  8.970732d-05,
     1     1.794882d-03, -9.461272d-09, -1.366263d-09,  1.794871d-03,
     1     5.331486d-04,  2.767911d-05,  4.067031d-08,  5.749530d-09,
     1     2.019064d-06,
     1     4.260216d-04,  2.205101d-09,  2.118971d-10,  4.260240d-04,
     1     6.443325d-07,  7.238584d-12,  3.953842d-13,  6.443401d-07,
     1     4.856949d-05, -2.313013d-11, -3.266819d-12,  4.856946d-05,
     1     1.156048d-01,
     1     3.190836d-03,  1.953247d-03,  3.473258d+01,  1.587455d+01,
     1     2.201177d+02,
     1     1.388788d+01,  7.815316d+00,  2.127120d+00,  2.383031d+01,
     1     1.967157d+00,  1.140055d+00,  3.759921d-01,  3.483204d+00,
     1     1.216987d-03,  5.842237d-05,  1.032672d-05,  1.285736d-03,
     1     1.402360d-02,  8.275068d-03,  1.561758d+01,  6.724423d+00,
     1     8.880430d+01,
     1     6.196152d+00,  3.277247d+00,  8.588456d-01,  1.033224d+01,
     1     7.990587d-01,  4.571452d-01,  1.492077d-01,  1.405412d+00,
     1     5.036879d-03,  9.210426d-05,  1.628659d-05,  5.145269d-03,
     1     6.001981d-02,  3.451947d-02,  6.417382d+00,  2.449402d+00,
     1     3.040430d+01,
     1     2.543755d+00,  1.150017d+00,  2.901389d-01,  3.983911d+00,
     1     2.770198d-01,  1.534474d-01,  4.936234d-02,  4.798296d-01,
     1     2.030649d-02,  3.556791d-05,  6.313339d-06,  2.034837d-02,
     1     2.324380d-01,  1.299974d-01,  2.277848d+00,  6.674870d-01,
     1     7.791337d+00,
     1     1.003767d+00,  3.087566d-01,  7.035033d-02,  1.382874d+00,
     1     7.519275d-02,  3.650711d-02,  1.147385d-02,  1.231737d-01,
     1     7.436343d-02, -1.437377d-04, -2.544640d-05,  7.419424d-02,
     1     5.499397d-01,  2.703570d-01,  3.852689d-01,  6.446950d-02,
     1     8.526991d-01,
     1     4.497348d-01,  2.932930d-02,  5.430806d-03,  4.844949d-01,
     1     1.370115d-02,  2.583418d-03,  7.807236d-04,  1.706529d-02,
     1     1.688360d-01, -8.001085d-05, -1.421033d-05,  1.687418d-01,
     1     3.462267d-01,  1.283300d-01,  3.460208d-02,  4.014238d-03,
     1     7.890020d-02,
     1     2.073648d-01,  1.840480d-03,  2.820858d-04,  2.094873d-01,
     1     3.186824d-03,  1.064725d-04,  3.084640d-05,  3.324143d-03,
     1     1.065709d-01, -8.960165d-06, -1.597925d-06,  1.065603d-01,
     1     1.186825d-01,  3.081159d-02,  2.320056d-03,  2.376098d-04,
     1     7.639940d-03,
     1     7.012370d-02,  1.123144d-04,  1.499369d-05,  7.025101d-02,
     1     6.241731d-04,  4.289275d-06,  1.191305d-06,  6.296537d-04,
     1     3.763726d-02, -8.292541d-07, -1.477832d-07,  3.763628d-02,
     1     1.953016d-02,  2.988066d-03,  5.234923d-05,  5.558322d-06,
     1     3.709720d-04,
     1     1.239870d-02,  2.745677d-06,  3.235158d-07,  1.240177d-02,
     1     5.565310d-05,  6.121151d-08,  1.625297d-08,  5.573057d-05,
     1     6.653342d-03, -3.405429d-08, -6.152110d-09,  6.653302d-03,
     1     3.352261d-04,  1.693315d-05,  2.487667d-08,  3.907878d-09,
     1     1.171635d-06,
     1     2.717833d-04,  1.809788d-09,  2.686954d-10,  2.717853d-04,
     1     3.289261d-07, -7.467305d-13,  1.262383d-12,  3.289266d-07,
     1     1.441384d-04, -7.116949d-11, -1.186038d-11,  1.441383d-04 /
*
      call getapfelversion(apfelversion)
      write(6,*) achar(27)//"[34m"
      write(6,*) "Checking APFEL v",apfelversion," ...",achar(27)//"[0m"
*
*     Settings
*
c      call EnableWelcomeMessage(.false.)
      call SetMassScheme("FONLL-C")
      call SetProcessDIS("NC")
*
*     Initializes integrals on the grids
*
      call InitializeAPFEL_DIS
*
*     Compare the output with the reference
*
      Q0   = dsqrt(Q20) - eps
      iref = 0
      succ = .true.
      do iQ=1,4
         Q = dsqrt(Q2(iQ))
         call ComputeStructureFunctionsAPFEL(Q0,Q)
*     alpha_s
         iref = iref + 1
         if((Ref(iref)-AlphaQCD(Q))/Ref(iref).gt.toll)
     1        succ = .false.
*     PDF evolution
         do ilha=1,9
            iref = iref + 1
            if((Ref(iref)-(xPDFj(2,xlha(ilha))-xPDFj(-2,xlha(ilha))))
     1           /Ref(iref).gt.toll) succ = .false.
            iref = iref + 1
            if((Ref(iref)-(xPDFj(1,xlha(ilha))-xPDFj(-1,xlha(ilha))))
     1           /Ref(iref).gt.toll) succ = .false.
            iref = iref + 1
            if((Ref(iref)-2d0*(xPDFj(-1,xlha(ilha))
     1           +xPDFj(-2,xlha(ilha))))/Ref(iref).gt.toll)
     1           succ = .false.
            iref = iref + 1
            if((Ref(iref)-(xPDFj(4,xlha(ilha))+xPDFj(-4,xlha(ilha))))
     1           /Ref(iref).gt.toll) succ = .false.
            iref = iref + 1
            if((Ref(iref)-xPDFj(0,xlha(ilha)))/Ref(iref).gt.toll)
     1           succ = .false.
*     F_2
            iref = iref + 1
            if((Ref(iref)-F2light(xlha(ilha)))/Ref(iref).gt.toll)
     1           succ = .false.
            iref = iref + 1
            if((Ref(iref)-F2charm(xlha(ilha)))/Ref(iref).gt.toll)
     1           succ = .false.
            iref = iref + 1
            if((Ref(iref)-F2bottom(xlha(ilha)))/Ref(iref).gt.toll)
     1           succ = .false.
            iref = iref + 1
            if((Ref(iref)-F2total(xlha(ilha)))/Ref(iref).gt.toll)
     1           succ = .false.
*     F_L
            iref = iref + 1
            if((Ref(iref)-FLlight(xlha(ilha)))/Ref(iref).gt.toll)
     1           succ = .false.
            iref = iref + 1
            if((Ref(iref)-FLcharm(xlha(ilha)))/Ref(iref).gt.toll)
     1           succ = .false.
            iref = iref + 1
            if((Ref(iref)-FLbottom(xlha(ilha)))/Ref(iref).gt.toll)
     1           succ = .false.
            iref = iref + 1
            if((Ref(iref)-FLtotal(xlha(ilha)))/Ref(iref).gt.toll)
     1           succ = .false.
*     F_3
            iref = iref + 1
            if((Ref(iref)-F3light(xlha(ilha)))/Ref(iref).gt.toll)
     1           succ = .false.
            iref = iref + 1
            if((Ref(iref)-F3charm(xlha(ilha)))/Ref(iref).gt.toll)
     1           succ = .false.
            iref = iref + 1
            if((Ref(iref)-F3bottom(xlha(ilha)))/Ref(iref).gt.toll)
     1           succ = .false.
            iref = iref + 1
            if((Ref(iref)-F3total(xlha(ilha)))/Ref(iref).gt.toll)
     1           succ = .false.
         enddo
      enddo
*
      if(succ)then
         write(6,*) "Check ... ",
     1        achar(27)//"[1;32m","succeded",achar(27)//"[0m"
      else
         write(6,*) "Check ... ",
     1        achar(27)//"[1;31m","failed",achar(27)//"[0m"
      endif
      write(6,*)
      CheckAPFEL = succ
*
*     Code to write the reference table
*
c$$$      Q0 = dsqrt(Q20) - eps
c$$$      write(6,'(a)') "      Ref /"
c$$$      do iQ=1,4
c$$$         Q = dsqrt(Q2(iQ))
c$$$         call ComputeStructureFunctionsAPFEL(Q0,Q)
c$$$*     alpha_s
c$$$         write(6,'(a,es14.6,a)') "     1   ",AlphaQCD(Q),","
c$$$*     PDF evolution
c$$$         do ilha=1,9
c$$$            write(6,'(a,4(es14.6,a))') "     1   ",
c$$$     1           xPDFj(2,xlha(ilha)) - xPDFj(-2,xlha(ilha)),",",
c$$$     2           xPDFj(1,xlha(ilha)) - xPDFj(-1,xlha(ilha)),",",
c$$$     3           2d0*(xPDFj(-1,xlha(ilha)) + xPDFj(-2,xlha(ilha))),",",
c$$$     4           xPDFj(4,xlha(ilha)) + xPDFj(-4,xlha(ilha)),","
c$$$            write(6,'(a,es14.6,a)') "     1   ",
c$$$     1           xPDFj(0,xlha(ilha)),","
c$$$*     F_2
c$$$            write(6,'(a,4(es14.6,a))') "     1   ",
c$$$     1           F2light(xlha(ilha)),",",
c$$$     2           F2charm(xlha(ilha)),",",
c$$$     3           F2bottom(xlha(ilha)),",",
c$$$     4           F2total(xlha(ilha)),","
c$$$*     F_L
c$$$            write(6,'(a,4(es14.6,a))') "     1   ",
c$$$     1           FLlight(xlha(ilha)),",",
c$$$     2           FLcharm(xlha(ilha)),",",
c$$$     3           FLbottom(xlha(ilha)),",",
c$$$     4           FLtotal(xlha(ilha)),","
c$$$*     F_3
c$$$            write(6,'(a,4(es14.6,a))') "     1   ",
c$$$     1           F3light(xlha(ilha)),",",
c$$$     2           F3charm(xlha(ilha)),",",
c$$$     3           F3bottom(xlha(ilha)),",",
c$$$     4           F3total(xlha(ilha)),","
c$$$         enddo
c$$$      enddo
c$$$      write(6,'(a)') "      /"
*
      return
      end

