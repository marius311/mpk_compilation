FROM ubuntu:16.04

RUN apt-get update \
    && apt-get install -y \
        curl \
        cython3 \
        gfortran \
        python3-matplotlib \
        python3-numpy \
        python3-pip \
        python3-scipy \
        python3-seaborn \
        python3-zmq \
    && pip3 install jupyter

# install camb
RUN mkdir /root/camb \
    && curl -L https://github.com/cmbant/camb/tarball/003abb6 | tar zxf - -C /root/camb --strip=1 \
    && cd /root/camb/pycamb \
    && python3 setup.py install

# install julia 0.6
RUN mkdir /root/julia \
    && curl -L https://julialang.s3.amazonaws.com/bin/linux/x64/0.6/julia-0.6.0-linux-x86_64.tar.gz | tar -C /root/julia -xz --strip=1 -f - \
    && ln -s /root/julia/bin/julia /usr/local/bin

RUN PYTHON=python3 julia -e 'for pkg=["IJulia","PyPlot","FITSIO","Interpolations"]; Pkg.add(pkg); @eval using $(Symbol(pkg)); end'

# COPY tegfig.ipynb COM_PowerSpect_CMB_R2.02.fits /root/shared/
# COPY plik_lite_v18_TTTEEE.clik /root/shared/plik_lite_v18_TTTEEE.clik


RUN apt-get install -y python3-pip \
    && pip3 install --no-cache-dir jupyterhub==${JUPYTERHUB_VERSION}

# Make sure the contents of our repo are in ${HOME}
COPY . ${HOME}
USER root
RUN chown -R ${NB_USER}:${NB_GID} ${HOME}
USER ${NB_USER}



WORKDIR /root/shared
CMD jupyter-notebook --ip=* --no-browser
