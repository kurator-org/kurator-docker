
# start from a debian image with Java 7 and git preinstalled
FROM  java:7

# install packages 
RUN echo '***** Update packages *****'                                                                              \
    && apt-get -y update                                                                                            \
                                                                                                                    \
    && echo '***** Install packages REQUIRED for creating this image *****'                                         \
    && apt-get -y install curl makepasswd                                                                           \
                                                                                                                    \
    && echo '***** Install packages NOT required to build and run kurator tools *****'                              \
    && apt-get -y install sudo apt-utils man less file tree vim emacs
                  
# create an unprivileged user
RUN echo '***** Create the kurator user *****'                                                                      \
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
    && echo '***** Download kurator-validation executable jar *****'                                                \
    && mkdir ~/bin                                                                                                  \
    && curl -o ~/bin/kurator-validation.jar https://opensource.ncsa.illinois.edu/bamboo/browse/KURATOR-AKKA-317/artifact/KUW/executable-jar/kurator-validation-0.3-SNAPSHOT-jar-with-dependencies.jar \

    && echo '***** Add environment variable definitions to .bashrc *****'                                           \
    && echo 'export PATH=/home/kurator/jython-2.7.0/bin/:$PATH'     >> ~/.bashrc                                    \
    && echo 'export JYTHON_HOME=/home/kurator/jython-2.7.0'         >> ~/.bashrc                                    \
    && echo 'export PATH=/home/kurator/bin/:$PATH'                  >> ~/.bashrc                                    \
    && echo "alias ka='java -jar ~/bin/kurator-validation.jar'"     >> ~/.bash_aliases

# start an interactive bash login shell when the image is run
CMD  /bin/bash -il