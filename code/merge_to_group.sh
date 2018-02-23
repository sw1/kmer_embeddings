#!/bin/bash

usage() { echo "Usage: $0 [-s <string>] [-o] [-h]" 1>&2; exit 1; }

while getopts "s:oh" opt; do
    case $opt in
        s)
            s=${OPTARG}
            ;;
        o)
            o=true
            ;;
        h)
            usage
            ;;
        *)
            usage
            ;;
    esac
done

if [[ -z "${s}" ]]; then
    usage
fi

OUT="/home/sw424/embed_samples/data/groups"
FN=${OUT}/group_${s}.fasta

if [[ -f $FN ]]; then
    if [[ $o == true ]]; then
        rm $FN
    else
        echo "$FN exists, exiting."
        exit 1
    fi
fi

mkdir -p $OUT

DATA="/home/sw424/embed_samples/data/split"
IDS=( ERR1249998 ERR1080271 ERR1233472 ERR1249697 \
    ERR1233470 ERR1073507 ERR1073636 ERR1075330 ERR1073635 )

for id in "${IDS[@]}"
do
    echo "Dumping $id."
    cat ${DATA}/${id}.fasta >> $FN
done

exit 0
