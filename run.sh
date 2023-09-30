#!/bin/bash

# docker run -it --rm --mount type=bind,src=.,dst=/home/docker -w /home/docker python:3.11-slim bash

pip install -r requirements.txt
make
scoreWDLstat -r
python scoreWDL.py --NormalizeToPawnValue 100 > ./wdl_output.txt
