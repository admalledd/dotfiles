#!/bin/bash

#quick dirty script to make (most if not) all symlinks used


DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )


for i in $(ls ${DIR}/i3bin); do
    ln -s ${DIR}/i3bin/${i} ${HOME}/bin/${i}
done

ln -s ${DIR}/lighthouse/ ${HOME}/.config/