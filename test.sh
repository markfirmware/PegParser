#!/bin/bash

mkdir -p pharo
pushd pharo
wget -O- https://get.pharo.org/64 | bash
ls -lt
HOME=$(pwd) ./pharo Pharo.image st ../test.st
popd
