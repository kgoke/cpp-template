# C++ Project Template

A modern C/C++ starter template featuring:

- **Conan 2** - dependency management
- **CMake** - build system
- **Catch2** - unit testing
- **clang-format** - code formatting
- **project.sh** - automated script for all workflow tasks

## Quick Start

Clone the project and run:

```bash
./project.sh setup
```

This will:
1. Install Conan and dependencies into `conan/`
2. Configure CMake using the Conan toolchain
3. Build the project

After setup, you can:

**Run the program**

```bash
./project.sh run
```

**Run the tests(Catch2 via ctest)**

```bash
./project.sh test
```

**Format source code**

```bash
./project.sh format
```

**Rebuild everything from scratch**

```bash
./project.sh rebuild
```

## Project Structure

```csharp
cpp-template/
├── CMakeLists.txt          # Main CMake build config
├── conanfile.txt           # Conan dependencies (e.g., Catch2)
├── project.sh              # Automation script (build, test, format, etc.)
├── include/
│   └── project/
│       └── add.hpp         # Example public header
├── src/
│   ├── main.cpp            # Main program
│   └── add.cpp             # Example implementation code
├── tests/
│   └── test_add.cpp        # Catch2 tests
├── conan/                  # Conan-generated files (ignored from git)
└── build/                  # CMake build output (ignored from git)

```

## Requirements

Make sure you have installed:
- A C/C++ compiler (GCC, Clang, or MSVC)
- **CMake 3.20+**
- **Conan 2.x**
- **clang-format**

## Testing

Tests are written with **Catch2** and live in the `test/` directory:

```bash
./project.sh test
```

Uses CTest under the hood.

## Formatting

Format all C/C++ source and header files:

```bash
./project.sh format
```

This runs both:
- `format` - auto-format code
- `format-check` - verifying formatting

## Cleaning

To remove both CMake and Conan output:

```bash
./project.sh clean
```

To clean *and* rebuild everything:

```bash
./project.sh rebuild
```

## Adding More Source Files

Add `.cpp` or `.c` files to:

```bash
src/
```

Then list them inside the `add_library(project_lib ...)` or `add_executable(...)` calls in `CMakeLists.txt`.

Public headers go in:

```bash
include/project/
```

