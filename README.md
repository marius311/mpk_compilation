# Matter power spectrum compilation


In their [2002 paper](https://arxiv.org/abs/astro-ph/0207047), Max Tegmark and Mattias Zaldarriaga developed a method for compressing the information from several different types of cosmological probes into constraints on the power spectrum of matter fluctuations in the universe. In doing so, they created one of the iconic figures in cosmology, summarizing information from a range of vastly different observations and showing these were all consistent with the predicitions from the simple ΛCDM model of cosmology. 

We have updated this figure in [Chabanier et al. 2019](link-not-live-yet) and [Planck 2018: I](https://arxiv.org/abs/1807.06205) to include recent cosmological data, and provide this repository so others can contribute to keeping this compilation up-to-date. 

This repository comes in the form a [Jupyter](http://jupyter.org/) notebook packaged inside of a Docker container, so that it is trivial to install the (fairly complex) set of dependencies needed for this calculation. 

The easiest way to run this notebook is to [install Docker](https://docs.docker.com/install/) then run:

```bash
docker run --rm -itp 8888:8888 marius311/mpk_compilation
```

You will be prompted with a link to open the notebook in your browser. 

If you wish to develop this repository or to have changes to the notebook saved between sessions, you can clone this repository and run locally:

```bash
git clone https://github.com/marius311/mpk_compilation
cd mpk_compilation
docker-compose pull # or replace "pull" with "build" to build the image locally
docker-compose up
```

Note: by default, we run the notebook at port 8888, if you already have a notebook running on this port, you can specify a different one via: `PORT=1234 docker-compose up`.
