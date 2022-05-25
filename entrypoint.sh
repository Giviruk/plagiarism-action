#!/bin/sh -l

export GITHUB_ACCESS_TOKEN=${1}
export REPOSITORY_NAME=${2}

# Compile sherlock.c file
gcc -o sherlock /sherlock.c
chmod +x sherlock
# Run python script to download all pull requests
rmdir solutions/
python3 /main.py "${GITHUB_ACCESS_TOKEN}" "${REPOSITORY_NAME}"

# Remove all ignored files
find ./solutions -name "*.git*" -type f -delete

# Remove all ignored files
find ./solutions -name "*proj*" -type f -delete

# Remove all ignored files
find ./solutions -name "*Tests*.cs" -type f -delete

find ./solutions -name "*Assembly*" -type f -delete

find ./solutions -name "*GlobalUsings*" -type f -delete

for D in $(find ./solutions -mindepth 1 -maxdepth 10 -type d)
do
    # Make every subdirectory flatten
    find "${D}" -mindepth 10 -type f -print -exec mv {} "${D}" \;
    # Remove folders from solutions
    find "${D}" -mindepth 10 -type d -exec rm -rf {} \;
done

mkdir outputs

# Launch sherlock for solutions
cd solutions ; ../sherlock -e .cs * $(echo ./*) > ../outputs/result.txt ; cd ..
cd solutions ; ../sherlock -e .fs * $(echo ./*) > ../outputs/result.txt ; cd ..
ls ./outputs
python3 /parser.py
