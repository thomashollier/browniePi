# browniePi
files and setup to run a pi zero camera with diet pi and pisugar


The idea is to have a set of diet pi config files that install a os on a raspbery pi zero with a camera, a small LED panel with buttons to control the camera and see the pictures being taken, and a VNC server so one can see the pix on a computer.


Contained here are the necessary python files and LCD software, as well as the dietpi files that worked when I made them. The 

The proper wifi info needs to be setup in the dietpi-wifi file.

The Automation_Custom_Script.sh gets run during the first boot and install of diet pi. It installs the necessary packages and dependencies and does the setup.

The VNC stuff is very fiddly and took me a while to get working. I forgot the specifics but it had to do with the PI sharing its GL overlay which is what is being used by raspistill. Maybe looking into RPi Cam Control is a better route.

