/*
 * test_student.c
 * 
 * Simple code to simulate a student's submission, for use in
 * Assignment 6
 *
 * Author: Howdy Pierce <howdy@sleepymoose.net>
 */

#include <stdio.h>
#include <stdlib.h>

#define ENV_TESTS_PASSED "A6_TESTS_PASSED"
#define ENV_NUM_MEMLEAKS "A6_NUM_MEMLEAKS"
#define ENV_FORCE_CRASH  "A6_FORCE_CRASH"

void usage(const char *argv0)
{
  fprintf(stderr, "Usage: %s\n\n", argv0);
  fprintf(stderr, "Simulates student code for the CList assignment, printing\n");
  fprintf(stderr, "the number of tests passed and also possibly a memory leak notice\n\n");
  fprintf(stderr, "The behavior of this program is controlled by the\n");
  fprintf(stderr, "following environment variables, if they are present:\n");
  fprintf(stderr, "%s: Must be an integer between 0 and 10; default 9\n", ENV_TESTS_PASSED);
  fprintf(stderr, "%s: Must be an integer between 0 and 10; default 1\n", ENV_NUM_MEMLEAKS);
  fprintf(stderr, "%s:  If set, the program will crash\n", ENV_FORCE_CRASH);
}

int main(int argc, char *argv[])
{
  if (argc != 1) {
    usage(argv[0]);
    return 1;
  }

  int tests_passed = 9;
  int num_memleaks = 1;
  int force_crash = 0;

  if (getenv(ENV_TESTS_PASSED))
    tests_passed = atoi(getenv(ENV_TESTS_PASSED));

  if (getenv(ENV_NUM_MEMLEAKS))
    num_memleaks = atoi(getenv(ENV_NUM_MEMLEAKS));

  if (getenv(ENV_FORCE_CRASH))
    force_crash = 1;

  if (tests_passed < 0 || 10 < tests_passed) {
    fprintf(stderr, "Illegal value for tests_passed: %d\n", tests_passed);
    usage(argv[0]);
    return 1;
  }

  if (num_memleaks < 0 || 10 < num_memleaks) {
    fprintf(stderr, "Illegal value for memleaks: %d\n", num_memleaks);
    usage(argv[0]);
    return 1;
  }

  /* Begin simulated output */
  
  for (int i=0; i < 10 - tests_passed; i++) 
    printf("FAIL test_cl_nth[118] CL_nth(list, 0): expected 'One', got 'Two'\n");

  printf("[0]: charlie\n");
  printf("[1]: bravo\n");
  printf("[2]: alpha\n");

  if (force_crash) {
    const char *str = NULL;
    printf("%s\n", str);
  }

  printf("Passed %d/10 test cases\n", tests_passed);
  fflush(stdout);
  
  if (num_memleaks > 0) {

    fprintf(stderr, "\n=================================================================\n");
    fprintf(stderr, "==11135==ERROR: LeakSanitizer: detected memory leaks\n\n");

    for (int i=0; i < num_memleaks; i++) {
      fprintf(stderr, "Direct leak of 16 byte(s) in 1 object(s) allocated from:\n");
      fprintf(stderr, "    #0 0x7f715a310887 in __interceptor_malloc ../../../../src/libsanitizer/asan/asan_malloc_linux.cpp:145\n");
      fprintf(stderr, "    #1 0x556b9fbec3d7 in CL_new /home/howdy/Teaching/CMU-ISSE/Assignments/05/clist.c:56\n");
      fprintf(stderr, "    #2 0x556b9fbedd06 in test_cl_nth /home/howdy/Teaching/CMU-ISSE/Assignments/05/clist_test.c:103\n");
      fprintf(stderr, "    #3 0x556b9fbf1f01 in main /home/howdy/Teaching/CMU-ISSE/Assignments/05/clist_test.c:570\n");
      fprintf(stderr, "    #4 0x7f715a05dd8f in __libc_start_call_main ../sysdeps/nptl/libc_start_call_main.h:58\n\n");
    }

    fprintf(stderr, "SUMMARY: AddressSanitizer: %d byte(s) leaked in %d allocation(s).\n",
        num_memleaks * 16, num_memleaks);
    return 1;
  }

  return 0;
}
