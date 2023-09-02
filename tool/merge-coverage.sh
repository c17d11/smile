#!/usr/bin/bash

LCOV_FILE_NAME="filtered.lcov.info"
COVERAGE_DIR="coverage"

get_relative_path() {
	find packages/*/$COVERAGE_DIR -mindepth 1 -maxdepth 1 -type f -name $LCOV_FILE_NAME | cut -d '/' -f-2 -
}

mkdir $COVERAGE_DIR
touch $COVERAGE_DIR/lcov.info
paths=$(get_relative_path)
for relative_path in ${paths[@]};
do
	cat "${relative_path}/${COVERAGE_DIR}/${LCOV_FILE_NAME}" | sed "s|^\(SF:\)\(.*\)$|\1${relative_path}/\2|g" >> $COVERAGE_DIR/lcov.info
done
