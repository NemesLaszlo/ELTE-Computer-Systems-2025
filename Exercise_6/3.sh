#!/bin/bash

# Function to display help message
display_help() {
    echo "Usage: $0 [number1] [number2] ... [number10]"
    echo "Add up to 10 numbers and print the result."
    echo
    echo "Options:"
    echo "  -h, -help    Display this help message"
    exit 0
}

# Check for help options
if [ "$1" == "-h" ] || [ "$1" == "-help" ]; then
    display_help
fi

# Check if there are no parameters
if [ "$#" -eq 0 ]; then
    echo "Error: No numbers provided. Use -h or -help for help."
    exit 1
fi

# Check if more than 10 arguments are provided
if [ "$#" -gt 10 ]; then
    echo "Error: Too many numbers provided. Maximum allowed is 10."
    echo "Use -h or -help for usage instructions."
    exit 1
fi

# Initialize sum to 0
sum=0

# Loop through parameters and validate each one
for number in "$@"; do
    # Check if argument is a valid integer (positive or negative)
    if ! [[ "$number" =~ ^-?[0-9]+$ ]]; then
        echo "Error: '$number' is not a valid number."
        echo "Use -h or -help for usage instructions."
        exit 1
    fi
    # Add number to sum
    sum=$((sum + number))
done

# Print the result
echo "Sum of the numbers: $sum"
