
# start from a debian image with Java 7 and git preinstalled
FROM  java:7                                                     

# set up Linux system environment 
RUN echo '***** Update packages *****'                                                                              \
    && apt-get -y update                                                                                            \
                                                                                                                    \
    && echo '***** Install packages REQUIRED for creating this image *****'                                         \
    && apt-get -y install curl makepasswd                                                                           \
                                                                                                                    \
    && echo '***** `# Install packages REQUIRED to build and run kurator tools *****'                               \
    && apt-get -y install maven                                                                                     \
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
RUN echo '***** Download, install, and configure jython 2.7.0 *****'                                                \
    && curl -O http://central.maven.org/maven2/org/python/jython-installer/2.7.0/jython-installer-2.7.0.jar         \
    && java -jar jython-installer-2.7.0.jar -s -d ~/jython-2.7.0                                                    \
    && rm jython-installer-2.7.0.jar                                                                                \
                                                                                                                    \
    && echo '***** Use jython pip to install python packages required by kurator *****'                             \
    && ~/jython-2.7.0/bin/pip install suds-jurko                                                                    \
                                                                                                                    \
    && echo '***** Clone kurator git repositories *****'                                                            \
    && git clone https://github.com/kurator-org/kurator-akka.git                                                    \
    && git clone https://github.com/kurator-org/kurator-validation.git                                              \
                                                                                                                    \
    && echo '***** Build, test, package, and install code artifacts *****'                                          \
    && export JYTHON_HOME=/home/kurator/jython-2.7.0                                                                \
    && cd ~/kurator-akka                                                                                            \
    && mvn install                                                                                                  \
    && cd ~/kurator-validation                                                                                      \
    && mvn package                                                                                                  \    
                                                                                                                    \   
    && echo '***** Add environment variable definitions to .bashrc *****'                                           \
    && echo "export JYTHON_HOME=/home/kurator/jython-2.7.0"       >> ~/.bashrc                                      \
    && echo "export PATH=/home/kurator/jython-2.7.0/bin/:$PATH"   >> ~/.bashrc

# start an interactive bash login shell when the image is run
CMD  /bin/bash -il