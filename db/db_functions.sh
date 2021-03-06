#/bin/bash

# custom fuctions for SQLite pipeline

function check_for_table {
    # check if a table exists in a SQLite database file
    local sqlite_db="$1"
    local table_name="$2"
    local test_result=$(sqlite3 "$sqlite_db" <<E0F
SELECT EXISTS (SELECT * FROM sqlite_master WHERE type='table' AND name='${table_name}');
E0F
    ) # returns 1 if table exists, 0 if it doesnt
    
    if [ "$test_result" -eq 1 ]; then 
        return 0 # bash successful exit status; TRUE
    elif [ "$test_result" -eq 0 ]; then
        return 1 # bash unsuccesful exit status; FALSE
    fi

}

# if DB exists, check for table
# if [ -f "$sqlite_db" ] ; then
#     if $(check_for_table "$sqlite_db" "$table_name"); then
#         echo -e "SUCCESS: Table $table_name exists in $sqlite_db."
#     else 
#         echo -e "ERROR: Table $table_name does not exist in $sqlite_db."
#     fi
# # elif [ ! -f "$sqlite_db" ]; then
# fi
