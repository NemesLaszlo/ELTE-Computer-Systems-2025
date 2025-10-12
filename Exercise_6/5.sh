#!/bin/bash

# Check if the registry file exists, if not, create it
registry_file="telephone_registry.txt"
if [ ! -e "$registry_file" ]; then
    touch "$registry_file"
fi

# Function to add a new entry to the registry
add_entry() {
    local name=$1
    local phone=$2
    
    # Check if the entry already exists
    #  The -q option for grep is used for quiet or silent mode. When you use grep -q, it suppresses all normal output, meaning 
    # it won’t print any matching lines. 
    # Instead, grep -q simply sets the exit status based on whether it found a match:
    #   Exit status 0: A match was found.
    #   Exit status 1: No match was found.
    #   Exit status 2: An error occurred.

    # "^$name,$phone$" → regex pattern that matches the exact line
    # Example: if name="John" and phone="123", it matches "John,123"
    if grep -q "^$name,$phone$" "$registry_file"; then
        echo "Entry already exists in the registry."
    else
        # Append the new entry to the registry file
        echo "$name,$phone" >> "$registry_file"
        echo "Entry added to the registry."
    fi
}

# Function to delete an entry from the registry
delete_entry() {
    local name=$1
    local phone=$2
    
    # Delete the entry from the registry
    # sed -i → edit the file in-place
    # "/^$name,$phone$/d" → delete any line that matches exactly "name,phone"
    sed -i "/^$name,$phone$/d" "$registry_file"
    echo "Entry deleted from the registry."
}

# Function to search for an entry in the registry
search_entry() {
    local name=$1
    
    # Search for the entry in the registry
    # grep "^$name," → finds lines that start with "name,"
    # cut -d',' -f2  → splits each matching line by comma (",")
    #                   and extracts the *second field* (the phone number)

    # Example:
    #   If a line is "Alice,5551234"
    #   -d',' tells cut to use ',' as a delimiter
    #   -f2 tells cut to select the second field (i.e., "5551234")
    grep "^$name," "$registry_file" | cut -d',' -f2
}

# Function to count the number of entries in the registry
count_entries() {
    # wc -l → counts lines in the file
    # "< $registry_file" redirects file input into wc
    local count=$(wc -l < "$registry_file")
    echo "Number of entries in the registry: $count"
}

# Function to list entries sorted by name
list_entries() {
    # sort   → sorts lines in a file
    # -t','  → sets the delimiter to ',' (so fields are split at commas)
    # -k1    → sort by the *first field* (the name)
    # -o "$registry_file" → write the sorted output back to the same file
    sort -t',' -k1 -o "$registry_file" "$registry_file"
    cat "$registry_file"
}

# Main program
case $1 in
    "-a" )
        add_entry "$2" "$3"
        ;;
    "-d" )
        delete_entry "$2" "$3"
        ;;
    "-s" )
        phone=$(search_entry "$2")
        if [ -n "$phone" ]; then
            echo "Phone number for $2: $phone"
        else
            echo "Entry not found in the registry."
        fi
        ;;
    "-c" )
        count_entries
        ;;
    "-o" )
        list_entries
        ;;
    *)
        echo "Usage: $0 [option] [name] [phone]"
        echo "Options:"
        echo "  -a Add an entry to the registry"
        echo "  -d Delete an entry from the registry"
        echo "  -s Search for a name in the registry"
        echo "  -c Count the number of entries in the registry"
        echo "  -o List entries sorted by name"
        ;;
esac
