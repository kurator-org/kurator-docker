
# start from a debian image with Java 8 and git preinstalled
FROM  java:8                                                    

# set up Linux system environment 
RUN echo '***** Update packages *****'                                                                              \
    && apt-get -y update                                                                                            \
                                                                                                                    \
    && echo '***** Install packages REQUIRED for creating this image *****'                                         \
    && apt-get -y install curl makepasswd                                                                           \
                                                                                                                    \
    && echo '***** Install packages NOT required to build and run kurator tools *****'                              \
    && apt-get -y install sudo apt-utils man less tree vim emacs                                                    \
                                                                                                                    \
    && echo '***** Create the kurator user *****'                                                                   \
    && useradd kurator --gid sudo                                                                                   \
                       --shell /bin/bash                                                                            \
                       --create-home                                                                                \
                       --password `echo kurator | makepasswd --crypt-md5 --clearfrom - | cut -b11-`

# perform remaining commands as the user and within the user's home directory
USER  kurator
WORKDIR  /home/kurator

# set up user's development environment and perform initial builds
RUN echo '***** Download kurator-web zip archive *****'                                                             \
    && curl -o ~/kurator-web.zip https://opensource.ncsa.illinois.edu/bamboo/browse/KURATOR-AKKA-317/artifact/WEB/distribution-archive/kurator-web-0.1-SNAPSHOT-dist.zip \
    && unzip kurator-web.zip                                                                                        \
    && cd kurator-web-0.1-SNAPSHOT                                                                                  \
    && chmod +x start 
 
# start an interactive bash login shell when the image is run
CMD  /bin/bash -il

