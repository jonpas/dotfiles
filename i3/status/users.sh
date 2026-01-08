#!/bin/bash

users=$(w -h | wc -l)

echo {\"icon\": \"tasks\", \"state\": \"Good\", \"text\": \"$users\"}
