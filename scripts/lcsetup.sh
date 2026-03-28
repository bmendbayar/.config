#!/bin/bash

if [-z "$1"]; then
    echo "Usage: ./lcsetup.sh <Problem Name>"
    exit 1
fi

problem_name=$1

mkdir -p "$problem_name"
cd "$problem_name"

cat << 'EOF' > CMakeLists.txt
cmake_minimum_required(VERSION 3.14)
project(LeetCodeSolution)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include(FetchContent)
FetchContent_Declare(
  googletest
  GIT_REPOSITORY https://github.com/google/googletest.git
  GIT_TAG release-1.12.1
)
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
FetchContent_MakeAvailable(googletest)

add_executable(solution_test test.cpp)

target_link_libraries(solution_test GTest::gtest_main)

include(GoogleTest)
gtest_discover_tests(solution_test)
EOF

cat << 'EOF' > solution.h
#pragma once
#include <iostream>
#include <vector>
#include <string>
#include <unordered_map>
#include <algorithm>

class Solution {
public:
    void foo(void *arg)
    {
    }
};
EOF

cat << 'EOF' > test.cpp
#include <gtest/gtest.h>
#include "solution.h"

TEST(SolutionTest, TestName)
{
    EXPECT_EQ(false, 0);
}
EOF

echo success
