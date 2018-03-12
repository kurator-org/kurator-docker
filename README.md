# kurator-docker
Docker images for Kurator projects.

See the following for installing docker and prerequisites: 

https://docs.docker.com/install/linux/docker-ce/debian/#install-docker-ce

### Kurator Web Docker Image

The kurator-web docker image contains the web app and all the prerequisites (workflow engine and workflows) installed in a single docker container for testing purposes.

The configuration and scripts for this container are located in the [web-dev directory](https://github.com/kurator-org/kurator-docker/tree/master/web-dev) of this top level project.

#### Usage

First clone this project via git:

    git clone https://github.com/kurator-org/kurator-docker.git
    
Next, with docker installed on your local machine, build the web-dev container as root via the provided build.sh script:

    cd web-dev
    sudo ./build.sh
    
Lastly, once build has succeeded, run the web app container via the run.sh script. The web app and docker container will listen on port 9000 by default:

    sudo ./run.sh
    
Once the web app has started visit at http://localhost:9000/ in a browser on the host machine.

