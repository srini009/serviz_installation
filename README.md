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

First, go over the installation instructions: https://radicalpilot.readthedocs.io/en/stable/installation.html. The following instructions assume that you have already installed and have a working MongoDB installation, Python, Conda,
and other requirements for radical-pilot setup and working. The instructions that follow are only for customizing radical-pilot for SERVIZ.
1. Install radical-saga@1.12.0 using the command: ```pip install radical.saga==1.12.0```
2. Install radical-utils@1.12.0 using the command: ```pip install radical.utils==1.12.0```
3. The third component, radical-pilot would require a custom installation. For this:
   * First download the radical.pilot github repo locally using git: ```git clone https://github.com/radical-cybertools/radical.pilot.git@v1.12.0```
   * Run: ```cd radical-pilot && cp ../serviz-installation-instructions/radical-pilot-customization/aprun.py ./src/radical/pilot/agent/launch_method/aprun.py```
   * Run: ```vi ./src/radical/pilot/agent/launch_method/aprun.py```, and look for the line that says "REPLACEME". You would need to create a protection domain on Theta and use that protection domain name here.
   * Assuming you are still in $HOME/radical-pilot, run: ```pip install .```
   * That should install the "modified" radical-pilot stack. Check that the entire radical-stack has installed correctly at version 1.12.0 by running ```radical-stack```
   * Copy the Theta resource JSON config: ```cp ../serviz-installation-instructions/radical-pilot-customization/resource_anl.json ~/.radical/pilot/configs/resource_anl.json```. This would override the default JSON configuration file to tell radical-pilot to only use 60 out of the total 64 cores on each Theta KNL node.
   * At this point, run a small test program to ensure that you are able to use radical-pilot along with the MongoDB installation to submit and run a batch job ensemble on Theta. 

### Step 2: Installation of custom spack and mochi-spack-packages:
1. Download and install spack: https://spack.io/ 
2. Assuming that spack is download at $HOME/spack, ```cd $HOME/spack```.
3. What we need to do next is to customize some spack built-in packages. The recipe for the spack built-in packages are found in ```$HOME/spack/var/spack/repos/builtin/packages/*```
4. For each of the three packages (ascent, conduit, and vtk-h) in ```../serviz-installation-instructions/spack_builtin_repo_customization/```, copy-paste the ```package.py``` inside each of them to the corresponding spack built-in package directories in ```$HOME/spack/var/spack/repos/builtin/packages/*```
5. Add the custom mochi-spack-packages repo: ```cd ../mochi-spack-packages && git checkout experimental && spack repo add .```
6. Note that the ```experimental``` branch for this repo needs to be used. Verify that the spack repo got added successfully by running: ```spack info mochi-symbiomon```. If you see some valid output, you are good to go!
