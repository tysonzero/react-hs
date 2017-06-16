#!/bin/bash

set -e
cd `dirname $0`
export PATH=$HOME/.local/bin:$HOME/bin:$PATH

if [ -e ./tweak-container.sh ]; then
    ./tweak-container.sh
fi

# build everything
export TARGETS="\
  react-hs \
  react-hs/test/spec \
  react-hs-examples \
  react-hs-examples/spec \
  react-hs-servant \
  "

for target in $TARGETS; do
  cd /react-hs/$target
  stack build --allow-different-user --fast --pedantic --test
done

# start selenium
./selenium.sh start

# run react-hs test suite
cd /react-hs/react-hs
make
cd test/client
npm install
cd ../spec
stack exec -- react-hs-spec
