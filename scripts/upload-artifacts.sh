#!/bin/sh

DIR=$1
shift

if test -n "$SHAREDARTIFACTSDIR"; then
    DIR="$SHAREDARTIFACTSDIR/$DIR"
    mkdir -p $DIR
    cp "$@" $DIR
else
    rclone copy --no-traverse "$@" artifacts:$DIR/
fi