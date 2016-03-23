
FROM kurator/cli-dev:0.3.1

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

# Make cloned Kurator Python packages available to Kurator
ENV JYTHONPATH $HOME/kurator-validation/packages:$HOME/kurator-akka/packages

# start an interactive bash login shell when the image is run
CMD  /bin/bash -il
