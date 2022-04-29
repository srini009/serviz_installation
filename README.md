# serviz_installation
Repository containing the installation instructions and customization scripts for paper427: "SERVIZ: A Shared In Situ Visualization Service"
## Note: It is important to follow these steps in the exact order specified to correctly set up the software components for reproducibility.
## Note: The instructions here assume that you are logged in to the Theta cluster at ALCF.

Step 1: Installation of radical-pilot components:
First, go over the installation instructions using PyPi on their website, Section 2.2.1: https://radicalpilot.readthedocs.io/en/stable/installation.html
a. Install radical-saga@1.12.0 using the command: pip install radical.saga==1.12.0
b. Install radical-utils@1.12.0 using the command: pip install radical.utils==1.12.0
c. The third component, radical-pilot would require a custom installation. For this:
   i.   First download the radical.pilot github repo locally using git: git clone https://github.com/radical-cybertools/radical.pilot.git@v1.12.0
   ii.  Go into this downloaded radical pilot directory, and copy the file from the serviz-installation-instructions/radical-pilot-customization/aprun.py
        into radical-pilot/src/radical/pilot/agent/launch_method/aprun.py
   iii. Open this aprun.py, and look for the line that says "REPLACEME". You would need to create a protection domain on Theta and use that
        protection domain name here.
   iv.  Assuming you are inside radical-pilot, run: pip install . 
   v.   That should install the "modified" radical-pilot stack.

