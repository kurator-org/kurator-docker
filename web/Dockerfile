
# start from a debian image with Java 8 and git preinstalled
FROM  kurator/web-dev:0.1                                                 

# perform remaining commands as the user and within the user's home directory
USER  kurator
WORKDIR  /home/kurator                    

# start an interactive bash login shell when the image is run
CMD  cd ~/kurator-web                                                               \
     && mvn package play2:run