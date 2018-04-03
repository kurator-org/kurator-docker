FROM  kurator/cli-dev:0.3.1

USER root 
RUN echo '***** Clone kurator-TDWG17-YW workflows project *****' \
     && cd /home/kurator/kurator-validation \
     && git clone https://github.com/kurator-org/kurator-TDWG17-YW.git \
     && cp -r kurator-TDWG17-YW/queries .\
     && cp -r kurator-TDWG17-YW/rules .\
     && cp  kurator-TDWG17-YW/*.sh .\
     && cp kurator-TDWG17-YW/*.properties .\
     && cp -r kurator-TDWG17-YW/kurator_FileBranchingTaxonLookup ./packages/

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
                                                                               \
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


RUN echo '***** Update packages *****'                                                                          \
    && apt-get -y update                                                                                        \
                                                                                                                \
    && echo '***** Install packages REQUIRED for creating this image *****'                                     \
    && apt-get -y install curl makepasswd gcc make                                                              \
                                                                                                                \
    && echo '***** Install packages required by YesWorkflow *****'                                              \
    && apt-get -y install graphviz                                                                              \
                                                                                                                \
    && echo '***** Install packages NOT required to run yesworkflow *****'                                      \
    && apt-get -y install sudo apt-utils man less file tree vim emacs                                           \
    && apt-get clean
    # clean up the apt cache after apt-get update 
                  
# create an unprivileged user
RUN echo '***** Create the yw user *****'                                                                       \
    && useradd yw --gid sudo                                                                                    \
                 --shell /bin/bash                                                                              \
                 --create-home                                                                                  \
                 --password `echo yeswf | makepasswd --crypt-md5 --clearfrom - | cut -b11-`

# perform remaining commands as the user and within the user's home directory
WORKDIR  /home/yw

# set up user's run-time environment

RUN echo '***** Download yw-prototypes executable jar, expand examples, and create alias *****'                 \
    && mkdir ~/bin                                                                                              \
    && curl -L -o ~/bin/yw.jar https://github.com/yesworkflow-org/yw-prototypes/releases/download/v0.2.1.2/yesworkflow-0.2.1.2-jar-with-dependencies.jar\ 

    && cd /home/yw; jar -xvvf ~/bin/yw.jar examples                                                             \
    && echo "alias yw='java -jar ~/bin/yw.jar'"  >> ~/.bash_aliases

RUN echo '***** Download and build XSB 3.8 *****'                                                               \
    && svn checkout svn://svn.code.sf.net/p/xsb/src/trunk xsb-src \
    && cd xsb-src/XSB/build                                                                                         \
    && ./configure                                                                                              \
    && ./makexsb                                                                                                \
    && cd                                                                                                       \
    && echo 'export PATH="/home/yw/xsb-src/XSB/bin:$PATH"' >> .bashrc
    

# start an interactive bash login shell when the image is run
CMD  /bin/bash -il

