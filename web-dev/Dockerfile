
# start from a debian image with Java 8 and git preinstalled
FROM  java:8                                                     

# set up Linux system environment 
RUN echo '***** Update packages *****'                                                                              \
    && apt-get -y update                                                                                            \
                                                                                                                    \
    && echo '***** Install packages REQUIRED for creating this image *****'                                         \
    && apt-get -y install curl makepasswd                                                                           \
                                                                                                                    \
    && echo '***** `# Install packages REQUIRED to build and run kurator tools *****'                               \
    && apt-get -y install maven git                                                                                 \
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
RUN echo '***** Clone and build kurator-akka *****'                                                             \
    && git clone https://github.com/kurator-org/kurator-akka.git                                                \
    && cd ~/kurator-akka                                                                                        \
    && mvn install

RUN echo '***** Clone and build kurator-web *****'                                                               \
    && git clone https://github.com/kurator-org/kurator-web.git                                                     \
                                                                                                                    \
    && echo '***** Build, test, package, and install code artifacts *****'                                          \
    && cd ~/kurator-web                                                                                             \
    && mvn package                                                                                                  

# start an interactive bash login shell when the image is run
CMD  /bin/bash -il
