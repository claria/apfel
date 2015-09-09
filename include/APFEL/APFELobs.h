#ifndef APFELOBS_H
#define APFELOBS_H

#include <string>
#include <iostream>
using std::string;

/**
 * @mainpage A C++ wrapper for the APFEL library
 *
 * @section intro Introduction
 * The APFEL library provides a set of C++ wrapper functions
 * for its Fortran subroutines.
 */

/// Namespace containing all the APFEL wrapper functions.
namespace APFEL {

  /*
   * DIS module
   */

  /// DIS observables
  void DIS_xsec(double x,double qi,double qf,double y,double pol,
		const std::string& proc,const std::string& scheme,
		int pto,const std::string& pdfset, int irep,
		const std::string& target, const std::string& proj,
		double *F2, double *F3, double *FL, double *sigma);

  /*
   * New DIS module
   */

  /// Initialize the new DIS module
  void InitializeAPFEL_DIS();

  /// Precompute the structure functions
  void ComputeStructureFunctionsAPFEL(double Q0, double Q);

  /// Set the mass scheme for the structure functions
  void SetMassScheme(const std::string& ms);

  /// Set the polarization
  void SetPolarizationDIS(double pol);

  // Set the process of the structure functions (EM, NC or CC)
  void SetProcessDIS(const std::string& pr);

  /// Set the projectile
  void SetProjectileDIS(const std::string& lept);

  /// Set the target
  void SetTargetDIS(const std::string& tar);

  /// Select a given charge contribution
  void SelectCharge(const std::string& selch);

  /// Returns the DIS operator times the evolution factors on the grid
  double ExternalDISOperator(const std::string& SF,int ihq,int i,double x,int beta);

  /// Structure functions
  double F2light(double x);
  double F2charm(double x);
  double F2bottom(double x);
  double F2top(double x);
  double F2total(double x);

  double FLlight(double x);
  double FLcharm(double x);
  double FLbottom(double x);
  double FLtop(double x);
  double FLtotal(double x);

  double F3light(double x);
  double F3charm(double x);
  double F3bottom(double x);
  double F3top(double x);
  double F3total(double x);

  /// Set the value of the Z mass in GeV
  void SetZMass(double massz);

  /// Set the value of the W mass in GeV
  void SetWMass(double massw);

  /// Set the value of the proton mass in GeV
  void SetProtonMass(double massp);

  /// Set the value of sin(theta_W)
  void SetSinThetaW(double sw);

  /// Set the absolute value of the entries of the CKM matrix
  void SetCKM(double vud,double vus,double vub,double vcd,double vcs,double vcb,double vtd,double vts,double vtb);

  /// Set the the correction to the Z propagator
  void SetPropagatorCorrection(double dr);

  /// Set the EW vector and axial couplings
  void SetEWCouplings(double vd,double vu,double ad,double au);

  /// Set the value of the Fermi constant
  void SetGFermi(double gf);

  /// Sets the ratio between renormalization scale and Q
  void SetRenQRatio(double ratioR);

  /// Sets the ratio between factorization scale and Q
  void SetFacQRatio(double ratioF);

  /// Enables the posibility to vary scales dynamically
  void EnableDynamicalScaleVariations(int);

  // Returns the mass of the Z
  double GetZMass();

  // Returns the mass of the W
  double GetWMass();

  // Returns the mass of the proton
  double GetProtonMass();

  // Returns sin(\theta_W)
  double GetSinThetaW();

  // Returns the entries of the CKM matrix
  double GetCKM(int u, int d);

  // Returns G_{Fermi}
  double GetGFermi();

  // Returns the SIA total cross section
  double GetSIATotalCrossSection(int pto, double q);

  /// Enables the target mass corrections
  void EnableTargetMassCorrections(int);

  /// Enables the FONLL damping factor
  void EnableDampingFONLL(int);

  /// Emulator of the FKgenerator
  double FKSimulator(double x,double q,double y,int i,int beta);

  /// Set the observable for FKgenerator simulator
  void SetFKObservable(const std::string& obs);

  /// Get the observable used by the FKgenerator simulator
  void GetFKObservable();

  /// Observable according to the FKgenerator naming
  double FKObservables(double x,double q,double y);
						
  /// Functions for FTDY
  void ComputeFKTables(const std::string& inputfile, const std::string& outputpath,
		       double Q0, int* flmap);

  void ComputeHardCrossSectionsDY(const std::string& datafile, 
				  const std::string& outputfile);
}

#endif
