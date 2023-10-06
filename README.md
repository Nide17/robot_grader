## Robot Grader Shell Script

__INTRODUCTION__

This repository contains a shell script that is used to grade students' submissions for an assignment related to linked lists. It assesses the correctness of the students' code, check for memory leaks, and evaluate their code compilation.

__DESCRIPTION__

This script is used to grade students' submissions for an assignment related to linked lists. It assesses the correctness of the students' code, check for memory leaks, and evaluate their code compilation.

__IMPORTANCE__

This script is important because it can allow the students to test their code before submitting it, knowing the number of memory blocks leaked by their code before submitting it, and knowing whether their code will compile or not.

__GETTING STARTED__

The shell script is invoked with a single argument, which is the path to the student's .c file that is going to be graded. If the user provides 0 or more than 1 arguments, the script prints a usage message and exit with a non-zero error code.

```
./robot_grader student_submission.c
```
**Handling Different Scenarios:**

The script handles the following scenarios:

- If the student's code fails to compile, the script prints a compilation error message.
- If the student's code crashes, the script detects it and print an appropriate message.
- If the student's code runs successfully, the script assesses correctness and check for memory leaks.

All output from the student's program, including both stdout and stderr, are passed through to the stdout of the Robot Grader.

**Temporary Directory**
The script creates a temporary directory to store the student's submission and any files generated during grading. It should not modify or create any files outside this temporary directory.
  
__TESTING__

This script is implemented and tested against the student_test.c file. It simulates a student's submission with configurable behavior. A user can set environment variables to control the number of tests passed, memory leaks, and whether the program should crash.

**Environment Variables**
- A6_TESTS_PASSED: An integer between 0 and 10 (default: 9) to simulate the number of tests passed.
- A6_NUM_MEMLEAKS: An integer between 0 and 10 (default: 1) to simulate the number of memory leaks.
- A6_FORCE_CRASH: If set, the program will crash.

***Examples***

- To simulate a student submission with 4 tests passed and no memory leaks:
```
A6_TESTS_PASSED=4 ./robot_grader student_test.c
```

- To simulate a perfect student submission:
```
A6_TESTS_PASSED=10 A6_NUM_MEMLEAKS=0 ./robot_grader student_test.c
```

- To test the case where the submitted code does not compile, introduce an error in the .c file.
  
__KEYWORDS__

<mark>ISSE</mark>     <mark>CMU</mark>     <mark>Assignment6</mark>     <mark>robot_grader</mark>     <mark>Shell Script</mark>     <mark>Linked Lists</mark>

__AUTHOR__

 Written by parmenin (Niyomwungeri Parmenide ISHIMWE) at CMU-Africa - MSIT

__DATE__

 October 06, 2023