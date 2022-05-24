#!/bin/sh -l

export GITHUB_ACCESS_TOKEN=${1}
export REPOSITORY_NAME=${2}
ls
# Compile sherlock.c file
gcc sherlock.c -o sherlock
chmod +x sherlock

tree

# Run python script to download all pull requests
python3 ./download.py "${GITHUB_ACCESS_TOKEN}" "${REPOSITORY_NAME}"

# Remove all not .cs files
find ./solutions/ -not -name "*.cs" -type f -delete

# Remove all ignored files
find ./solutions/ -name "*Test.cs" -type f -delete

for D in $(find ./solutions -mindepth 1 -maxdepth 1 -type d)
do
    # Make every subdirectory flatten
    find "${D}" -mindepth 1 -type f -print -exec mv {} "${D}" \;
    # Remove folders from solutions
    find "${D}" -mindepth 1 -type d -exec rm -rf {} \;
done

mkdir outputs

# Launch sherlock for solutions
cd solutions ; ../sherlock -e cs $(echo ./*) > ../outputs/result.txt ; cd ..

python3 ./parser.py
