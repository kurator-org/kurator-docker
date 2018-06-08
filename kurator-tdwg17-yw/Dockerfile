# start from a debian image with Java 8 and git preinstalled
FROM  java:8                                                    

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

RUN echo '***** make Java 8 the default for java and javac commands *****'                       \
 && update-alternatives --set java  $JAVA_HOME/jre/bin/java               \
 && update-alternatives --set javac $JAVA_HOME/bin/javac

# set up Linux system environment 
RUN echo '***** Update packages *****'                                                       \
 && apt-get -y update                                                                            \
 && echo '***** Install packages REQUIRED for creating this image *****'                         \
 && apt-get -y install curl libcurl4-gnutls-dev makepasswd gcc make                                                 \
 && echo '***** `# Install packages REQUIRED to build and run kurator tools *****'                               \
 && apt-get -y install maven git python python-pip python-dev r-base                                             \
 && echo '***** Install packages NOT required to build and run kurator tools *****'              \
 && apt-get -y install man less file tree vim emacs \
 && echo '***** Install packages required by YesWorkflow *****'                                              \
 && apt-get -y install graphviz    \
 && apt-get clean
 # clean up the apt cache after apt-get update 

RUN echo '***** Create the kurator user *****'                                                   \
 && useradd kurator --gid sudo                                                                   \
                    --shell /bin/bash                                                            \
                    --create-home                                                                \
                    --password `echo kurator | makepasswd --crypt-md5 --clearfrom - | cut -b11-` \
 && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER kurator 
WORKDIR  /home/kurator

# set up user's development environment and perform initial builds
RUN echo '***** Set up environment *****' \
    && mkdir kurator \
    && cd /home/kurator

RUN echo '***** Clone  kurator-akka repo and build *****'                      \
 && git clone https://github.com/kurator-org/kurator-akka.git                  \
 && cd kurator-akka                                                          \
 && mvn install

RUN echo '***** Clone kurator-validation repo and builc *****'                 \
 && git clone https://github.com/kurator-org/kurator-validation.git            \
 && cd kurator-validation                                                    \
 && mkdir target                                                             \
 && cd target/                                                               \
 && wget https://github.com/kurator-org/kurator-validation/releases/download/v1.0.2/kurator-validation-1.0.2-jar-with-dependencies.jar 

 # && mvn install

RUN echo '***** Clone kurator-TDWG17-YW workflows project *****' \
     && cd kurator-validation \
     && git clone https://github.com/kurator-org/kurator-TDWG17-YW.git \
     && cp -r kurator-TDWG17-YW/queries .\
     && cp -r kurator-TDWG17-YW/rules .\
     && cp  kurator-TDWG17-YW/*.sh .\
     && cp kurator-TDWG17-YW/*.properties .
     # && cp -r kurator-TDWG17-YW/kurator_FileBranchingTaxonLookup ./packages/

# The version of Jython to use
ENV JYTHON_VERSION 2.7.1b3

# Variables defining URL to Jython installer
ENV MAVEN_CENTRAL http://central.maven.org/maven2
ENV JYTHON_INSTALLERS_URL $MAVEN_CENTRAL/org/python/jython-installer
ENV JYTHON_INSTALLER_JAR jython-installer-$JYTHON_VERSION.jar

# Variables setting location of Jython in image
ENV HOME /home/kurator
ENV JYTHON_HOME $HOME/jython-$JYTHON_VERSION
ENV JYTHON_BIN $JYTHON_HOME/bin

RUN echo '***** Download and install Jython *****'                             \
    && curl -O $JYTHON_INSTALLERS_URL/$JYTHON_VERSION/$JYTHON_INSTALLER_JAR    \
    && java -jar $JYTHON_INSTALLER_JAR -s -d $JYTHON_HOME                      \
    && rm $JYTHON_INSTALLER_JAR                                                \
                                                                               \
    && echo '***** Put jython and pip commands in PATH *****'                  \
    && echo "export PATH=$JYTHON_BIN:$PATH" >> ~/.bashrc                       \
    && echo '***** Use pip to install python packages used by Kurator *****'   \
    && $JYTHON_BIN/pip install suds-jurko 


RUN echo '***** Pip install workflow dependencies *****' \ 
    && $JYTHON_BIN/pip install requests                                        \
    && $JYTHON_BIN/pip install python-dwca-reader                              \
    && $JYTHON_BIN/pip install py                                              \
    && $JYTHON_BIN/pip install unicodecsv                                      \
    && $JYTHON_BIN/pip install unidecode
# Make cloned Kurator Python packages available to Kurator
ENV JYTHONPATH $HOME/kurator-validation/packages:$HOME/kurator-akka/packages



# set up user's run-time environment
RUN echo '***** Download yw-prototypes executable jar, expand examples, and create alias *****'                 \
    && mkdir /home/kurator/kurator-validation/yw_jar  \
    && curl -L -o /home/kurator/kurator-validation/yw_jar/yesworkflow-0.2.1.2-jar-with-dependencies.jar https://github.com/yesworkflow-org/yw-prototypes/releases/download/v0.2.1.2/yesworkflow-0.2.1.2-jar-with-dependencies.jar

RUN echo '***** Download and build XSB 3.8 *****'                                                               \
    && mkdir /home/kurator/xsb-src \
    && wget -qO- https://sourceforge.net/projects/xsb/files/xsb/3.8%20Three-Buck%20Chuck/XSB38.tar.gz/download | tar xvz -C /home/kurator/xsb-src/  \
    && cd /home/kurator/xsb-src/XSB/build                                                                                         \
    && ./configure                                                                                              \
    && ./makexsb                                                                                                \
    && cd                                                                                                       \
    && echo 'export PATH="/home/kurator/xsb-src/XSB/bin:$PATH"' >> .bashrc
    

WORKDIR /home/kurator/kurator-validation

# start an interactive bash login shell when the image is run
CMD  /bin/bash -il

