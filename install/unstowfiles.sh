#!/usr/bin/env bash

files=$(cat unstowfiles)

for file in $files; do
  if [[ -f "${HOME}/${file}" ]]; then
    mv ${HOME}/${file} ${HOME}/${file}.old
  fi
done