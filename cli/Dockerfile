
FROM kurator/base:0.3.1

# perform remaining commands as the user and within the user's home directory
USER kurator
WORKDIR /home/kurator

# Kurator-Validation version
ENV KV_VERSION=0.3

# Variables defining URL to kurator-validation jar
ENV NEXUS_SERVICE=https://opensource.ncsa.illinois.edu/nexus/service
ENV SNAPSHOT_REPO=$NEXUS_SERVICE/local/repositories/snapshots/content
ENV KV_SNAPSHOTS=$SNAPSHOT_REPO/org/kurator/kurator-validation/$KV_VERSION-SNAPSHOT
ENV KV_SNAPSHOT_NAME=kurator-validation-$KV_VERSION-20160323.044806-1-jar-with-dependencies.jar
ENV KV_JAR_URL=$KV_SNAPSHOTS/$KV_SNAPSHOT_NAME
ENV KURATOR_VALIDATION_JAR=/home/kurator/bin/kurator-validation-$KV_VERSION.jar

# set up user's development environment and perform initial builds
RUN echo '***** Download kurator-validation executable jar *****'              \
 && mkdir ~/bin                                                                \
 && curl -o $KURATOR_VALIDATION_JAR $KV_JAR_URL

RUN echo '***** Create an alias for running Kurator-Akka *****'                \
 && echo "alias ka='java -jar $KURATOR_VALIDATION_JAR'" >> ~/.bash_aliases

# start an interactive bash login shell when the image is run
CMD /bin/bash -il
