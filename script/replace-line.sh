#!/bin/bash

die() {
    echo "Error: $@" 1>&2;
    print_help
    exit 1;
}

print_help() {
    echo "replace-line.sh [file] [line] [replacement]"
    exit 0
}

if [[ -z "$@" ]]; then
    print_help
fi

if ! [[ -e "$1" ]]; then
    die "First argument must be a valid file"
fi

number_re='^[0-9]+$'
if ! [[ $2 =~ $number_re ]] ; then
    die "Second argument must be a number"
fi

if [[ -z $3 ]]; then
    die "Third argument must be your replacement string"
fi

replacement=$(printf %q "$3")

perl -i -pe "
    BEGIN {
        \$replacement = \"$replacement\";
    }
    s/^.*$/\$replacement/g
    if \$. == $2
" $1
