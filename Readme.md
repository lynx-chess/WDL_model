# Generate SF WDL model based on data

TLDR:

- Place PGN files in `pgns/`

- Map the repo directory to a volume attached to a python Docker container

```bash
docker run -it --rm --mount type=bind,src=.,dst=/home/docker -w /home/docker python:3.11-slim bash
```

- Once inside:

```bash
./run.sh
```

----

Stockfish's "centipawn" evaluation is decoupled from the classical value
of a pawn, and is calibrated such that an advantage of
"100 centipawns" means the engine has a 50% probability to win
from this position in selfplay at move 32 at fishtest LTC time control.\
If the option `UCI_ShowWDL` is enabled, the engine will show Win-Draw-Loss
probabilities alongside its "centipawn" evaluation. These probabilities
depend on the engine's evaluation and the move number, and are computed
from a WDL model that can be generated from fishtest data with the help of
the scripts in this repository.

## Install
```
pip install -r requirements.txt
```

## Usage

To update Stockfish's internal WDL model, the following steps are needed:

1. Obtain a large collection of engine-vs-engine games 
(at fishtest LTC time control) in pgn format and
save the pgn files in the `pgns` folder. This can, for example, be achieved
by running `python download_fishtest_pgns.py` once a day.

2. Use `make` to compile `scoreWDLstat.cpp`, which will produce an executable
named `scoreWDLstat`.

3. Run `scoreWDLstat -r` to parse the pgn files in the `pgns` folder. A different
directory can be specified with `scoreWDLstat --dir <path-to-dir>`. The
computed WDL statistics will be stored in a file called `scoreWDLstat.json`.
The file will have entries of the form `"('D', 1, 78, 35)": 668132`, meaning
this tuple for `(outcome, move, material, eval)` was seen a total of 668132
times in the processed pgn files.

4. Run `python scoreWDL.py` to compute the WDL model parameters from the
data stored in `scoreWDLstat.json`. The script needs as input the value
`--NormalizeToPawnValue` from within Stockfish's
[`uci.h`](https://github.com/official-stockfish/Stockfish/blob/master/src/uci.h),
to be able to correctly convert the centipawn values from the pgn files to
the unit internally used by the engine. The script will output the new
values for `NormalizeToPawnValue` in
[`uci.h`](https://github.com/official-stockfish/Stockfish/blob/master/src/uci.h)
and `as[]`, `bs[]` in
[`uci.cpp`](https://github.com/official-stockfish/Stockfish/blob/master/src/uci.cpp). See e.g. https://github.com/official-stockfish/Stockfish/pull/4373

## Results

<p align="center">
  <img src="WDL_model_summary.png?raw=true" width="1200">
</p>

## Fitting options

- `python scoreWDL.py --yDataTarget 30` : choose move 30 (rather than 32)
as target move for the 100cp anchor
- `python scoreWDL.py --yData material --yDataTarget 68` : base fitting on
material (rather than move), with 100cp anchor a material count of 68
---
[![Code style: black](https://img.shields.io/badge/code%20style-black-000000.svg)](https://github.com/psf/black)
