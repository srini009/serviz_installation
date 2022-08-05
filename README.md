Repository containing the installation instructions and customization scripts for SC 2022 paper427: "SERVIZ: A Shared In Situ Visualization Service"

### Note: It is important to follow these steps in the exact order specified to correctly set up the software components for reproducibility. The instructions here assume that you are logged in to the Theta cluster at ALCF. Please keep in mind that if you are using a laptop to install the components, reproducing the experimental results (Step 5) would not be possible. It is assumed that the directory structure looks like the following:
  * $HOME/serviz-installation-instructions/
  * $HOME/amr-wind/
  * $HOME/serviz/
  * $HOME/serviz-experiments/
  * $HOME/mochi-spack-packages/
  * $HOME/ascent/

### Step 1: Installation of custom spack and mochi-spack-packages:
1. Download and install spack: https://spack.io/ 
2. Assuming that spack is downloaded at $HOME/spack, ```cd $HOME/spack```.
3. Copy the spack packages file into your local spack directory: ```cp  $HOME/serviz-installation-instructions/spack_builtin_repo_customization/packages.yaml ~/.spack/cray/packages.yaml```
4. We need to customize some built-in spack packages. The recipe for the spack built-in packages are found in ```$HOME/spack/var/spack/repos/builtin/packages/*```
5. For each of the three packages (ascent, conduit, and vtk-h) in ```../serviz-installation-instructions/spack_builtin_repo_customization/```, copy-paste the ```package.py``` inside each of them to the corresponding spack built-in package directories in ```$HOME/spack/var/spack/repos/builtin/packages/*```
6. Add the custom mochi-spack-packages repo: ```cd ../mochi-spack-packages && git checkout experimental && spack repo add .```
7. Note that the ```experimental``` branch for this repo needs to be used. Verify that the spack repo got added successfully by running: ```spack info mochi-symbiomon```. If you see some valid output, you are good to go!

### Step 2: Installation of SERVIZ microservice and its dependencies:
#### Note: At this point, make sure your environment has the right compilers (gcc@9.3.0 or higher), Python programming environments, and spack environments correctly loaded. To look at a reference file, see ```$HOME/serviz-installation-instructions/spack_environment_recipe/theta_sourceme.sh```
1. Go to the SERVIZ github directory: ```cd ../serviz```
2. Create a spack environment using the already-provided spack.yaml file: ```spack env create serviz spack.yaml```. **If using a laptop**, use the ```spack_laptop.yaml``` file instead of the ```spack.yaml``` file to create the environment. 
3. Install the environment using: ```spack env activate serviz && spack install```
4. Install the SERVIZ microservice using: ```mkdir build && cd build && cmake .. -DENABLE_TESTS=OFF -DENABLE_EXAMPLES=ON -DENABLE_BEDROCK=OFF -DCMAKE_INSTALL_PREFIX=`pwd` -DCMAKE_C_COMPILER=cc -DCMAKE_CXX_COMPILER=CC```. If using a laptop, replace ```cc``` with ```mpicc``` and replace ```CC``` with ```mpicxx```.
5. Login to the cmake shell: ```cd build && ccmake .```
6. We would need to add the spack-installed ```include``` and ```library``` directories for **Ascent** and **Conduit** to ```CMAKE_CXX_FLAGS```, ```CMAKE_C_FLAGS```, ```CMAKE_EXE_LINKER_FLAGS```, and ```CMAKE_SHARED_LINKER_FLAGS``` respectively. To see an example of what content to add, look inside ```$HOME/serviz-installation-instructions/spack_environment_recipe/theta.cmake_options```
7. Once this is done, run: ```make -j20 && make install```. 

### Step 3: Installation of custom AMR-WIND:
1. Download the custom amr-wind repository: ```git clone --recursive https://github.com/srini009/amr-wind.git```
2. ```mkdir -p $HOME/AMR_WIND_INSTALL```
3. ```cd $HOME/amr-wind```
4. ```mkdir build && cd build```. At this point, **please make sure** that the ```serviz/build/lib/pkgconfig``` has been added to the ```PKG_CONFIG_PATH``` environment variable. Otherwise, you will get CMAKE configuration errors with AMR-WIND.
5. ```cmake .. -DAMR_WIND_ENABLE_TESTS:BOOL=ON -DAMR_WIND_ENABLE_ASCENT:BOOL=ON -DAscent_DIR:PATH="/spack/path/to/ascent/install/lib/cmake/ascent" -DConduit_DIR:PATH="/spack/path/to/conduit/install" -DCMAKE_INSTALL_PREFIX=$HOME/AMR_WIND_INSTALL -DAMR_WIND_ENABLE_MPI:BOOL=ON -DAMR_WIND_ENABLE_MPI:BOOL=ON```
6. ```make -j20 && make install```

### Step 4: Installation of custom Kripke:
1. We will build Kripke integrated with Ascent / SERVIZ using a custom Ascent build. Note that this version of Ascent is **not** the one 
installed in your spack environment through the spack.yaml file. We are building Ascent manually, purely for using the Kripke example provided with the repo.
2. Download the custom Ascent repo from here: ```git clone --recursive https://github.com/srini009/ascent.git```
3. Check out the ```vizservice``` branch: ```git checkout vizservice```
4. Configure an Ascent build: ```cd ascent && ./config-build.sh```
5. Build Ascent: ```cd build-debug && make``` (Note: Do NOT use a parallel ```make``` here. For some reason, the build fails if parallel ```make``` is used)
6. Install Ascent: ```make install```.
7. Confirm that the build created the Kripke executable: ```ls examples/proxies/kripke/kripke_par```

### Step 5: Run AMR-WIND and Kripke experiments:
1. At this point you should have all the software components successfully installed and ready to run.
2. Go to the serviz-experiments repo: ```cd $HOME/serviz-experiments/``` and start running the experiments by making adjustments to the run scripts as necessary. These scripts are numbered based on the configurations that they represent.
