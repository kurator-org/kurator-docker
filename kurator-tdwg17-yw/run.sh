#!/usr/bin/env bash
# docker run -it kurator/kurator-tdwg17-yw:0.1 
docker run -v ~/Downloads/results/:/home/kurator/kurator-validation/packages/kurator_FileBranchingTaxonLookup/workflows/results -it kurator/kurator-tdwg17-yw:0.1 
# docker run -v host_dir:docker_image_file_dir     % to share files/volumes/directories/folders between the docker container and the host machine, so that you are able to visualize the data files from your applications on your host machine.
