# files to db

Inserts a list of files into a SQLite 3 database, which can by queried. This is
especially useful for systems where file searching is slow and/or many files
exist.

## Usage

```sh
# Create the database and insert files
$ files_to_db [<file>] [...]

# Find the largest file
sqlite3 files.db 'select file from files order by size desc limit 1'
```

Upon calling `files_to_db`, a `files.db` SQLite 3 database file is created in
the current directory. If no files are specified, all files in the current
directory are inserted into the database.

## Database Table Columns

Column | Description
------ | ------------------------------------------
`id`   | Row id
`file` | Absolute path to the file
`size` | File size in bytes

## Testing

```sh
$ make test
```

