#!/bin/bash
# 
# Grades students' submissions for the linked lists assignment.

# Current script name
SCRIPTNAME=$(basename $0)

# Prints the usage message to the user and exit
usage() {
    echo -e "\nUsage: $SCRIPTNAME <student_submission.c>\n"
    echo "Grades students' submissions for the linked lists assignment."
    echo
    echo "  <student_program.c>"
    echo "      The student's submission to be graded."
    echo
    echo "Example:"
    echo "  $SCRIPTNAME student_program.c"
    exit 1
}

# Prints the crash message to the user and exit
crashMessage() {
    echo "-------------------------------------------------"
    echo "Program crashed"
    echo
    echo "Compilation:  0 out of 10"
    echo "Correctness:  0 out of 40"
    echo "Memory leaks: 0 out of 20"
    echo
    echo "Total:        0 out of 70"

    # Remove the temporary directory
    rm -rf "$tmp_dir"
    exit 1
}

# Checking if the number of arguments is correct
if [ "$#" -ne 1 ]; then
    usage
fi

# Creating a temporary directory to store the student's submission
tmp_dir=$(mktemp -d -t tmp.robot_grader-XXXXX --tmpdir=/home/parmenin/Assignments/06)

# Check if the temporary directory was created successfully
if [ ! -d "$tmp_dir" ]; then
    echo "Failed to create temporary directory"
    exit 1
fi

# Copy the student's submission to the temporary directory - to be revised
cp "$1" "$tmp_dir"

# Go inside the temporary directory, if error then exit
cd "$tmp_dir" || exit 1

# Compile the student's code
gcc -Wall -Werror -fsanitize=address "$1" -o student_program

# Check if the code compiled without errors
if [ "$?" -ne 0 ]; then
    crashMessage

else
    # Check for memory leaks using -fsanitize=address
    leaks=$(ASAN_OPTIONS=detect_leaks=1 ./student_program 2>&1 >/dev/null | grep "SUMMARY: AddressSanitizer")

    # From leaks: retrieve the number specified after "leaked in" text
    if [ -n "$leaks" ]; then
        leak_blocks=$(echo "$leaks" | grep -oP "leaked in \K[0-9]+")
        memory_leaks=$((20 - leak_blocks * 2))
    else
        memory_leaks=20
    fi

    # Run the compiled program and capture the output
    output=$(./student_program)

    # Check if the word "Passed" is appearing in the output
    if [[ ! "$output" =~ "Passed" ]]; then
        passed_tests=0
        compilation_score=0
        correctness_score=0
        crashMessage

    else
        # Print the success output of the program
        echo "Good job: Code compiled without errors"
        echo "$output"

        # Extract the number of passed tests from: “Passed x/10 test cases”
        passed_tests=$(echo "$output" | grep -oP "Passed \K[0-9]+(?=/10 test cases)")

        # Calculate the scores
        compilation_score=10
        correctness_score=$((passed_tests * 4))
        total_score=$((compilation_score + correctness_score + memory_leaks))

        # Print the scores
        echo "-------------------------------------------------"
        echo "Passed $passed_tests/10 test cases"

        if [ "$memory_leaks" -ne 20 ]; then
            echo "Leaked $leak_blocks memory blocks"
        else
            echo "Leaked 0 memory blocks"
        fi

        echo
        echo "Compilation:  $compilation_score out of 10"
        echo "Correctness:  $correctness_score out of 40"
        echo "Memory leaks: $memory_leaks out of 20"
        echo
        echo "Total:        $total_score out of 70"
    fi
fi

# Remove the temporary directory
rm -rf "$tmp_dir"