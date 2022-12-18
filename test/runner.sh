#! /usr/bin/env bash
# vim: filetype=sh syntax=sh

set -uo pipefail

cd "$FDB_TEST_DIRECTORY"

readonly TEST_CASES=( $(ls "tests"/) )
readonly FDB_TEST_FILES=( $(find "${FDB_TEST_DIRECTORY}/files" -mindepth 1 -maxdepth 1) )

FDB_TMP_DIRECTORY=

export FDB_TEST_FILES

function on_sigint()
{
  if [[ -d "$FDB_TMP_DIRECTORY" ]]
  then
    rm -r "$FDB_TMP_DIRECTORY"
  fi

  exit 0
}

trap on_sigint SIGINT

if [[ ${#TEST_CASES[@]} -eq 0 ]]
then
  echo -e "\033[33mNo tests\033[0m"

  exit
fi

test_index=1

for test in "${TEST_CASES[@]}"
do
  FDB_TMP_DIRECTORY="$(mktemp -d ${FDB_TEST_DIRECTORY}/.fdb_XXXXXX)"

  file_name="${test##*/}"
  file_stem="${file_name%.sh}"
  file_title="${file_stem//_/ }"

  echo -n "[${test_index}/${#TEST_CASES[@]}] "

  if [[ ! -e "$FDB_TMP_DIRECTORY" ]]
  then
    mkdir -p "$FDB_TMP_DIRECTORY"
  fi

  _output=$(cd "$FDB_TMP_DIRECTORY" && source "${FDB_TEST_DIRECTORY}/tests/${test}")
  _error_code=$?

  if [[ $_error_code -eq 0 ]]
  then
    echo -e "\033[0;42;30m ✓ \033[0m ${file_title}"
  else
    echo -e "\033[0;41;30m ✗ \033[0m ${file_title}"
    echo -e "  Error code: ${_error_code}"
    echo -e "  Output: ${_output}"

    rm -rf "$FDB_TMP_DIRECTORY"

    exit 1
  fi

  rm -rf "$FDB_TMP_DIRECTORY"

  ((test_index++))
done

