#!/bin/sh -l

export GITHUB_ACCESS_TOKEN=${1}
export REPOSITORY_NAME=${2}

# Compile sherlock.c file
gcc -o sherlock /sherlock.c
chmod +x sherlock
ls ./
# Run python script to download all pull requests
rmdir /solutions/
python3 /main.py "${GITHUB_ACCESS_TOKEN}" "${REPOSITORY_NAME}"

# Remove all not .cs files
find /solutions/ -not -name "*.cs" -type f -delete

# Remove all ignored files
find /solutions/ -name "*Test.cs" -type f -delete

for D in $(find /solutions -mindepth 1 -maxdepth 3 -type d)
do
    # Make every subdirectory flatten
    find "${D}" -mindepth 3 -type f -print -exec mv {} "${D}" \;
    # Remove folders from solutions
    find "${D}" -mindepth 3 -type d -exec rm -rf {} \;
done

mkdir outputs

# Launch sherlock for solutions
cd solutions ; ../sherlock -e cs $(echo ./*) > ../outputs/result.txt ; cd ..

python3 /parser.py
