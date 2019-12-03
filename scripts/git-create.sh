#!/bin/bash

# Script to automate the deployment of new private gitlab repos
# TODO: simplify and enhance error handling (already existing repos etc.)
#       expand script to handle: public repos, deletion, re-naming

token="AkByku-MUzDAoerEmAd9"

function usage {
  echo "Usage: $0 -n name"
  exit 1
}

number_args=$#
if [[ !("$number_args" -eq 2) ]]; then
  echo "Incorrect number of args" >&2
  echo "If two strings in name, quote them: e.g. \"str1 str2\""
  usage
fi

while getopts "n:" name; do
  case "${name}" in
    n)
      repo=${OPTARG}
      ;;
    \?)
      usage
      ;;
    *)
      usage
      ;;
  esac
done

if [[ -z ${repo} ]]; then
  echo "Option -n requires an argument." >&2
  usage
else
  echo "#######\nCreating new repo: ${repo}\n#######\n"
fi

# In case space separate words are used for the repo name, the first word will be used
# when naming the json output file.
repo_short=$(echo ${repo} | cut -d " " -f1)

response=$(curl -k -s -o ./temp.json -w '%{http_code}' \
-H "Content-Type:application/json" https://git.babel.es:4433/api/v4/projects?private_token=$token \
-d "{ \"name\": \"${repo}\" }")

# Format JSON log
cat ./temp.json | python -m json.tool > ./${repo_short}_repo.json
rm -f ./temp.json

echo "Any JSON output is logged in ./${repo_short}_repo.json"
if [ $response != 201 ]; then
  echo "Error\nResponse code: $response"
  exit 1
else
  echo "Repo successfully created\nResponse code: $response"
  exit 0
fi
