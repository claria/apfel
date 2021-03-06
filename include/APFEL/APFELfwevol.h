#ifndef APFELfw_H
#define APFELfw_H

// Declarations for the Fortran/C interface

#include "APFEL/FortranWrappers.h"

extern "C" {
  
#define finitializeapfel FC_FUNC(initializeapfel,INITIALIZEAPFEL)
  void finitializeapfel(void);

#define fevolveapfel FC_FUNC(evolveapfel,EVOLVEAPFEL)
  void fevolveapfel(double*,double*);

#define fderiveapfel FC_FUNC(deriveapfel,DERIVEAPFEL)
  void fderiveapfel(double*);

#define fxpdf FC_FUNC(xpdf,XPDF)
  double fxpdf(int*, double*);

#define fxpdfj FC_FUNC(xpdfj,XPDFJ)
  double fxpdfj(int*, double*);

#define fdxpdf FC_FUNC(dxpdf,DXPDF)
  double fdxpdf(int*, double*);

#define fxgamma FC_FUNC(xgamma,XGAMMA)
  double fxgamma(double*);

#define fxgammaj FC_FUNC(xgammaj,XGAMMAJ)
  double fxgammaj(double*);

#define fdxgamma FC_FUNC(dxgamma,DXGAMMA)
  double fdxgamma(double*);

#define fxpdfall FC_FUNC(xpdfall,XPDFALL)
  void fxpdfall(double*,double*);

#define fxlepton FC_FUNC(xlepton,XLEPTON)
  double fxlepton(int*, double*);

#define fxleptonj FC_FUNC(xleptonj,XLEPTONJ)
  double fxleptonj(int*, double*);

#define fexternalevolutionoperator FC_FUNC(externalevolutionoperator,EXTERNALEVOLUTIONOPERATOR)
  double fexternalevolutionoperator(char*,int*,int*,double*,int*);

#define flhapdfgrid FC_FUNC(lhapdfgrid,LHAPDFGRID)
  void flhapdfgrid(int*, double*, char*);

#define flhapdfgridderivative FC_FUNC(lhapdfgridderivative,LHAPDFGRIDDERIVATIVE)
  void flhapdfgridderivative(int*, char*);

#define falphaqcd FC_FUNC(alphaqcd,ALPHAQCD)
  double falphaqcd(double*);

#define falphaqed FC_FUNC(alphaqed,ALPHAQED)
  double falphaqed(double*);

#define fnpdf FC_FUNC(npdf,NPDF)
  double fnpdf(int*,int*);

#define fngamma FC_FUNC(ngamma,NGAMMA)
  double fngamma(int*);

#define flumi FC_FUNC(lumi,LUMI)
  double flumi(int*,int*,double*);

#define fxgrid FC_FUNC(xgrid,XGRID)
  double fxgrid(int*);

#define fnintervals FC_FUNC(nintervals,NINTERVALS)
  int fnintervals();

#define fcleanup FC_FUNC(cleanup,CLEANUP)
  void fcleanup(void);

#define fenablewelcomemessage FC_FUNC(enablewelcomemessage,ENABLEWELCOMEMESSAGE)
  void fenablewelcomemessage(int*);

#define fenableevolutionoperator FC_FUNC(enableevolutionoperator,ENABLEEVOLUTIONOPERATOR)
  void fenableevolutionoperator(int*);

#define fenableleptonevolution FC_FUNC(enableleptonevolution,ENABLELEPTONEVOLUTION)
  void fenableleptonevolution(int*);

#define flockgrids FC_FUNC(lockgrids,LOCKGRIDS)
  void flockgrids(int*);

#define fsettimelikeevolution FC_FUNC(settimelikeevolution,SETTIMELIKEEVOLUTION)
  void fsettimelikeevolution(int*);

#define fsetfastevolution FC_FUNC(setfastevolution,SETFASTEVOLUTION)
  void fsetfastevolution(int*);

#define fenablemassrunning FC_FUNC(enablemassrunning,ENABLEMASSRUNNING)
  void fenablemassrunning(int*);

#define fsetsmallxresummation FC_FUNC(setsmallxresummation,SETSMALLXRESUMMATION)
  void fsetsmallxresummation(int*,char*);

#define fheavyquarkmass FC_FUNC(heavyquarkmass,HEAVYQUARKMASS)
  double fheavyquarkmass(int*,double*);

#define fsetalphaqcdref FC_FUNC(setalphaqcdref,SETALPHAQCDREF)
  void fsetalphaqcdref(double*,double*);

#define fsetalphaqedref FC_FUNC(setalphaqedref,SETALPHAQEDREF)
  void fsetalphaqedref(double*,double*);

#define fsetalphaevolution FC_FUNC(setalphaevolution,SETALPHAEVOLUTION)
  void fsetalphaevolution(char*);

#define fsetlambdaqcdref FC_FUNC(setlambdaqcdref,SETLAMBDAQCDREF)
  void fsetlambdaqcdref(double*,int*);

#define fsetpdfevolution FC_FUNC(setpdfevolution,SETPDFEVOLUTION)
  void fsetpdfevolution(char*);

#define fsetepsilontruncation FC_FUNC(setepsilontruncation,SETEPSILONTRUNCATION)
  void fsetepsilontruncation(double*);

#define fsetqlimits FC_FUNC(setqlimits,SETQLIMITS)
  void fsetqlimits(double*,double*);

#define fsetffns FC_FUNC(setffns,SETFFNS)
  void fsetffns(int*);

#define fsetgridparameters FC_FUNC(setgridparameters,SETGRIDPARAMETERS)
  void fsetgridparameters(int*,int*,int*,double*);

#define fsetlhgridparameters FC_FUNC(setlhgridparameters,SETLHGRIDPARAMETERS)
  void fsetlhgridparameters(int*,int*,double*,double*,double*,int*,double*,double*);

#define fsetexternalgrid FC_FUNC(setexternalgrid,SETEXTERNALGRID)
  void fsetexternalgrid(int*,int*,int*,double*);

#define fsetmaxflavouralpha FC_FUNC(setmaxflavouralpha,SETMAXFLAVOURALPHA)
  void fsetmaxflavouralpha(int*);

#define fsetmaxflavourpdfs FC_FUNC(setmaxflavourpdfs,SETMAXFLAVOURPDFS)
  void fsetmaxflavourpdfs(int*);

#define fsetmsbarmasses FC_FUNC(setmsbarmasses,SETMSBARMASSES)
  void fsetmsbarmasses(double*,double*,double*);

#define fsetmassscalereference FC_FUNC(setmassscalereference,SETMASSSCALEREFERENCE)
  void fsetmassscalreference(double*,double*,double*);

#define fsetnumberofgrids FC_FUNC(setnumberofgrids,SETNUMBEROFGRIDS)
  void fsetnumberofgrids(int*);

#define fsetpdfset FC_FUNC(setpdfset,SETPDFSET)
  void fsetpdfset(char*);
  
#define fsetperturbativeorder FC_FUNC(setperturbativeorder,SETPERTURBATIVEORDER)
  void fsetperturbativeorder(int*);

#define fgetperturbativeorder FC_FUNC(getperturbativeorder,GETPERTURBATIVEORDER)
  int fgetperturbativeorder();

#define fsetpolemasses FC_FUNC(setpolemasses,SETPOLEMASSES)
  void fsetpolemasses(double*,double*,double*);

#define fsettaumass FC_FUNC(settaumass,SETTAUMASS)
  void fsettaumass(double*);

#define fsetrenfacratio FC_FUNC(setrenfacratio,SETRENFACRATIO)
  void fsetrenfacratio(double*);

#define fsetreplica FC_FUNC(setreplica,SETREPLICA)
  void fsetreplica(int*);

#define fsettheory FC_FUNC(settheory,SETTHEORY)
  void fsettheory(char*);

#define fsetvfns FC_FUNC(setvfns,SETVFNS)
  void fsetvfns();


#define flistfunctions FC_FUNC(listfunctions,LISTFUNCTIONS)
  void flistfunctions(void);

#define fgetapfelversion FC_FUNC(getapfelversion,GETAPFELVERSION)
  void fgetapfelversion(char*,int len);

#define fcheckapfel FC_FUNC(checkapfel,CHECKAPFEL)
  bool fcheckapfel(void);
}

#endif
