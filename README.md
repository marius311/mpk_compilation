# Matter power spectrum compilation


In their [2002 paper](https://arxiv.org/abs/astro-ph/0207047), Max Tegmark and Mattias Zaldarriaga developed a method for compressing the information from several different types of cosmological probes into constraints on the power spectrum of matter fluctuations in the universe. In doing so, they created one of the iconic figures in cosmology, summarizing information from a range of vastly different observations and showing these were all consistent with the predicitions from the simple ΛCDM model of cosmology. 


We have updated this figure in [Chabanier et al. 2019](link-not-live-yet) and [Planck 2018: I](https://arxiv.org/abs/1807.06205) to include recent cosmological data, and provide this repository so others can contribute to keeping this compilation up-to-date. 

![mpk_compilation](mpk_compilation.png)

## Usage

This repository comes in the form a [Jupyter](http://jupyter.org/) notebook packaged inside of a Docker container, so that it is trivial to install the (fairly complex) set of dependencies needed for this calculation. You can preview this notebook without running it [here](https://nbviewer.jupyter.org/github/marius311/mpk_compilation/blob/master/notebooks/mpk_compilation.ipynb).

You can also easily run this notebook by [installing Docker](https://docs.docker.com/install/) then running:

```bash
PORT=8888; docker run --rm -e PORT=$PORT -itp $PORT:$PORT marius311/mpk_compilation
```

You will be prompted with a link to open the notebook in your browser. You can change the port from 8888 if you wish. 

If you wish to develop this repository or to have changes to the notebook saved between sessions, you can clone this repository and run:

```bash
git clone https://github.com/marius311/mpk_compilation
cd mpk_compilation
docker-compose pull # or replace "pull" with "build" to build the image locally
PORT=8888 docker-compose up
```

## Citing

Please cite [Chabanier et al. 2019](link-not-live-yet) and [Planck 2018: I](https://arxiv.org/abs/1807.06205) if you make use of this figure or code.
