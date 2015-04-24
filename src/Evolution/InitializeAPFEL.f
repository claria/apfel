************************************************************************
*
*     InitializeAPFEL.f:
*
*     This routine initializes the integrals needed to evolve PDFs
*     on the grids.
*
************************************************************************
      subroutine InitializeAPFEL(kappa)
*
      implicit none
*
      include "../commons/Welcome.h"
      include "../commons/grid.h"
      include "../commons/m2th.h"
      include "../commons/Th.h"
      include "../commons/Evs.h"
      include "../commons/Nf_FF.h"
      include "../commons/scales.h"
      include "../commons/Smallx.h"
      include "../commons/kappa2DIRE.h"
**
*     Input Variables
*
      double precision kappa
**
*     Internal Variables
*
      integer inf,nfi,nff,inl
      double precision t1,t2
*
*     Parameter of the DIRE evolution
*
      kappa2DIRE = kappa * kappa
*
      call cpu_time(t1)
*
*     Read input parameters
*
      call initParameters
*
*     Initialize alphas grid if needed
*
      if(Smallx) call initGridAlpha
*
      do igrid=1,ngrid
*
*     Initialize x-space grid
*
         call initGrid
*
*     Initalize spliting functions integral matrices for the given nf
*
*     Fixed Flavour Number Scheme
         if(Evs.eq."FF")then
            nfi = Nf_FF
            nff = Nf_FF
*     Variable Flavour Number Scheme
         elseif(Evs.eq."VF")then
            if(Q2max.gt.m2th(6))then
               nff = 6
            elseif(Q2max.gt.m2th(5))then
               nff = 5
            elseif(Q2max.gt.m2th(4))then
               nff = 4
            else
               nff = 3
            endif
*
            if(Q2min.gt.m2th(6))then
               nfi = 6
            elseif(Q2min.gt.m2th(5))then
               nfi = 5
            elseif(Q2min.gt.m2th(4))then
               nfi = 4
            else
               nfi = 3
            endif
*     Initialize matching conditions in case the theory is nor "QED"
            if(Th.ne."QED") call initIntegralsMatching
         endif
*
*     Evaluate evolution operators on the grid
*
         if(Th.eq."QCD")then
            do inf=nfi,nff
               call initIntegralsQCD(inf)
            enddo
            if(Smallx) call initIntegralsQCDRes
         elseif(Th.eq."QED")then
            do inf=nfi,nff
               do inl=2,3
                  call initIntegralsQED(inf,inl)
               enddo
            enddo
         elseif(Th.eq."QCEDP".or.Th.eq."QCEDS".or.
     1          Th.eq."QECDP".or.Th.eq."QECDS".or.
     2          Th.eq."QavDP".or.Th.eq."QavDS".or.
     3          Th.eq."QUniD")then
            do inf=nfi,nff
               call initIntegralsQCD(inf)
               do inl=2,3
                  call initIntegralsQED(inf,inl)
               enddo
            enddo
            if(Smallx) call initIntegralsQCDRes
         endif
      enddo
      call cpu_time(t2)
*
      if(Welcome)then
         write(6,"(a,a,f7.3,a)") " Initialization of the evolution",
     1                           " completed in",t2-t1," s"
         write(6,*) " "
      endif
*
      return
      end
