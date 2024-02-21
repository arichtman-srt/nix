#!/bin/sh
find . -maxdepth 1 -type d -not -path '*/.*' -not -path '.' -not -path './pe'  | xargs -I% cp .envrc .pre-commit-config.yaml %
find . -maxdepth 1 -type d -not -path '*/.*' -not -path '.' -not -path './pe'  | xargs -I% git add --force %/.envrc %/.pre-commit-config.yaml
