# cardano-entropy

[![workflow](https://github.com/input-output-hk/cardano-entropy/actions/workflows/haskell.yml/badge.svg?branch=main)](https://github.com/input-output-hk/cardano-entropy/actions/workflows/haskell.yml?branch=main)

## Background

The Cardano entropy parameter will be updated during the epoch starting on `April 5, 2021`;
the entropy parameter will be determined by the hash of the last block prior to
`Wed Apr 7`, `15:44:51 UTC = slot 151200` of `epoch 258`; this hash value appears in the first
block appearing in slot `151200` or later.

Considering the hash chain structure of the blockchain, this block hash is determined by the
entire chain up to this point. Note that the parameter update mechanism requires delegates'
votes to appear on-chain prior to `Wed Apr 7`, `15:44:51 UTC = slot 151200` of `epoch 25`.

IO Global scientists and engineers will inject transactions with metadata determined by several
public sources of entropy: hashes of the closing prices of the New York Stock Exchange (NYSE) on
`April 6 2021`, and real-time seismic data from the US Geological Survey (USGS), the University of
Athens, and the Japan Meteorological Society.

A more detailed timeline of the process is presented below:

```
Epoch starts:                                           Mon Apr 5, 21:44:51 UTC = slot 0 of epoch 258
Insert randomness generated on or after:                Tue Apr 6, 9:44:51 UTC = slot 43200 of epoch 258
(NYSE opens)                                            Tue Apr 6, 13:30 UTC
(NYSE closes)                                           Tue Apr 6, 20:00 UTC
(NYSE data available on eoddata.com)                    Wed Apr 7, 1:00 UTC
Seismic data window                                     Epoch start <= WINDOW < Wed Apr 7, 9:44:51 UTC
Insert randomness before:                               Wed Apr 7, 15:44:51 UTC = slot 151200 of epoch 258
Nonce = prev-block hash from first block on or after:   Wed Apr 7, 15:44:51 UTC = slot 151200 of epoch 258
Parameter-changing Tx must be included before:          Wed Apr 7, 21:44:51 UTC = slot 172800 of epoch 258
```

## Pre-requisites

### Install Selenium Server and Chrome Driver

You will need to install both the Selenium Server *and* the Chrome Driver.

**Note**: Some of the commands require that you have the Selenium server running in the background.

#### macOS

Use these commands to install the Selenium server and the Chrome Driver on macOS:

```bash
$ brew install selenium-server-standalone
$ brew install chromedriver
```

Run the server using:

```bash
$ selenium-server -port 4444
```

#### macOS (or Linux via Docker)

To run:

```bash
$ docker run -d -p 4444:4444 -v /dev/shm:/dev/shm -v "$WORKSPACE:$WORKSPACE" selenium/standalone-chrome:4.0.0-beta-3-prerelease-20210321
```

**Note**: The directory pointed to by `$WORKSPACE` *must* exist, and it must remain the same for running the commands below.

## Download NYSE data and take its hash

Run these commands to download data from the NYSE website and take the data's hash.

```bash
$ cardano-entropy nyse --workspace="$WORKSPACE" --username="$USERNAME" --password="$PASSWORD" --date="$DATE"
Downloaded: /Users/jky/tmp/download-0ac80eea1ebf36da/NYSE_20210319.csv
Hash: 42e1611e701d4b8885da5ef5cf54f2e4a56f77b675835fcae6c132aff09a0f46
```

Options:

* `--workspace`: Where temporary files will go. This can be set to your temporary directory.
* `--username`: Username obtained by registering on this [end of day and historical stock data website](http://www.eoddata.com/).
* `--password`: Password obtained by registering on the [same website](http://www.eoddata.com/).
* `--end-date`: The last date for which end of day market data should be downloaded, in the format `YYYY-MM-DD`.
* `--days`: The number of days worth of data that should be downloaded.
* `--headless`: Whether or not to run Chrome in headless mode. `True` or `False`, default is set to `True`.

## Download GIS data and take its hash

Run these commands to download GIS data and take its hash.

```bash
$ cardano-entropy gis --workspace="$WORKSPACE" --end-date="$DATE"
Writing to: /Users/jky/tmp/download-373d2d3d91f049a8/all_month.csv
Filtering within 2021-03-25T00:00:00 <= event < 2021-03-26T00:00:00 to: /Users/jky/tmp/download-373d2d3d91f049a8/day_in_month.csv
Hash: 01100007fe87010b57521ebf3d3b5f5a7ab74b5153da00f3b8c607e3072f38dc
```

Options:

* `--workspace`: Where temporary files will go. This can be set to your temporary directory.
* `--date-date`: The date that marks the end of the 24-hour window that we want to filter the data for.

## Download earthquake data from the Japan Meteorological Society

Run these commands to download earthquake data from the Japan Meteorological Society website.

```bash
$ cardano-entropy jma-quake --workspace="$WORKSPACE" --end-date-time "$END_DATE_TIME' --hours "$HOURS"
Time window: 2020-03-22 06:00:00 UTC <= t < 2020-03-24 00:00:00 UTC
Downloading: "https://www.data.jma.go.jp/multi/data/VXSE53/en.json?_=1585008000000"
Downloaded to /Users/jky/tmp/download-jma-quake-74d6be37c450a863/latest.json
Filtered to /Users/jky/tmp/download-jma-quake-74d6be37c450a863/selected.json
Hash: 4f53cda18c2baa0c0354bb5f9a3ecbe5ed12ab4d8e11ba873c2f11161202b945
```

Options:

* `--workspace`: Where temporary files will go. This can be set to your temporary directory.
* `--end-date-time`: The date that marks the end of the window that we want to filter the data for.
* `--hours`: The length of the window (in hours) that we want to filter the data for.
