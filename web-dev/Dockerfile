
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
    && echo '***** `# Remove the oracle-java7 package as the deault in favor of java8 *****'                        \
    && update-java-alternatives -s java-1.8.0-openjdk-amd64                                                         \
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
                       --password `echo kurator | makepasswd --crypt-md5 --clearfrom - | cut -b11-`                 \
                                                                                                                    \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers


EXPOSE 9000

# perform remaining commands as the user and within the user's home directory
USER  kurator
WORKDIR  /home/kurator

# set up user's development environment and perform initial builds
RUN echo '***** Set up environment *****' \
    && mkdir projects \
    && mkdir deployments

RUN echo '***** Clone and build ffdq-api and kurator-ffdq projects *****' \
    && cd projects \
    && git clone https://github.com/kurator-org/ffdq-api.git \
    && cd ffdq-api \
    && mvn clean install -DskipTests \
    && cd .. \
    && git clone https://github.com/kurator-org/kurator-ffdq.git \
    && cd kurator-ffdq \
    && mvn clean install -DskipTests

RUN echo '***** Clone and build event_date_qc and geo_ref_qc projects *****' \
    && cd projects \
    && git clone https://github.com/FilteredPush/event_date_qc.git \
    && cd event_date_qc \
    && mvn clean install -DskipTests \
    && cd .. \
    && git clone https://github.com/FilteredPush/geo_ref_qc.git \
    && cd geo_ref_qc \
    && mvn clean install -DskipTests

RUN echo '***** Clone and build kurator-akka project *****' \
    && cd projects \
    && git clone https://github.com/kurator-org/kurator-akka.git \
    && cd kurator-akka \
    && mvn clean install -DskipTests

RUN echo '***** Clone and build kurator-validation workflows project *****' \
    && cd projects \
    && git clone https://github.com/kurator-org/kurator-validation.git \
    && cd kurator-validation \
    && mvn clean install -DskipTests 

RUN echo '***** Pip install workflow dependencies *****' \
    && cd projects \
    && cd kurator-validation/packages/kurator_dwca \
    && sudo pip install -r requirements.txt

RUN echo '***** Clone and build kurator-web project *****' \
    && cd projects \
    && git clone https://github.com/kurator-org/kurator-web.git \
    && cd kurator-web \
    && cp conf/application.conf.example conf/application.conf \
    && bin/activator clean compile dist 

RUN echo '***** Deploy the kurator-web project *****' \
    && unzip projects/kurator-web/target/universal/kurator-web-1.0.2-SNAPSHOT.zip -d deployments \
    && cd deployments \
    && ln -s kurator-web-1.0.2-SNAPSHOT kurator-web \
    && cd kurator-web \
    && ln -s /home/kurator/projects/kurator-validation/packages packages

# start an interactive bash login shell when the image is run
CMD  /bin/bash -il

CMD echo '***** Start kurator-web *****' \
    && cd deployments/kurator-web \
    && bin/kurator-web -Dhttp.address=0.0.0.0 -Dkurator.jar=/home/kurator/projects/kurator-validation/target/kurator-validation-1.0.2-SNAPSHOT-jar-with-dependencies.jar
