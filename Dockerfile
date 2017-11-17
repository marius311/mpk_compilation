FROM ubuntu:16.04

RUN apt-get update \
    && apt-get install -y \
        curl \
        cython3 \
        gfortran \
        libgsl-dev \
        python3-matplotlib \
        python3-numpy \
        python3-pip \
        python3-scipy \
        python3-seaborn \
        python3-zmq \
    && pip3 install --no-cache-dir notebook==5.* \
    && rm -rf /var/lib/apt/lists/*

# install julia 0.6.1
RUN mkdir /opt/julia \
    && curl -L https://julialang-s3.julialang.org/bin/linux/x64/0.6/julia-0.6.1-linux-x86_64.tar.gz | tar zxf - -C /opt/julia --strip=1 \
    && ln -s /opt/julia/bin/julia /usr/local/bin

# setup unprivileged user needed for mybinder.org
ENV NB_USER marius
ENV NB_UID 1000
ENV HOME /home/${NB_USER}
RUN adduser --disabled-password --gecos "Default user" --uid ${NB_UID} ${NB_USER}
USER ${NB_USER}


# install CAMB
RUN mkdir $HOME/camb \
    && curl -L https://github.com/cmbant/camb/tarball/0.1.6.1 | tar zxf - -C $HOME/camb --strip=1 \
    && cd $HOME/camb/pycamb \
    && python3 setup.py install --user


# install the Feb 2009 version of CAMB needed for the P_halo(k) calculation 
# we also need camb4py since this old CAMB version doesn't have its own Python wrapper
RUN mkdir $HOME/lrgdr7like $HOME/camb4py $HOME/camb-feb09
COPY camb-feb09/Makefile $HOME/camb-feb09/Makefile
RUN curl -L https://github.com/cmbant/CAMB/archive/Feb09.tar.gz | tar zxf - -C $HOME/camb-feb09 --strip=1 --skip-old-files\
    && curl -L https://lambda.gsfc.nasa.gov/toolbox/lrgdr/lrgdr7like.tar.gz | tar zxf - -C $HOME/lrgdr7like \
    && cd $HOME/lrgdr7like/CAMBfeb09patch \
    && cp inidriver.F90 modules.f90 bsplinepk.c $HOME/camb-feb09 \
    && cd $HOME/camb-feb09 \
    && make \
    && curl -L https://github.com/marius311/camb4py/tarball/a4e57fd | tar zxf - -C $HOME/camb4py --strip=1 \
    && cd $HOME/camb4py \
    && python3 setup.py build --no-builtin install --user



RUN PYTHON=python3 julia -e 'for pkg=["IJulia","PyPlot","FITSIO","Interpolations"]; Pkg.add(pkg); @eval using $(Symbol(pkg)); end'

# COPY tegfig.ipynb COM_PowerSpect_CMB_R2.02.fits $HOME/shared/
# COPY plik_lite_v18_TTTEEE.clik $HOME/shared/plik_lite_v18_TTTEEE.clik

WORKDIR $HOME/shared
CMD jupyter-notebook --ip=* --no-browser
