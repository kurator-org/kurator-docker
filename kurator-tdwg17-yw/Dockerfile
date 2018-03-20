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

# install packages 
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
USER  yw
WORKDIR  /home/yw

# set up user's run-time environment

RUN echo '***** Download yw-prototypes executable jar, expand examples, and create alias *****'                 \
    && mkdir ~/bin                                                                                              \
    && curl -L -o ~/bin/yw.jar https://github.com/yesworkflow-org/yw-prototypes/releases/download/v0.2.0/yesworkflow-0.2.0-jar-with-dependencies.jar \ 
    && cd /home/yw; jar -xvvf ~/bin/yw.jar examples                                                             \
    && echo "alias yw='java -jar ~/bin/yw.jar'"  >> ~/.bash_aliases

RUN echo '***** Download and build XSB 3.6 *****'                                                               \
    && svn checkout svn://svn.code.sf.net/p/xsb/src/trunk/XSB xsb-3.6                                           \
    && cd xsb-3.6/build                                                                                         \
    && ./configure                                                                                              \
    && ./makexsb                                                                                                \
    && cd                                                                                                       \
    && echo 'export PATH="/home/yw/xsb-3.6/bin:$PATH"' >> .bashrc
    

# start an interactive bash login shell when the image is run
CMD  /bin/bash -il

