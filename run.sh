#!/bin/bash

# docker run -it --rm --mount type=bind,src=.,dst=/home/docker -w /home/docker python:3.11-slim bash

apt-get update
apt-get install -y build-essential libz-dev

pip install -r requirements.txt
make
./scoreWDLstat -r
python scoreWDL.py --NormalizeToPawnValue 100 --pngName WDL_model_summary.png > ./wdl_output.txt
