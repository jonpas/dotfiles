#!/bin/bash

zsh -ic "alias" | sed 's/=/ /' | awk '{print $1}'
