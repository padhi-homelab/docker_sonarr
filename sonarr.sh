#!/bin/sh

set -e

mono --debug /sonarr/Sonarr.exe -nobrowser -data=/config
