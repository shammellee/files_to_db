#! /usr/bin/env bash
# vim: filetype=sh syntax=sh

set -euo pipefail

readonly SQLITE_HEADER_STRING='SQLiteformat3'

$FDB_COMMAND ${FDB_TEST_FILES[@]} > /dev/null

if [[ ! -f "$FDB_DATABASE" ]] || [[ "$SQLITE_HEADER_STRING" != $(od -An -cN15 "$FDB_DATABASE" | tr -d '[:space:]') ]]
then
  echo "${FDB_DATABASE} is not a database"

  exit 1
fi

result=($(sqlite3 -batch -column -noheader -readonly "${FDB_DATABASE}" << SQL
SELECT \`id\` FROM \`$FDB_DATABASE_TABLE\`
SQL
))

if [[ ${#result[@]} -ne ${#FDB_TEST_FILES[@]} ]]
then
  exit 1
fi

