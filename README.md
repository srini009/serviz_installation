Repository containing the installation instructions and customization scripts for SC 2022 paper427: "SERVIZ: A Shared In Situ Visualization Service"
## Note: It is important to follow these steps in the exact order specified to correctly set up the software components for reproducibility.
## Note: The instructions here assume that you are logged in to the Theta cluster at ALCF
## Note: It is assumed that the directory structure looks like the following:
  * $HOME/serviz-installation-instructions/
  * $HOME/amr-wind/
  * $HOME/serviz/
  * $HOME/amr-wind-experiments/
  * $HOME/mochi-spack-packages/

### Step 1: Installation of radical-pilot components:

First, go over the installation instructions: https://radicalpilot.readthedocs.io/en/stable/installation.html. The following instructions assume that you have already installed and have a working MongoDB installation, Python, Conda, and other dependencies for radical-pilot setup and working. We recommend using virtualenv and pip for installing radical-pilot. The instructions that follow are only for customizing radical-pilot for SERVIZ. These instructions
assume that you are inside a Python virtualenv.
1. Install radical-saga@1.12.0 using the command: ```pip install radical.saga==1.12.0```
2. Install radical-utils@1.12.0 using the command: ```pip install radical.utils==1.12.0```
3. The third component, radical-pilot would require a custom installation. For this:
   * First download the radical.pilot github repo locally using git: ```git clone https://github.com/radical-cybertools/radical.pilot.git && git checkout v1.12.0```
   * Run: ```cd radical-pilot && cp ../serviz-installation-instructions/radical_pilot_customization/aprun.py ./src/radical/pilot/agent/launch_method/aprun.py```
   * Run: ```vi ./src/radical/pilot/agent/launch_method/aprun.py```, and look for the line that says "REPLACEME". You would need to create a protection domain on Theta and use that protection domain name here.
   * Assuming you are still in $HOME/radical-pilot, run: ```pip install .```
   * That should install the "modified" radical-pilot stack. Check that the entire radical-stack has installed correctly at version 1.12.0 by running ```radical-stack```
   * Copy the Theta resource JSON config: ```cp ../serviz-installation-instructions/radical_pilot_customization/resource_anl.json ~/.radical/pilot/configs/resource_anl.json```. This would override the default JSON configuration file to tell radical-pilot to only use 60 out of the total 64 cores on each Theta KNL node.
   * At this point, run a small test program to ensure that you are able to use radical-pilot along with the MongoDB installation to submit and run a batch job ensemble on Theta. 

### Step 2: Installation of custom spack and mochi-spack-packages:
1. Download and install spack: https://spack.io/ 
2. Assuming that spack is download at $HOME/spack, ```cd $HOME/spack```.
3. Copy the spack packages file into your local spack directory: ```cp  $HOME/serviz-installation-instructions/spack_builtin_repo_customization/packages.yaml ~/.spack/cray/packages.yaml
4. What we need to do next is to customize some spack built-in packages. The recipe for the spack built-in packages are found in ```$HOME/spack/var/spack/repos/builtin/packages/*```
5. For each of the three packages (ascent, conduit, and vtk-h) in ```../serviz-installation-instructions/spack_builtin_repo_customization/```, copy-paste the ```package.py``` inside each of them to the corresponding spack built-in package directories in ```$HOME/spack/var/spack/repos/builtin/packages/*```
6. Add the custom mochi-spack-packages repo: ```cd ../mochi-spack-packages && git checkout experimental && spack repo add .```
7. Note that the ```experimental``` branch for this repo needs to be used. Verify that the spack repo got added successfully by running: ```spack info mochi-symbiomon```. If you see some valid output, you are good to go!

### Step 3: Installation of SERVIZ microservice and its dependencies:
#### Note: At this point, make sure your environment has the right compilers (gcc@9.3.0), Conda programming environments, and spack environments correctly loaded. To look at a reference file, see ```$HOME/serviz-installation-instructions/spack_environment_recipe/theta_sourceme.sh```
1. Go to the SERVIZ github directory: ```cd ../serviz```
2. Create a spack environment using the already-provided spack.yaml file: ```spack env create serviz spack.yaml```
3. Install the environment using: ```spack install``
4. Install the SERVIZ microservice using: ```mkdir build && cd build && cmake .. -DENABLE_TESTS=OFF -DENABLE_EXAMPLES=ON -DENABLE_BEDROCK=OFF -DCMAKE_INSTALL_PREFIX=`pwd` -DCMAKE_C_COMPILER=cc -DCMAKE_CXX_COMPILER=CC```
5. Login to the cmake shell: ```cd build && ccmake .```
6. We would need to add the spack-installed ```include``` and ```library``` directories to ```CMAKE_CXX_FLAGS```, ```CMAKE_C_FLAGS```, ```CMAKE_EXE_LINKER_FLAGS```, and ```CMAKE_SHARED_LINKER_FLAGS``` respectively. To see an example of what content to add, look inside ```$HOME/serviz-installation-instructions/spack_environment_recipe/theta.cmake_options```
7. Once this is done, run: ```make -j20 && make install```. 

### Step 4: Installation of custom AMR-WIND:
1. Download the custom amr-wind repository: ```git clone --recursive https://github.com/srini009/amr-wind.git```
2. ```mkdir -p $HOME/AMR_WIND_INSTALL```
3. ```cd $HOME/amr-wind```
4. ```mkdir build && cd build```
5. ```cmake .. -DAMR_WIND_ENABLE_TESTS:BOOL=ON -DAMR_WIND_ENABLE_ASCENT:BOOL=ON -DAscent_DIR:PATH="/spack/path/to/ascent/install/lib/cmake/ascent" -DConduit_DIR:PATH="/spack/path/to/conduit/install" -DCMAKE_INSTALL_PREFIX=$HOME/AMR_WIND_INSTALL -DAMR_WIND_ENABLE_MPI:BOOL=ON -DAMR_WIND_ENABLE_MPI:BOOL=ON```
6. ```make -j20 && make install```
### Step 5: Run AMR-WIND experiments using SERVIZ and RADICAL-PILOT
1. At this point you should have all the software components successfully installed and ready to run.
2. Go to the amr-wind-experiments repo: ```cd $HOME/amr-wind-experiments/``` and start running the experiments by making adjustments to the  Python run scripts as necessary. These scripts are numbered based on the configurations that they represent.
