************************************************************************
*
*     FKSimulator.f:
*
*     This function returns simulates the FKgenerator of the NNPDF code.
*
************************************************************************
      function FKSimulator(x,Q,y,i,beta)
*
      implicit none
*
      include "../commons/consts.h"
      include "../commons/FKObservable.h"
**
*     Input Variables
*
      integer i,beta
      double precision x,Q,y
**
*     Internal Variables
*
      double precision ExternalDISOperator
      double precision GetWMass,GetZMass,GetGFermi,GetProtonMass
      double precision yp,ym,y2,ypc
      double precision Q2,MW,MW2,GF,GF2,MN
      double precision norm
      double precision conv
      parameter(conv=3.893793d10) ! conversion factor from GeV^-2 to 10^-38 cm^2
      character*15 obs
**
*     Output Variables
*
      double precision FKSimulator
*
      obs = FKObservable
*
*     Useful definitions
*
      MW = GetWMass()
      MN = GetProtonMass()
      GF = GetGFermi()
*
      Q2  = Q * Q
      MW2 = MW * MW
      GF2 = GF * GF
      yp  = 1d0 + ( 1d0 - y )**2d0
      ym  = 1d0 - ( 1d0 - y )**2d0
      y2  = y * y
*
****  Light structure function F2light
*
      if(obs(1:7).eq."DIS_F2L")then
         FKSimulator = ExternalDISOperator("F2",3,i,x,beta)
*
****  Up structure function F2u
*
      elseif(obs(1:7).eq."DIS_F2U")then
         FKSimulator = ExternalDISOperator("F2",3,i,x,beta)
*
****  Down structure function F2d
*
      elseif(obs(1:7).eq."DIS_F2d")then
         FKSimulator = ExternalDISOperator("F2",3,i,x,beta)
*
****  Strange structure function F2s
*
      elseif(obs(1:7).eq."DIS_F2S")then
         FKSimulator = ExternalDISOperator("F2",3,i,x,beta)
*
****  Charm structure function F2charm
*
      elseif(obs(1:7).eq."DIS_F2C")then
         FKSimulator = ExternalDISOperator("F2",4,i,x,beta)
*
****  Bottom structure function F2bottom
*
      elseif(obs(1:7).eq."DIS_F2B")then
         FKSimulator = ExternalDISOperator("F2",5,i,x,beta)
*
****  Top structure function F2top
*
      elseif(obs(1:7).eq."DIS_F2T")then
         FKSimulator = ExternalDISOperator("F2",6,i,x,beta)
*
****  Deuteron structure function F2
*
      elseif(obs(1:7).eq."DIS_F2D")then
         FKSimulator = ExternalDISOperator("F2",7,i,x,beta)
*
****  Light structure function FLlight
*
      elseif(obs(1:7).eq."DIS_FLL")then
         FKSimulator = ExternalDISOperator("FL",3,i,x,beta)
*
****  Charm structure function FLcharm
*
      elseif(obs(1:7).eq."DIS_FLC")then
         FKSimulator = ExternalDISOperator("FL",4,i,x,beta)
*
****  Bottom structure function FLbottom
*
      elseif(obs(1:7).eq."DIS_FLB")then
         FKSimulator = ExternalDISOperator("FL",5,i,x,beta)
*
****  Top structure function FLtop
*
      elseif(obs(1:7).eq."DIS_FLT")then
         FKSimulator = ExternalDISOperator("FL",6,i,x,beta)
*
****  Deuteron structure function FL
*
      elseif(obs(1:7).eq."DIS_FLD")then
         FKSimulator = ExternalDISOperator("FL",7,i,x,beta)
*
****  Proton structure function F2 (Neutral current)
*
      elseif(obs(1:10).eq."DIS_F2P_NC")then
         FKSimulator = ExternalDISOperator("F2",7,i,x,beta)
*
****  Proton structure function F2 (electromagnetic)
*
      elseif(obs(1:7).eq."DIS_F2P")then
         FKSimulator = ExternalDISOperator("F2",7,i,x,beta)
*
****  Proton structure function (Neutral current)
*
      elseif(obs(1:10).eq."DIS_FLP_NC".or.
     1       obs(1:14).eq."DIS_FLP_CON_NC")then
         FKSimulator = ExternalDISOperator("FL",7,i,x,beta)
*
****  Proton structure function FL (electromagnetic)
*
      elseif(obs(1:7).eq."DIS_FLP")then
         FKSimulator = ExternalDISOperator("FL",7,i,x,beta)
*
****  F3 structure function
*
      elseif(obs(1:10).eq."DIS_F3P_NC")then
         FKSimulator = ExternalDISOperator("F3",7,i,x,beta)
*
****  Electron scattering Reduced Cross-Section (light)
*
      elseif(obs(1:9).eq."DIS_NCE_L")then
         FKSimulator = ( ExternalDISOperator("F2",3,i,x,beta) 
     1        - ( y2 / yp ) * ExternalDISOperator("FL",3,i,x,beta)
     2        + ( ym / yp ) * ExternalDISOperator("F3",3,i,x,beta) )
*
****  Positron scattering Reduced Cross-Section (light)
*
      elseif(obs(1:9).eq."DIS_NCP_L")then
         FKSimulator = ( ExternalDISOperator("F2",3,i,x,beta) 
     1        - ( y2 / yp ) * ExternalDISOperator("FL",3,i,x,beta)
     2        - ( ym / yp ) * ExternalDISOperator("F3",3,i,x,beta) )
*
****  Electron scattering Reduced Cross-Section (charm)
*
      elseif(obs(1:10).eq."DIS_NCE_CH")then
         FKSimulator = ( ExternalDISOperator("F2",4,i,x,beta) 
     1        - ( y2 / yp ) * ExternalDISOperator("FL",4,i,x,beta)
     2        + ( ym / yp ) * ExternalDISOperator("F3",4,i,x,beta) )
*
****  Positron scattering Reduced Cross-Section (charm)
*
      elseif(obs(1:10).eq."DIS_NCP_CH")then
         FKSimulator = ( ExternalDISOperator("F2",4,i,x,beta) 
     1        - ( y2 / yp ) * ExternalDISOperator("FL",4,i,x,beta)
     2        - ( ym / yp ) * ExternalDISOperator("F3",4,i,x,beta) )
*
****  Electron scattering Reduced Cross-Section (bottom)
*
      elseif(obs(1:10).eq."DIS_NCE_BT")then
         FKSimulator = ( ExternalDISOperator("F2",5,i,x,beta) 
     1        - ( y2 / yp ) * ExternalDISOperator("FL",5,i,x,beta)
     2        + ( ym / yp ) * ExternalDISOperator("F3",5,i,x,beta) )
*
****  Positron scattering Reduced Cross-Section (bottom)
*
      elseif(obs(1:10).eq."DIS_NCP_BT")then
         FKSimulator = ( ExternalDISOperator("F2",5,i,x,beta) 
     1        - ( y2 / yp ) * ExternalDISOperator("FL",5,i,x,beta)
     2        - ( ym / yp ) * ExternalDISOperator("F3",5,i,x,beta) )
*
****  Electron scattering Reduced Cross-Section (top)
*
      elseif(obs(1:10).eq."DIS_NCE_TP")then
         FKSimulator = ( ExternalDISOperator("F2",6,i,x,beta) 
     1        - ( y2 / yp ) * ExternalDISOperator("FL",6,i,x,beta)
     2        + ( ym / yp ) * ExternalDISOperator("F3",6,i,x,beta) )
*
****  Positron scattering Reduced Cross-Section (top)
*
      elseif(obs(1:10).eq."DIS_NCP_TP")then
         FKSimulator = ( ExternalDISOperator("F2",6,i,x,beta) 
     1        - ( y2 / yp ) * ExternalDISOperator("FL",6,i,x,beta)
     2        - ( ym / yp ) * ExternalDISOperator("F3",6,i,x,beta) )
*
****  Electron scattering Reduced Cross-Section on deuteron (inclusive)
*
      elseif(obs(1:9).eq."DIS_NCE_D")then
         FKSimulator = ( ExternalDISOperator("F2",7,i,x,beta) 
     1        - ( y2 / yp ) * ExternalDISOperator("FL",7,i,x,beta)
     2        + ( ym / yp ) * ExternalDISOperator("F3",7,i,x,beta) )
*
****  Positron scattering Reduced Cross-Section on deuteron (inclusive)
*
      elseif(obs(1:9).eq."DIS_NCP_D")then
         FKSimulator = ( ExternalDISOperator("F2",7,i,x,beta) 
     1        - ( y2 / yp ) * ExternalDISOperator("FL",7,i,x,beta)
     2        - ( ym / yp ) * ExternalDISOperator("F3",7,i,x,beta) )
*
****  Electron scattering Reduced Cross-Section (inclusive)
*
      elseif(obs(1:7).eq."DIS_NCE")then
         FKSimulator = ( ExternalDISOperator("F2",7,i,x,beta) 
     1        - ( y2 / yp ) * ExternalDISOperator("FL",7,i,x,beta)
     2        + ( ym / yp ) * ExternalDISOperator("F3",7,i,x,beta) )
*
****  Positron scattering Reduced Cross-Section (inclusive)
*
      elseif(obs(1:7).eq."DIS_NCP")then
         FKSimulator = ( ExternalDISOperator("F2",7,i,x,beta) 
     1        - ( y2 / yp ) * ExternalDISOperator("FL",7,i,x,beta)
     2        - ( ym / yp ) * ExternalDISOperator("F3",7,i,x,beta) )
*
****  Electron scattering Reduced Cross-Section (light)
*
      elseif(obs(1:9).eq."DIS_CCE_L")then
         FKSimulator = ( yp * ExternalDISOperator("F2",3,i,x,beta) 
     1               -   y2 * ExternalDISOperator("FL",3,i,x,beta)
     2               +   ym * ExternalDISOperator("F3",3,i,x,beta) )
         FKSimulator = FKSimulator / 4d0
*
****  Positron scattering Reduced Cross-Section (light)
*
      elseif(obs(1:9).eq."DIS_CCP_L")then
         FKSimulator = ( yp * ExternalDISOperator("F2",3,i,x,beta) 
     1               -   y2 * ExternalDISOperator("FL",3,i,x,beta)
     2               -   ym * ExternalDISOperator("F3",3,i,x,beta) )
         FKSimulator = FKSimulator / 4d0
*
****  Electron scattering Reduced Cross-Section (charm)
*
      elseif(obs(1:9).eq."DIS_CCE_C")then
         FKSimulator = ( yp * ExternalDISOperator("F2",4,i,x,beta) 
     1               -   y2 * ExternalDISOperator("FL",4,i,x,beta)
     2               +   ym * ExternalDISOperator("F3",4,i,x,beta) )
         FKSimulator = FKSimulator / 4d0
*
****  Positron scattering Reduced Cross-Section (charm)
*
      elseif(obs(1:9).eq."DIS_CCP_C")then
         FKSimulator = ( yp * ExternalDISOperator("F2",4,i,x,beta) 
     1               -   y2 * ExternalDISOperator("FL",4,i,x,beta)
     2               -   ym * ExternalDISOperator("F3",4,i,x,beta) )
         FKSimulator = FKSimulator / 4d0
*
****  Electron scattering Reduced Cross-Section (inclusive)
*
      elseif(obs(1:7).eq."DIS_CCE")then
         FKSimulator = ( yp * ExternalDISOperator("F2",7,i,x,beta) 
     1               -   y2 * ExternalDISOperator("FL",7,i,x,beta)
     2               +   ym * ExternalDISOperator("F3",7,i,x,beta) )
         FKSimulator = FKSimulator / 4d0
*
****  Positron scattering Reduced Cross-Section (inclusive)
*
      elseif(obs(1:7).eq."DIS_CCP")then
         FKSimulator = ( yp * ExternalDISOperator("F2",7,i,x,beta) 
     1               -   y2 * ExternalDISOperator("FL",7,i,x,beta)
     2               -   ym * ExternalDISOperator("F3",7,i,x,beta) )
         FKSimulator = FKSimulator / 4d0
*
****  Neutrino scattering Reduced Cross-Section (light)
*
      elseif(obs(1:9).eq."DIS_SNU_L")then
         ypc  = yp - 2d0 * ( MN * x * y )**2d0 / Q2
         norm = conv * GF2 * MN / ( 2d0 * pi * ( 1d0 + Q2 / MW2 )**2d0 )
         FKSimulator = ( ypc * ExternalDISOperator("F2",3,i,x,beta) 
     1               -   y2  * ExternalDISOperator("FL",3,i,x,beta)
     2               +   ym  * ExternalDISOperator("F3",3,i,x,beta) )
         FKSimulator = norm * FKSimulator
*
****  Antineutrino scattering Reduced Cross-Section (light)
*
      elseif(obs(1:9).eq."DIS_SNB_L")then
         ypc  = yp - 2d0 * ( MN * x * y )**2d0 / Q2
         norm = conv * GF2 * MN / ( 2d0 * pi * ( 1d0 + Q2 / MW2 )**2d0 )
         FKSimulator = ( ypc * ExternalDISOperator("F2",3,i,x,beta) 
     1               -   y2  * ExternalDISOperator("FL",3,i,x,beta)
     2               -   ym  * ExternalDISOperator("F3",3,i,x,beta) )
         FKSimulator = norm * FKSimulator
*
****  Neutrino scattering Reduced Cross-Section (charm)
*
      elseif(obs(1:9).eq."DIS_SNU_C")then
         ypc  = yp - 2d0 * ( MN * x * y )**2d0 / Q2
         norm = conv * GF2 * MN / ( 2d0 * pi * ( 1d0 + Q2 / MW2 )**2d0 )
         FKSimulator = ( ypc * ExternalDISOperator("F2",4,i,x,beta) 
     1               -   y2  * ExternalDISOperator("FL",4,i,x,beta)
     2               +   ym  * ExternalDISOperator("F3",4,i,x,beta) )
         FKSimulator = norm * FKSimulator
*
****  Antineutrino scattering Reduced Cross-Section (charm)
*
      elseif(obs(1:9).eq."DIS_SNB_C")then
         ypc  = yp - 2d0 * ( MN * x * y )**2d0 / Q2
         norm = conv * GF2 * MN / ( 2d0 * pi * ( 1d0 + Q2 / MW2 )**2d0 )
         FKSimulator = ( ypc * ExternalDISOperator("F2",4,i,x,beta) 
     1               -   y2  * ExternalDISOperator("FL",4,i,x,beta)
     2               -   ym  * ExternalDISOperator("F3",4,i,x,beta) )
         FKSimulator = norm * FKSimulator
*
****  Neutrino scattering Reduced Cross-Section (inclusive)
*
      elseif(obs(1:7).eq."DIS_SNU")then
         ypc  = yp - 2d0 * ( MN * x * y )**2d0 / Q2
         norm = conv * GF2 * MN / ( 2d0 * pi * ( 1d0 + Q2 / MW2 )**2d0 )
         FKSimulator = ( ypc * ExternalDISOperator("F2",7,i,x,beta) 
     1               -   y2  * ExternalDISOperator("FL",7,i,x,beta)
     2               +   ym  * ExternalDISOperator("F3",7,i,x,beta) )
         FKSimulator = norm * FKSimulator
*
****  Antineutrino scattering Reduced Cross-Section (inclusive)
*
      elseif(obs(1:7).eq."DIS_SNB")then
         ypc  = yp - 2d0 * ( MN * x * y )**2d0 / Q2
         norm = conv * GF2 * MN / ( 2d0 * pi * ( 1d0 + Q2 / MW2 )**2d0 )
         FKSimulator = ( ypc * ExternalDISOperator("F2",7,i,x,beta) 
     1               -   y2  * ExternalDISOperator("FL",7,i,x,beta)
     2               -   ym  * ExternalDISOperator("F3",7,i,x,beta) )
         FKSimulator = norm * FKSimulator
*
****  Dimuon neutrino and anti-neutrino cross section
*
************************************************************************
*
*     Note that NuTev dimuon data is given by the generator as:
*     
*                PI          dsigma^{2\mu}             1     1
*     100 * ------------ *  --------------- (E,x,y) * --- * ---   
*           G^2 M_p E_nu         dx dy                BrC   Acc
*     
*     Therefore, experimental acceptances and branching ratios are
*     corrected at the level of experimental data.
*     So we can compare directly with charm production expressions:
*
*         dsigma^{2\mu}            1     1        dsigma^{\nu, c}
*        -------------- (E,x,y) * --- * --- =   ----------------- 
*           dx dy                 BrC   Acc           dx dy
*
*     So by comparing with Eq. (116) of the "Notes on physical observables"
*     we find that one needs to multiply the output of the SIGMA_DM below 
*     by an overall factor:
*
*        dsigma^{\nu, c} |                 100        dsigma^{\nu, c} |
*        --------------- |        = --------------- * --------------- | 
*             dx dy      |_{data}   2*(1+Q2/MW2)**2        dx dy      |_{code}
*     
************************************************************************
*
****  Dimuon neutrino cross section
*
      elseif(obs(1:9).eq."DIS_DM_NU".or.obs(1:11).eq."DIS_DMN_CON")then
         ypc  = yp - 2d0 * ( MN * x * y )**2d0 / Q2
         norm = 100d0 / 2d0 / ( 1d0 + Q2 / MW2 )**2d0 
         FKSimulator = ( ypc * ExternalDISOperator("F2",4,i,x,beta) 
     1               -   y2  * ExternalDISOperator("FL",4,i,x,beta)
     2               +   ym  * ExternalDISOperator("F3",4,i,x,beta) )
         FKSimulator = norm * FKSimulator
*
****  Dimuon anti-neutrino cross section
*
      elseif(obs(1:9).eq."DIS_DM_NB")then
         ypc  = yp - 2d0 * ( MN * x * y )**2d0 / Q2
         norm = 100d0 / 2d0 / ( 1d0 + Q2 / MW2 )**2d0 
         FKSimulator = ( ypc * ExternalDISOperator("F2",4,i,x,beta) 
     1               -   y2  * ExternalDISOperator("FL",4,i,x,beta)
     2               -   ym  * ExternalDISOperator("F3",4,i,x,beta) )
         FKSimulator = norm * FKSimulator
      else
         write(6,*) "In FKSimulator.f:"
         write(6,*) "Invalid observable, obs = ",obs
         write(6,*) "  "
         call exit(-10)
      endif
*
      return
      end
