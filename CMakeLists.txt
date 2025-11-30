cmake_minimum_required(VERSION 3.20)

project(cpp_template
    VERSION 0.1.0
    DESCRIPTION "Minimal C/C++ project with CMake, clang-format, Conan, and Catch2 tests"
    LANGUAGES C CXX)

# ------------------------------
# Language standards
# ------------------------------
set(CMAKE_C_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED ON)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# ------------------------------
# Library with shared code
# ------------------------------
add_library(project_lib
    src/add.cpp
)

target_include_directories(project_lib
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/include
)

# ------------------------------
# Main executable
# ------------------------------
add_executable(${PROJECT_NAME}
    src/main.cpp
)

target_link_libraries(${PROJECT_NAME}
    PRIVATE project_lib
)

if (MSVC)
    target_compile_options(${PROJECT_NAME} PRIVATE /W4)
    target_compile_options(project_lib PRIVATE /W4)
else()
    target_compile_options(${PROJECT_NAME} PRIVATE -Wall -Wextra -Wpedantic)
    target_compile_options(project_lib PRIVATE -Wall -Wextra -Wpedantic)
endif()

# ------------------------------
# clang-format targets
# ------------------------------
file(GLOB_RECURSE ALL_SOURCE_FILES
    ${CMAKE_SOURCE_DIR}/src/*.c
    ${CMAKE_SOURCE_DIR}/src/*.cpp
    ${CMAKE_SOURCE_DIR}/include/*.h
    ${CMAKE_SOURCE_DIR}/include/*.hpp
    ${CMAKE_SOURCE_DIR}/tests/*.cpp
)

add_custom_target(format
    COMMAND clang-format -i ${ALL_SOURCE_FILES}
    COMMENT "Formatting all source and header files with clang-format"
)

add_custom_target(format-check
    COMMAND clang-format --dry-run --Werror ${ALL_SOURCE_FILES}
    COMMENT "Checking code format with clang-format (no changes made)"
)

# ------------------------------
# Tests with Catch2 (via Conan)
# ------------------------------
include(CTest)
enable_testing()

# Catch2 is provided by Conan (CMakeDeps + toolchain)
find_package(Catch2 CONFIG REQUIRED)

add_executable(cpp_template_tests
    tests/test_add.cpp
)

target_link_libraries(cpp_template_tests
    PRIVATE
        project_lib
        Catch2::Catch2WithMain
)

target_include_directories(cpp_template_tests
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/include
)

if (MSVC)
    target_compile_options(cpp_template_tests PRIVATE /W4)
else()
    target_compile_options(cpp_template_tests PRIVATE -Wall -Wextra -Wpedantic)
endif()

include(Catch)
catch_discover_tests(cpp_template_tests)

