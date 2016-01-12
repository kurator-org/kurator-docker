# start from a debian image with Java 7 and git preinstalled
FROM  java:7

# update list of available packages
RUN  apt-get -y update

# install packages REQUIRED for creating this image
RUN  apt-get -y install curl
RUN  apt-get -y install makepasswd

# install packages REQUIRED to build and run kurator tools
RUN  apt-get -y install maven

# install convenience packages NOT required to build and run kurator tools
RUN  apt-get -y install sudo
RUN  apt-get -y install apt-utils
RUN  apt-get -y install man
RUN  apt-get -y install less
RUN  apt-get -y install tree
RUN  apt-get -y install vim
RUN  apt-get -y install emacs

# create the kurator user
RUN  useradd kurator --gid sudo                                                                    \
                     --shell /bin/bash                                                             \
                     --create-home                                                                 \
                     --password `echo kurator | makepasswd --crypt-md5 --clearfrom - | cut -b11-` 

# perform remaining commands as the user and within the user's home directory
USER  kurator
WORKDIR  /home/kurator

# download, install, and configure jython 2.7.0
RUN  curl -O http://central.maven.org/maven2/org/python/jython-installer/2.7.0/jython-installer-2.7.0.jar
RUN  java -jar jython-installer-2.7.0.jar -s -d ~/jython-2.7.0  # NB: argument to -d must be an absolute path
RUN  rm jython-installer-2.7.0.jar

# use jython's pip to install python packages required by kurator
RUN  ~/jython-2.7.0/bin/pip install suds-jurko

# clone kurator git repositories
RUN  git clone https://github.com/kurator-org/kurator-akka.git
RUN  git clone https://github.com/kurator-org/kurator-validation.git

# build, test, package, and install kurator-akka artifacts
RUN  export JYTHON_HOME=/home/kurator/jython-2.7.0 ;            \
     cd ~/kurator-akka ;                                        \
     mvn install

# build, test, and package kurator-validation artifacts
RUN  export JYTHON_HOME=/home/kurator/jython-2.7.0 ;            \
     cd ~/kurator-validation ;                                  \                                            
     mvn package

# add environment variable definitions to .bashrc
RUN  echo "export JYTHON_HOME=/home/kurator/jython-2.7.0"       >> .bashrc
RUN  echo "export PATH=/home/kurator/jython-2.7.0/bin/:$PATH"   >> .bashrc

# start an interactive bash login shell when the image is run
CMD  /bin/bash -il