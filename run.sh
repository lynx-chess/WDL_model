#!/bin/bash

# docker run -it --rm --mount type=bind,src=.,dst=/home/docker -w /home/docker python:3.11-slim bash

apt-get update
apt-get install -y build-essential

pip install -r requirements.txt
make
./scoreWDLstat -r
python scoreWDL.py --NormalizeToPawnValue 100 > ./wdl_output.txt
