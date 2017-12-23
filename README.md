# The Tegmark & Zaldarriaga Figure

[![Binder](https://mybinder.org/badge.svg)](https://mybinder.org/v2/gh/marius311/tegmark_zaldarriaga_figure/binder?filepath=tegfig.ipynb)


In their [2002 paper](https://arxiv.org/abs/astro-ph/0207047), Max Tegmark and Mattias Zaldarriaga developed a method for compressing the information from several different types of cosmological probes into constraints on the power spectrum of matter fluctuations in the universe. In doing so, they created one of the iconic figures in cosmology, summarizing information from a range of vastly different observations and showing these were all consistent with the predicitions from the simple ΛCDM model of cosmology. 

This repository provides a [Jupyter](http://jupyter.org/) notebook written in the [Julia](https://julialang.org/) programming language which recreates this figure for modern data. The notebook, along with all dependencies pre-installed, is available as a "binder" on [https://mybinder.org/](https://mybinder.org/), so with one click you'll have everything running. 

Try it here: [![Binder](https://mybinder.org/badge.svg)](https://mybinder.org/v2/gh/marius311/tegmark_zaldarriaga_figure/binder?filepath=tegfig.ipynb)


The aim of this repository is to maintain a reproducible, readable, and easily modifiable code for producing this important and useful figure. Contributions are very welcome!


## Other ways to run the notebook. 

* To run the notebook locally, [install Docker](https://store.docker.com/search?type=edition&offering=community), then simply run:

    ```
    docker run --rm -itp 8888:8888 marius311/tegmark_zaldarriaga_figure
    ```
    
* To make it so your changes to the notebook are saved, clone this repository and run the container from there with:

    ```bash
    git clone https://github.com/marius311/tegmark_zaldarriaga_figure
    cd tegmark_zaldarriaga_figure
    docker-compose pull # or replace "pull" with "build" to build the image locally
    docker-compose up
    ```

* You can also run everything outside of Docker, see the Dockerifle for hints as to what you need to install on your system.
