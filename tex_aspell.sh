#!/bin/bash

# Script to run aspell recursively on latex subfiles. Uses the command "\subfile{}".

# - edit the aspell options bellow:
OPTIONS=" -l pt_PT -t --dont-tex-check-comments"

# - only needs one argument, which is the root .tex file
# - must be run from the project's root directory (TODO, maybe)

# Recursively finds "\subfiles" and runs aspell on them
# $1 is the current file
# $2 is the current sub-directory, if exists
find_and_check () {
    readarray -t subfiles < <(grep -F "\subfile{" "$1" | cut -d \{ -f 2)

    for file in "${subfiles[@]}"; do
        # find next sub-directory
        subdir="${file%%/*}/"

        # remove trailing "}" and add previous sub-directory
        file=$2${file::-1}

        # recurse into subfile
        find_and_check $file "$2$subdir"
    done

    echo "$1"
    aspell $OPTIONS -c $1
}

if [ $# -lt 1 ]; then
    echo "Usage: tex_aspell [FILE]"
    echo "Runs aspell recursively on .tex subfiles."
    echo "Must be run from the directory of the root .tex file."
    exit 2
fi

find_and_check $1
exit 0
