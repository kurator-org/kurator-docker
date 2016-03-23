FROM kurator/base:0.3.1

RUN echo '***** Install packages required to build and run Kurator *****'      \
 && apt-get -y install maven

USER  kurator
WORKDIR  /home/kurator

RUN echo '***** Clone  kurator-akka repo and build *****'                      \
 && git clone https://github.com/kurator-org/kurator-akka.git                  \
 && cd ~/kurator-akka                                                          \
 && mvn install

RUN echo '***** Clone kurator-validation repo and builc *****'                 \
 && git clone https://github.com/kurator-org/kurator-validation.git            \
 && cd ~/kurator-validation                                                    \
 && mvn install

ENV KA_JAR_DIR  /home/kurator/kurator-validation/target
ENV KA_JAR_NAME kurator-validation-0.3-SNAPSHOT-jar-with-dependencies.jar

RUN echo '***** Create an alias for running Kurator *****'                     \
 && echo "alias ka='java -jar $KA_JAR_DIR/$KA_JAR_NAME'"  >> ~/.bash_aliases

# start an interactive bash login shell when the image is run
CMD  /bin/bash -il
