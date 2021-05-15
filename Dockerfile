FROM ubuntu:20.04

RUN apt-get update \
    && DEBIAN_FRONTEND="noninteractive" apt-get install -y \
        curl \
        cython3 \
        expect \
        gfortran \
        libcfitsio-dev \
        libgsl-dev \
        python3-numpy \
        python3-pip \
        python3-scipy \
        python3-zmq \
    && pip3 install --no-cache-dir \
        notebook==5.* \
        jupyter_contrib_nbextensions==0.3.1 \ 
        matplotlib==3.4.* \
        setuptools==20.4 \
    && jupyter contrib nbextension install \
    && jupyter nbextension enable toc2/main --system \
    && rm -rf /var/lib/apt/lists/*

# install julia
RUN mkdir /opt/julia \
    && curl -L https://julialang-s3.julialang.org/bin/linux/x64/1.6/julia-1.6.1-linux-x86_64.tar.gz | tar zxf - -C /opt/julia --strip=1 \
    && ln -s /opt/julia/bin/julia /usr/local/bin

# setup unprivileged user needed for mybinder.org
ENV NB_USER cosmo
ENV NB_UID 1000
ENV HOME /home/${NB_USER}
RUN adduser --disabled-password --gecos "cosmo" --uid ${NB_UID} ${NB_USER}
USER cosmo

# install CAMB
RUN mkdir -p $HOME/src/camb \
    && curl -L https://github.com/cmbant/camb/tarball/6fc83ba | tar zxf - -C $HOME/src/camb --strip=1 \
    && cd $HOME/src/camb/pycamb \
    && python3 setup.py install --user

# install the Feb 2009 version of CAMB needed for the P_halo(k) calculation 
# we also need camb4py since this old CAMB version doesn't have its own Python wrapper
RUN mkdir -p $HOME/dat/lrgdr7like $HOME/src/camb4py $HOME/src/camb-feb09
COPY src/camb-feb09/Makefile $HOME/src/camb-feb09/Makefile
RUN curl -L https://github.com/cmbant/CAMB/archive/Feb09.tar.gz | tar zxf - -C $HOME/src/camb-feb09 --strip=1 --skip-old-files \
    && curl -L https://lambda.gsfc.nasa.gov/toolbox/lrgdr/lrgdr7like.tar.gz | tar zxf - -C $HOME/dat/lrgdr7like \
    && cd $HOME/dat/lrgdr7like/CAMBfeb09patch \
    && cp inidriver.F90 modules.f90 bsplinepk.c $HOME/src/camb-feb09 \
    && cd $HOME/src/camb-feb09 \
    && make \
    && curl -L https://github.com/marius311/camb4py/tarball/a4e57fd | tar zxf - -C $HOME/src/camb4py --strip=1 \
    && cd $HOME/src/camb4py \
    && python3 setup.py build --no-builtin install --user

# install and precompile the Julia packages we need (listed in Project.toml)
COPY --chown=1000 Project.toml Manifest.toml $HOME/.julia/environments/v1.6/
RUN PYTHON=python3 julia -e 'using Pkg; pkg"resolve; build; precompile"'

# copy notebook and data into container
RUN mkdir $HOME/notebooks
COPY notebooks/ $HOME/notebooks/
COPY dat $HOME/dat
COPY --chown=1000 matplotlibrc $HOME/.config/matplotlib/matplotlibrc
WORKDIR $HOME/notebooks

# we don't actually need to specify a port different than 8888 inside the
# container, but this makes it so Jupyter prints the accurate URL to connect to
# on startup
ENV PORT 8888
# the pipe to sed can be removed once https://github.com/jupyter/notebook/pull/4103 hits a release
CMD unbuffer jupyter-notebook --ip=0.0.0.0 --no-browser --port $PORT 2>&1 | sed -ue "s/(.* or 127.0.0.1)/localhost/g"
