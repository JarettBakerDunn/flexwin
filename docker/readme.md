This container hosts the source code for flexwin. Flexwin relies on libraries from the SAC software package which can only be distributed by IRIS and so cannot be included in the geodynamics/flexwin docker image. Because these libraries cannot be included in the docker image, it is up to the user to obtain a copy of the SAC software and compile flexwin within the container.

docker run -it --rm -v $HOME/flexwin:/home/flexwin_user/work geodynamics/flexwin

This command will start the flexwin docker image and give you terminal access. Any changes made in the /home/flexwin/work directory will be reflected on the host machine at home/flexwin.

In order to compile flexwin, make sure that a copy of the SAC library exists in the /home/flexwin/work directory. The easiest way to do this is download a copy of SAC for linux from IRIS and placing it into /home/flexwin on the host machine.

You will need to add this line to the makefile:

%.o : %.mod



