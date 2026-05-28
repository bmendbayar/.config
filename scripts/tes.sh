#!/bin/bash

if [ -z "$1" ]; then
    echo "usage: tes [problem name]"
    exit 1
fi

PROBLEM_NAME=$1

mkdir -p "$PROBLEM_NAME"
cd "$PROBLEM_NAME"

cat << EOF > CMakeLists.txt
cmake_minimum_required(VERSION 3.14)
project($PROBLEM_NAME)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include(FetchContent)
FetchContent_Declare(
  googletest
  URL https://github.com/google/googletest/archive/refs/tags/release-1.12.1.zip
  DOWNLOAD_EXTRACT_TIMESTAMP TRUE
)
FetchContent_MakeAvailable(googletest)

add_executable(test test.cpp)
target_link_libraries(test GTest::gtest_main)
EOF

cat << EOF > solution.h
#pragma once

#include <algorithm>
#include <iostream>
#include <string>
#include <unordered_map>
#include <vector>

class Solution {
public:
    void foo(void *arg)
    {
    }
};
EOF

cat << EOF > test.cpp
#include <gtest/gtest.h>

#include "solution.h"

class SolutionTest : public ::testing::Test {
protected:
    Solution sol;

    void SetUp() override
    {
    }
};

TEST_F(SolutionTest, TestName)
{
    EXPECT_EQ(false, 0);
}
EOF

mkdir build && cd build && cmake .. && cd ..
echo success
