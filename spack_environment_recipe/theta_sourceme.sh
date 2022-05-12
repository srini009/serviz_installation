#!/bin/bash
module load cmake
module swap PrgEnv-intel PrgEnv-gnu
module swap cray-libsci/20.06.1 cray-libsci/20.03.1
module unload darshan
. ~/spack/share/spack/setup-env.sh
spack env activate serviz
export CRAYPE_LINK_TYPE=dynamic
export MPICH_GNI_NDREG_ENTRIES=1024
export PATH=/home/sramesh/VIZ_SERVICE/serviz/build/examples:/home/sramesh/VIZ_SERVICE/AMR_WIND_INSTALL/bin:/home/sramesh/RADICAL/mongo/bin:/home/sramesh/VIZ_SERVICE/TAU_INSTALL/craycnl/bin/:$PATH
export PKG_CONFIG_PATH=/usr/lib64/pkgconfig:/home/sramesh/VIZ_SERVICE/serviz/build/lib/pkgconfig:$PKG_CONFIG_PATH
export RADICAL_LOG_LVL=DEBUG
export RADICAL_PROFILE=TRUE
export RADICAL_PILOT_DBURL=mongodb://rct:jdWeRT634k@thetalogin3.tmi.alcf.anl.gov:6874/rct_db
source $HOME/.miniconda3/bin/activate
conda activate rct
