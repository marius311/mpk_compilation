F90C   = gfortran
FFLAGS = -ffree-line-length-0 -O2
LIBS   = -L/usr/lib/x86_64-linux-gnu -lgsl -lgslcblas -lm

#Files containing evolution equations initial power spectrum module
EQUATIONS     = equations
POWERSPECTRUM = power_tilt
REIONIZATION = reionization
RECOMBINATION = recfast

#Module doing non-linear scaling
NONLINEAR     = halofit

#Driver program
DRIVER        = inidriver.F90
#DRIVER        = sigma8.f90
#DRIVER        = tester.f90

#Settings for building camb_fits
#Location of FITSIO and name of library
FITSDIR       = /home/cpac/cpac-tools/lib
FITSLIB       = cfitsio
#Location of HEALPIX for building camb_fits
HEALPIXDIR    = /home/cpac/cpac-tools/healpix

CAMBLIB       = libcamb.a

#Shouldn't need to change anything else...

F90FLAGS      = $(FFLAGS)
HEALPIXLD     = -L$(HEALPIXDIR)/lib -lhealpix -L$(FITSDIR) -l$(FITSLIB)
FC            = $(F90C)

CAMBOBJ       = constants.o utils.o subroutines.o inifile.o $(POWERSPECTRUM).o $(RECOMBINATION).o $(REIONIZATION).o modules.o \
	bessels.o $(EQUATIONS).o $(NONLINEAR).o lensing.o cmbmain.o camb.o bsplinepk.o

default: camb

all: camb $(CAMBLIB)


subroutines.o: constants.o utils.o
$(POWERSPECTRUM): subroutines.o
$(RECOMBINATION).o: subroutines.o
$(REIONIZATION).o: constants.o
modules.o: $(REIONIZATION).o bsplinepk.o
bessels.o: modules.o
$(EQUATIONS): bessels.o
$(NONLINEAR).o:  modules.o
lensing.o: bessels.o
cmbmain.o: lensing.o
camb.o: cmbmain.o


camb: $(CAMBOBJ) $(DRIVER)
	$(F90C) $(F90FLAGS) $(CAMBOBJ) $(DRIVER) -o $@ $(LIBS)

$(CAMBLIB): $(CAMBOBJ)
	ar -r $@ $?

camb_fits: writefits.f90 $(CAMBOBJ) $(DRIVER)
	$(F90C) $(F90FLAGS) -I$(HEALPIXDIR)/include $(CAMBOBJ) writefits.f90 $(DRIVER) $(HEALPIXLD) -DWRITE_FITS -o $@

%.o: %.f90
	$(F90C) $(F90FLAGS) $(INCS) -c $*.f90

utils.o:
	$(F90C) $(F90FLAGS) $(INCS) -c utils.F90	

bsplinepk.o: 
	$(CC) $(CFLAGS) $(INCS) -c bsplinepk.c

clean:
	-rm -f *.o *.a *.d core *.mod


