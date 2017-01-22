
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

EXPOSE 9000

# perform remaining commands as the user and within the user's home directory
USER  kurator
WORKDIR  /home/kurator

# set up user's development environment and perform initial builds
RUN echo '***** Download kurator-web zip archive *****' \
    && wget https://github.com/kurator-org/kurator-web/releases/download/v1.0.1/kurator-web-1.0.1.zip

RUN echo '***** Install Jython 2.7.1b3 *****' \
    && unzip kurator-web-1.0.1.zip \
    && cd kurator-web-1.0.1/lib \
    && java -jar jython-installer-2.7.1b3.jar -s -d ../jython

RUN echo '***** Pip install workflow dependencies *****' \
    && cd kurator-web-1.0.1/jython/bin \
    && ./pip install python-dwca-reader \
    && ./pip install py \
    && ./pip install unicodecsv \
    && ./pip install unidecode \
    && ./pip install chardet

RUN echo '***** Clone kurator-validation workflows project *****' \
    && git clone https://github.com/kurator-org/kurator-validation.git \
    && cd kurator-web-1.0.1 \
    && ln -s ../kurator-validation/packages/ packages

# start an interactive bash login shell when the image is run
CMD  /bin/bash -il

CMD echo '***** Start kurator-web *****' \
    && cd kurator-web-1.0.1 \
    && bin/kurator-web
