cmake_minimum_required(VERSION 3.20)

project(cpp_template
    VERSION 0.1.0
    DESCRIPTION "Minimal C/C++ project with CMake and clang-format"
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
# Main executable
# ------------------------------
add_executable(${PROJECT_NAME}
    src/main.cpp
)

target_include_directories(${PROJECT_NAME}
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/include
)

# Basic warnings
if (MSVC)
    target_compile_options(${PROJECT_NAME} PRIVATE /W4)
else()
    target_compile_options(${PROJECT_NAME} PRIVATE -Wall -Wextra -Wpedantic)
endif()

# ------------------------------
# clang-format targets
# ------------------------------
file(GLOB_RECURSE ALL_SOURCE_FILES
    ${CMAKE_SOURCE_DIR}/src/*.c
    ${CMAKE_SOURCE_DIR}/src/*.cpp
    ${CMAKE_SOURCE_DIR}/include/*.h
    ${CMAKE_SOURCE_DIR}/include/*.hpp
)

add_custom_target(format
    COMMAND clang-format -i ${ALL_SOURCE_FILES}
    COMMENT "Formatting all source and header files with clang-format"
)

add_custom_target(format-check
    COMMAND clang-format --dry-run --Werror ${ALL_SOURCE_FILES}
    COMMENT "Checking code format with clang-format (no changes made)"
)

# --------------------------------------------------------------------
# HOW TO ADD MORE FILES LATER:
#
# 1) Drop new .c/.cpp files into src/, e.g.:
#       src/math.c
#       src/renderer.cpp
#
# 2) Add them to the executable:
#
#    add_executable(${PROJECT_NAME}
#        src/main.cpp
#        src/math.c
#        src/renderer.cpp
#    )
#
# If you start using headers:
#   - Put public headers in include/project/
#   - Include them as "project/foo.hpp"
#   - They are already on the include path via target_include_directories.
# --------------------------------------------------------------------

