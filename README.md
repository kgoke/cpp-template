# C++ Template Project
A lightweight C/C++ project template using **CMake** for building and **clang-format** for formatting.

This template is intentionally minimal and acts as a clean starting point for new C or C++ projects.

## Project Structure

```graphql
your_project/
├─ CMakeLists.txt        # Root CMake build config
├─ .clang-format         # Code formatting rules
├─ src/
│  └─ main.cpp           # Your main program
└─ include/
   └─ project/           # Your public headers go here
```

## Requirements
You need:
- A C/C++ compiler
  - GCC/Clang on Linux
  - MSVC on Windows
- CMake 3.20+
- clang-format (for formatting)

## Build the Project

From the project root:

```bash
cmake -B build -S .
cmake --build build
```

Run the program:
```bash
./build/your_project
```

## Format the Code

**Format *all* source files in-place**:
```bash
cmake --build build --target format
```

**Check formatting (CI-friendly):**
```bash
cmake --build build --target format-check
```

## Add More Source files

Drop new `.c` or `.cpp` files into the `src/` folder, for example:
```css
src/
├─ main.cpp
├─ math.c
└─ engine.cpp
```

Then update `CMakeLists.txt`:
```cmake
add_executable(${PROJECT_NAME}
  src/main.cpp
  src/math.c
  src/engine.cpp
)
```

## Add headers

Public headers should go into:
```bash
include/project/
```

Include them in code as:
```cpp
#include "project/foo.hpp"
```

No changes to CMake are needed -- the include directory is already configured.
