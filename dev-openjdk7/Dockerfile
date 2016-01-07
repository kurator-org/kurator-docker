
# start from a debian image with Java 7 and git preinstalled
FROM java:7

# install additional linux packages 
RUN apt-get -y update
RUN apt-get -y install apt-utils
RUN apt-get -y install makepasswd
RUN apt-get -y install sudo
RUN apt-get -y install tree
RUN apt-get -y install maven

# create the kurator user
RUN useradd kurator --gid sudo                                                                    \
                    --shell /bin/bash                                                             \
                    --create-home                                                                 \
                    --password `echo kurator | makepasswd --crypt-md5 --clearfrom - | cut -b11-` 

# perform remaining commands as the user and within the user's home directory
USER kurator
WORKDIR /home/kurator

# clone kurator git repositories
RUN git clone https://opensource.ncsa.illinois.edu/bitbucket/scm/kurator/kurator-jython.git
RUN git clone https://github.com/kurator-org/kurator-akka.git
RUN git clone https://github.com/kurator-org/kurator-validation.git

# perform initial builds and tests
RUN cd ~/kurator-akka && mvn install
RUN cd ~/kurator-validation && mvn install

# start an interactive bash login shell when the image is run
CMD /bin/bash -il



