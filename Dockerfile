FROM ubuntu:16.04

RUN apt-get update \
    && apt-get install -y \
        curl \
        cython \
        gfortran \
        python-matplotlib \
        python-numpy \
        python-pip \
        python-scipy \
        python-seaborn \
        python-zmq \
    && pip install jupyter

# install camb
RUN mkdir /root/camb \
    && curl -L https://github.com/cmbant/camb/tarball/003abb6 | tar zxf - -C /root/camb --strip=1 \
    && cd /root/camb/pycamb \
    && python setup.py install

# install julia 0.5
RUN mkdir /root/julia \
    && curl -L https://julialang.s3.amazonaws.com/bin/linux/x64/0.5/julia-0.5.0-linux-x86_64.tar.gz | tar -C /root/julia -xz --strip=1 -f - \
    && ln -s /root/julia/bin/julia /usr/local/bin

RUN julia -e 'for pkg=["IJulia","PyPlot","FITSIO","Interpolations"]; Pkg.add(pkg); Pkg.build(pkg); @eval using $(Symbol(pkg)); end'

COPY tegfig.ipynb COM_PowerSpect_CMB_R2.02.fits /root/shared/
COPY plik_lite_v18_TTTEEE.clik /root/shared/plik_lite_v18_TTTEEE.clik


WORKDIR /root/shared
CMD jupyter-notebook --ip=* --no-browser
