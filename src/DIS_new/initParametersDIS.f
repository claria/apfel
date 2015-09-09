************************************************************************
*
*     initParametersDIS.f:
*
*     It sets all the parameters for the computation of the DIS structure
*     functions if they were not set exernally before by the user.
*
************************************************************************
      subroutine initParametersDIS
*
      implicit none
*
      include "../commons/Welcome.h"
      include "../commons/MassScheme.h"
      include "../commons/ProcessDIS.h"
      include "../commons/PolarizationDIS.h"
      include "../commons/ProjectileDIS.h"
      include "../commons/TargetDIS.h"
      include "../commons/Nf_FF.h"
      include "../commons/ZedMass.h"
      include "../commons/WMass.h"
      include "../commons/ProtonMass.h"
      include "../commons/SinThetaW.h"
      include "../commons/GFermi.h"
      include "../commons/CKM.h"
      include "../commons/TMC.h"
      include "../commons/DampingFONLL.h"
      include "../commons/TimeLike.h"
      include "../commons/SelectedCharge.h"
      include "../commons/krenQ.h"
      include "../commons/kfacQ.h"
      include "../commons/PropagatorCorrection.h"
      include "../commons/EWCouplings.h"
      include "../commons/DynScVar.h"
*
*     Initialize default parameters (those that were not initialized before)
*
      if(InWelcome.ne."done")        call EnableWelcomeMessage(.true.)
      if(InMassScheme.ne."done")     call SetMassScheme("ZM-VFNS")
      if(InProcessDIS.ne."done")     call SetProcessDIS("EM")
      if(InPolarizationDIS.ne."done")call SetPolarizationDIS(0d0)
      if(InProjectileDIS.ne."done")  call SetProjectileDIS("electron")
      if(InTargetDIS.ne."done")      call SetTargetDIS("proton")
      if(InSelectedCharge.ne."done") call SelectCharge("all")
      if(InKrenQ.ne."done")          call SetRenQRatio(1d0)
      if(InKfacQ.ne."done")          call SetFacQRatio(1d0)
      if(InDynScVar.ne."done")       call EnableDynamicalScaleVariations
     1                                    (.false.)
      if(InDampingFONLL.ne."done")   call EnableDampingFONLL(.true.)
      if(InTMC.ne."done")            call EnableTargetMassCorrections
     1                                     (.false.)
*
      if(InMZ.ne."done")             call SetZMass(91.1876d0)
      if(InMW.ne."done")             call SetWMass(80.385d0)
      if(InMProton.ne."done")        call SetProtonMass(0.938272046d0)
      if(InSinThetaW.ne."done")      call SetSinThetaW(0.23126d0)
      if(InGFermi.ne."done")         call SetGFermi(1.1663787d-5)
      if(InCKM.ne."done")            call SetCKM(
     1                               0.97427d0, 0.22536d0, 0.00355d0,
     2                               0.22522d0, 0.97343d0, 0.04140d0,
     3                               0.00886d0, 0.04050d0, 0.99914d0)
      if(InDeltaR.ne."done")         call SetPropagatorCorrection(0d0)
      if(InEWCouplings.ne."done")    call SetEWCouplings(0d0,0d0,
     1                                                   0d0,0d0)
*
*     Check the consistency of the input parameters
*
      write(6,*) "  "
      if(MassScheme.ne."ZM-VFNS".and.
     1   MassScheme(1:4).ne."FFNS".and.
     2   MassScheme(1:4).ne."FFN0".and.
     3   MassScheme.ne."FONLL-A".and.
     4   MassScheme.ne."FONLL-B".and.
     5   MassScheme.ne."FONLL-C")then
         write(6,*) achar(27)//"[31mERROR:"
         write(6,*) "Mass scheme unknown:"
         write(6,*) "MassScheme = ",MassScheme
         write(6,*) "  "
         write(6,*) "The options are:"
         write(6,*) "- 'ZM-VFNS'"
         write(6,*) "- 'FFNS' (default NF=3)"
         write(6,*) "- 'FFNS3'"
         write(6,*) "- 'FFNS4'"
         write(6,*) "- 'FFNS5'"
         write(6,*) "- 'FFNS6'"
         write(6,*) "- 'FFN0' (default NF=3)"
         write(6,*) "- 'FFN03'"
         write(6,*) "- 'FFN04'"
         write(6,*) "- 'FFN05'"
         write(6,*) "- 'FFN06'"
         write(6,*) "- 'FONLL-A'"
         write(6,*) "- 'FONLL-B'"
         write(6,*) "- 'FONLL-C'"
         write(6,*) achar(27)//"[0m"
         call exit(-10)
      endif
*
      if(ProcessDIS.ne."EM".and.
     1   ProcessDIS.ne."NC".and.
     2   ProcessDIS.ne."CC")then
         write(6,*) achar(27)//"[31mERROR:"
         write(6,*) "DIS process unknown:"
         write(6,*) "ProcessDIS = ",ProcessDIS
         write(6,*) "  "
         write(6,*) "The options are:"
         write(6,*) "- 'EM'"
         write(6,*) "- 'NC'"
         write(6,*) "- 'CC'"
         write(6,*) achar(27)//"[0m"
         call exit(-10)
      endif
*
      if(dabs(PolarizationDIS).gt.1d0)then
         write(6,*) achar(27)//"[31mERROR:"
         write(6,*) "Polarization fraction not allowed:"
         write(6,*) "PolarizationDIS = ",PolarizationDIS
         write(6,*) "  "
         write(6,*) "PolarizationDIS must be between 1 and -1"
         write(6,*) achar(27)//"[0m"
         call exit(-10)
      endif
*
      if(ProjectileDIS(1:8).ne."electron".and.
     1   ProjectileDIS(1:8).ne."positron".and.
     2   ProjectileDIS(1:8).ne."neutrino".and.
     3   ProjectileDIS.ne."antineutrino")then
         write(6,*) achar(27)//"[31mERROR:"
         write(6,*) "Projectile unknown:"
         write(6,*) "ProjectileDIS = ",ProjectileDIS
         write(6,*) "  "
         write(6,*) "The options are:"
         write(6,*) "- 'electron'"
         write(6,*) "- 'positron'"
         write(6,*) "- 'neutrino'"
         write(6,*) "- 'antineutrino'"
         write(6,*) achar(27)//"[0m"
         call exit(-10)
      endif
*
      if(TargetDIS(1:6).ne."proton".and.
     1   TargetDIS(1:7).ne."neutron".and.
     2   TargetDIS.ne."isoscalar".and.
     3   TargetDIS(1:4).ne."iron")then
         write(6,*) achar(27)//"[31mERROR:"
         write(6,*) "Target unknown:"
         write(6,*) "TargetDIS = ",TargetDIS
         write(6,*) "  "
         write(6,*) "The options are:"
         write(6,*) "- 'proton'"
         write(6,*) "- 'neutron'"
         write(6,*) "- 'isoscalar'"
         write(6,*) "- 'iron'"
         write(6,*) achar(27)//"[0m"
         call exit(-10)
      endif
*
      if(SelectedCharge(1:4).ne."down".and.
     1   SelectedCharge(1:2).ne."up".and.
     2   SelectedCharge(1:7).ne."strange".and.
     3   SelectedCharge(1:5).ne."charm".and.
     4   SelectedCharge(1:6).ne."bottom".and.
     5   SelectedCharge(1:3).ne."top".and.
     6   SelectedCharge(1:3).ne."all")then
         write(6,*) achar(27)//"[31mERROR:"
         write(6,*) "Selected charge unknown:"
         write(6,*) "SelectedCharge = ",SelectedCharge
         write(6,*) "  "
         write(6,*) "The options are:"
         write(6,*) "- 'down'"
         write(6,*) "- 'up'"
         write(6,*) "- 'strange'"
         write(6,*) "- 'charm'"
         write(6,*) "- 'bottom'"
         write(6,*) "- 'top'"
         write(6,*) "- 'all'"
         write(6,*) achar(27)//"[0m"
         call exit(-10)
      endif
*
*     Additional settings
*
      if(krenQ.ne.1d0.or.kfacQ.ne.1d0)then
         call SetRenFacRatio(dsqrt(krenQ/kfacQ))
      endif
*
*     Ensure that for the time-like evolution only proper settings are used
*
      if(InTimeLike.eq."done".and.TimeLike)then
         if(MassScheme.ne."ZM-VFNS")then
            write(6,*) achar(27)//"[33m"//
     1                 "WARNING: The computation of the SIA structure ",
     2                 "functions available only in the ZM-VFNS."
            write(6,*) "         ... setting ZM-VFNS."
     1                 //achar(27)//"[0m"
            call SetMassScheme("ZM-VFNS")
         endif
         if(TMC)then
            write(6,*) achar(27)//"[33m"//
     1                 "WARNING: The computation of the SIA structure ",
     2                 "functions does not allow the inclusion"
            write(6,*) "         of the target mass corrections (TMCs)."
            write(6,*) "         ... switching off TMCs."
     1                 //achar(27)//"[0m"
            call EnableTargetMassCorrections(.false.)
         endif
         if(ProjectileDIS(1:8).ne."electron")then
            write(6,*) achar(27)//"[33m"//
     1                 "WARNING: The computation of the SIA structure ",
     2                 "functions is possible only using"
            write(6,*) "         electrons as projectiles."
            write(6,*) "         ... setting 'elelectron' projectile"
     1                 //achar(27)//"[0m"
            call SetProjectileDIS("electron")
         endif
         if(TargetDIS(1:6).ne."proton")then
            write(6,*) achar(27)//"[33m"//
     1                 "WARNING: The computation of the SIA structure ",
     2                 "functions is possible only using protons"
            write(6,*) "         as targets."
            write(6,*) "         ... setting 'proton' targets"
     1                 //achar(27)//"[0m"
            call SetTargetDIS("proton")
         endif
         if(PolarizationDIS.ne.0d0)then
            write(6,*) achar(27)//"[33m"//
     1                 "WARNING: The computation of the SIA structure ",
     2                 "functions is possible only for"
            write(6,*) "         unpolarized beams."
            write(6,*) "         ... setting polarization to zero."
     1                 //achar(27)//"[0m"
            call SetPolarizationDIS(0d0)
         endif
         if(ProcessDIS.eq."CC")then
            write(6,*) achar(27)//"[33m"//
     1                 "WARNING: The computation of the SIA structure ",
     2                 "functions is not available for CC"
            write(6,*) "         processes."
            write(6,*) "         ... setting EM process."
     1                 //achar(27)//"[0m"
            call SetProcessDIS("EM")
         endif
      endif
      if(MassScheme(1:4).eq."FFNS".or.
     1   MassScheme(1:4).eq."FFN0")then
         write(6,*) achar(27)//"[33m"//
     1              "WARNING: ",MassScheme(1:4)," is a FFN scheme"
         if(MassScheme(5:5).eq."3")then
            write(6,*) achar(27)//"[33m"//
     1                 "         ... setting NF = 3 FFNS PDF evolution"
     2                 //achar(27)//"[0m"
            call SetFFNS(3)
         elseif(MassScheme(5:5).eq."4")then
            write(6,*) achar(27)//"[33m"//
     1                 "         ... setting NF = 4 FFNS PDF evolution"
     2                 //achar(27)//"[0m"
            call SetFFNS(4)
         elseif(MassScheme(5:5).eq."5")then
            write(6,*) achar(27)//"[33m"//
     1                 "         ... setting NF = 5 FFNS PDF evolution"
     2                 //achar(27)//"[0m"
            call SetFFNS(5)
         elseif(MassScheme(5:5).eq."6")then
            write(6,*) achar(27)//"[33m"//
     1                 "         ... setting NF = 6 FFNS PDF evolution"
     2                 //achar(27)//"[0m"
            call SetFFNS(6)
         else
            write(6,*) achar(27)//"[33m"//
     1                 "         ... setting NF = 3 FFNS PDF evolution"
     2                 //achar(27)//"[0m"
            call SetFFNS(3)
         endif
      else
*     If the number of active flavours has not been specified (by means of SetFFNS)
*     set it automatically to 3.
         if(Nf_FF.lt.3.or.Nf_FF.gt.6) Nf_FF = 3
         write(6,*) achar(27)//"[33m"//
     1              "WARNING: ",MassScheme," is a VFN scheme"
         write(6,*) "         ... setting VFNS PDF evolution"
     1              //achar(27)//"[0m"
         call SetVFNS
         if(MassScheme.eq."FONLL-A")then
            write(6,*) achar(27)//"[33m"//
     1                 "WARNING: For the FONLL-A scheme the",
     2                 " perturbative order will automatically be",
     3                 " set to NLO"
            write(6,*) "         ... setting NLO perturbative order"
     1                 //achar(27)//"[0m"
            call SetPerturbativeOrder(1)
         endif
         if(MassScheme.eq."FONLL-B")then
            write(6,*) achar(27)//"[33m"//
     1                 "WARNING: For the FONLL-B scheme the",
     2                 " perturbative order will automatically be",
     3                 " set to NLO"
            write(6,*) "         ... setting NLO perturbative order"
     1                 //achar(27)//"[0m"
            call SetPerturbativeOrder(1)
         endif
         if(MassScheme.eq."FONLL-C")then
            write(6,*) achar(27)//"[33m"//
     1                 "WARNING: For the FONLL-C scheme the",
     2                 " perturbative order will automatically be",
     3                 " set to NNLO"
            write(6,*) "         ... setting NNLO perturbative order"
     1                 //achar(27)//"[0m"
            call SetPerturbativeOrder(2)
         endif
      endif
*
*     Avoid that the propagator correction is equal to one
*
      if(DeltaR.eq.1d0)then
         write(6,*) achar(27)//"[33m"//
     1        "WARNING: The propagator correction cannot be equal to",
     2        " one"
         write(6,*) "         ... setting propagator correction to zero"
     1        //achar(27)//"[0m"
         call SetPropagatorCorrection(0d0)
      endif
*
*     Inform the user that if the dynamical scale variation has been enabled
*     the factorization and the renormalization scales will be set equal
*
      if(DynScVar)then
         write(6,*) achar(27)//"[33m"//
     1        "WARNING: The dynamical scale variation has been enabled"
         write(6,*) "         ... factorization and renormalization",
     1              " scales will be set equal."
         write(6,*) "          (in particular mu_R = mu_F)"
     2        //achar(27)//"[0m"
         call SetRenQRatio(dsqrt(kfacQ))
      endif
*
      return
      end
