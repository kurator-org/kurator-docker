
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
    && echo '***** Install prerequisites required to build and run kurator tools *****'                             \
    && apt-get -y install maven git python python-pip python-dev r-base                                             \
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
RUN echo '***** Set up environment *****' \
    && mkdir projects \
    && mkdir deployments \
    && cd projects

RUN echo '***** Clone and build ffdq-api and kurator-ffdq projects *****' \
    && git clone https://github.com/kurator-org/ffdq-api.git \
    && cd ffdq-api \
    && mvn clean install \
    && cd .. \
    && git clone https://github.com/kurator-org/kurator-ffdq.git \
    && cd kurator-ffdq \
    && mvn clean install \
    && cd ..

RUN echo '***** Clone and build event_date_qc and geo_ref_qc projects *****' \
    && git clone https://github.com/FilteredPush/event_date_qc.git \
    && cd event_date_qc \
    && mvn clean install \
    && cd .. \
    && git clone https://github.com/FilteredPush/geo_ref_qc.git \
    && cd geo_ref_qc \
    && mvn clean install \
    && cd ..

RUN echo '***** Clone and build kurator-akka project *****' \
    && git clone https://github.com/kurator-org/kurator-akka.git \
    && cd kurator-akka \
    && mvn clean install \
    && cd ..

RUN echo '***** Clone and build kurator-validation workflows project *****' \
    && git clone https://github.com/kurator-org/kurator-validation.git \
    && cd kurator-validation \
    && mvn clean install \

RUN echo '***** Pip install workflow dependencies *****' \
    && cd packages\kurator-dwca \
    && ./pip install -r requirements.txt \
    && cd ../..

RUN echo '***** Clone and build kurator-web project *****' \
    && git clone https://github.com/kurator-org/kurator-web.git \
    && cd kurator-web \
    && cp conf/application.conf.example conf/application.conf \
    && bin/activator dist \

RUN echo '***** Deploy the kurator-web project *****' \
    && cp target/universal/kurator-web-1.0.2-SNAPSHOT.zip ../../deployments/kurator-web.zip \
    && cd ../../deployments \
    && unzip kurator-web.zip \
    && cd kurator-web \
    && ln -s /home/kurator/projects/kurator-validation/packages packages

# start an interactive bash login shell when the image is run
CMD  /bin/bash -il

CMD echo '***** Start kurator-web *****' \
    && cd deployments\kurator-web \
    && bin/kurator-web -Dhttp.address=0.0.0.0 -Dkurator.jar=/home/kurator/projects/kurator-validation/target/kurator-validation-1.0.2-SNAPSHOT-jar-with-dependencies.jar
