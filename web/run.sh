#!/usr/bin/env bash
docker run -it --net=host -p 9000:0.0.0.0/9000 kurator/web:0.1
