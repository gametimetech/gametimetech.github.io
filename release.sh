#!/bin/sh -e

prepath() {
    if [ ! -d "$1" ]; then
        echo 1>&2 "$1 is not a directory."
        return 1
    fi
    dir=$(cd $1; /bin/pwd)
    if echo ":$PATH:" | grep -q ":$dir:"; then
        echo 1>&2 "$dir already in path."
    else
        PATH="$dir:$PATH"
    fi
}

cabal sandbox init
cabal install --only-dependencies
prepath .cabal-sandbox/bin

cabal build && ./dist/build/site/site rebuild && ./dist/build/site/site watch
