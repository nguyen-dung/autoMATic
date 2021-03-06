#!/bin/bash

# automatically generate output for use with test.sh
# this assumes that everything is working correctly in the executable

TESTS_DIR_DEF="./tests"
TESTS_DIR="${1:-$TESTS_DIR_DEF}"

echo "Removing *.out, *.err, *.ll files..."
rm ${TESTS_DIR}/*.out
rm ${TESTS_DIR}/*.err
rm ${TESTS_DIR}/*.ll

for file in $TESTS_DIR/*.ic
do
    filename=$(eval "basename ${file%.*}")
    if [[ $filename = *"fail_"* ]]; then
        echo "NEGATIVE TEST ${filename}"
        output=$(eval "./automatic.native < ${file} &> ${TESTS_DIR}/${filename}.err")
    else
        echo "POSITIVE TEST ${filename}"
        output=$(eval "./automatic.native < ${file} > ${TESTS_DIR}/${filename}.ll")
        output=$(eval "sed -i '2d' ${TESTS_DIR}/${filename}.ll")
        output=$(eval "lli ${TESTS_DIR}/${filename}.ll > ${TESTS_DIR}/${filename}.out")
    fi
done
echo "Finished generating tests."
