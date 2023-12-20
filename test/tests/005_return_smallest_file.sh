#! /usr/bin/env bash
# vim: filetype=sh syntax=sh

set -euo pipefail

$FDB_COMMAND "${FDB_TEST_FILES[@]}" > /dev/null

result="$(sqlite3 -batch -column -noheader -readonly "$FDB_DATABASE" << SQL
SELECT \`file\` FROM \`$FDB_DATABASE_TABLE\` ORDER BY \`size\` ASC LIMIT 1
SQL
)"

if [[ ! "$result" =~ empty_file.txt ]]
then
  echo $result

  exit 1
fi

