#!/bin/sh

git shortlog -sn | cut -f2 | sort --ignore-case > CONTRIBUTORS
