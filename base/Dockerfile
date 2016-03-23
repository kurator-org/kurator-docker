FROM java:8

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

RUN echo '***** make Java 8 the default for java and javac commands *****'                       \
 && update-alternatives --set java  $JAVA_HOME/jre/bin/java               \
 && update-alternatives --set javac $JAVA_HOME/bin/javac

RUN echo '***** Update apt packages *****'                                                       \
 && apt-get -y update                                                                            \
                                                                                                 \
 && echo '***** Install packages REQUIRED for creating this image *****'                         \
 && apt-get -y install curl makepasswd                                                           \
                                                                                                 \
 && echo '***** Install packages NOT required to build and run kurator tools *****'              \
 && apt-get -y install sudo apt-utils man less file tree vim emacs

RUN echo '***** Create the kurator user *****'                                                   \
 && useradd kurator --gid sudo                                                                   \
                    --shell /bin/bash                                                            \
                    --create-home                                                                \
                    --password `echo kurator | makepasswd --crypt-md5 --clearfrom - | cut -b11-`

# start an interactive bash login shell when the image is run
CMD  /bin/bash -il
