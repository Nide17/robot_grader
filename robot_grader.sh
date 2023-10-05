#!/bin/bash
#
# Grades students submissions.

# Checking the number of arguments
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <student_submission.c>"
    exit 1
fi

# Creating a temporary directory to store the student's submission
tmp_dir=$(mktemp -d "${TMPDIR:-./}/robot_grader.XXXXXXXXXX")

# Check if the temporary directory was created successfully
if [ ! -d "$tmp_dir" ]; then
    echo "Failed to create temporary directory"
    exit 1
fi

# Copy the student's submission to the temporary directory - to be revised
cp "$1" "$tmp_dir"
cp clist.h "$tmp_dir"
cp clist.c "$tmp_dir"

# Go inside the temporary directory, if error then exit
cd "$tmp_dir" || exit 1

# Compile the student's code
gcc -Wall -Werror -fsanitize=address "$1" clist.c -o student_program

# Check if the code compiled without errors
if [ "$?" -ne 0 ]; then
    echo "Program crashed"
    echo
    echo "Compilation: 0 out of 10"
    echo "Correctness: 0 out of 40"
    echo "Memory leaks: 0 out of 20"
    echo
    echo "Total: 0 out of 70"
    exit 0
fi

# Run the compiled program and capture the output
output=$(./student_program)

# Print the output
echo "Good job: Code compiled without errors"
echo "$output"

# Check for memory leaks using -fsanitize=address
leaks=$(ASAN_OPTIONS=detect_leaks=1 ./student_program 2>&1 >/dev/null | grep "SUMMARY: AddressSanitizer")
if [ -n "$leaks" ]; then
    leak_blocks=$(echo "$leaks" | awk -F ": " '{print $2}' | awk '{print $1}')
    memory_leaks=$((20 - leak_blocks * 2))
else
    memory_leaks=20
fi

# Count the number of passed tests
# passed_tests=$(echo "$output" | grep -c "Passed")
# Extract the number of passed tests from: “Passed x/10 test cases” using regex
regex="Passed ([0-9]+)\/10 test cases"
if [[ $output =~ $regex ]]; then
    passed_tests=${BASH_REMATCH[1]}
else
    passed_tests=0
fi

# Calculate the scores
compilation_score=10
correctness_score=$((passed_tests * 4))
total_score=$((compilation_score + correctness_score + memory_leaks))

# Print the scores
echo "-------------------------------------------------"
echo "Passed $passed_tests/10 test cases"
echo "Leaked $leak_blocks memory blocks"
echo
echo "Compilation:  $compilation_score out of 10"
echo "Correctness:  $correctness_score out of 40"
echo "Memory leaks: $memory_leaks out of 20"
echo
echo "Total:        $total_score out of 70"

# Clean up the temporary directory
rm -rf "$tmp_dir"