#!/usr/bin/env bash

mpich=3.3.2
mpich_prefix=mpich-${mpich}
wget https://www.mpich.org/static/downloads/${mpich}/${mpich_prefix}.tar.gz

mpi4py=3.1.1
mpi4py_prefix=mpi4py-${mpi4py}
wget https://bitbucket.org/mpi4py/mpi4py/downloads/${mpi4py_prefix}.tar.gz
