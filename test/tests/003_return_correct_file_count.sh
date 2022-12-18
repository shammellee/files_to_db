#! /usr/bin/env bash
# vim: filetype=sh syntax=sh

set -euo pipefail

$FDB_COMMAND "${FDB_TEST_FILES[0]}" "${FDB_TEST_FILES[1]}" > /dev/null

result=$(sqlite3 -batch -column -noheader -readonly "${FDB_DATABASE}" << SQL
SELECT COUNT(*) FROM \`$FDB_DATABASE_TABLE\`
SQL
)

if [[ ${result} -ne 2 ]]
then
  echo "Record count: ${result}"

  exit 1
fi

