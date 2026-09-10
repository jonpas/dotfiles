#!/bin/bash

bash -ic "alias" | sed 's/=/ /' | awk '{print $2}'
