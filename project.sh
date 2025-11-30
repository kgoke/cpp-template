#!/usr/bin/env bash

set -e

PROJECT_NAME="cpp_template" # must match project() in CMakeLists.txt
BUILD_DIR="build"
CONAN_DIR="conan"
BUILD_TYPE="Debug"
TOOLCHAIN_FILE="$CONAN_DIR/build/$BUILD_TYPE/generators/conan_toolchain.cmake"

# --------------------------------------------------------------------
# Helpers
# --------------------------------------------------------------------

function ensure_not_in_build_dirs() {
  local base
  base=$(basename "$PWD")
  if [[ "$base" == "$BUILD_DIR" || "$base" == "$CONAN_DIR" ]]; then
    echo "Do NOT run this script from inside '$BUILD_DIR/' or '$CONAN_DIR/'."
    echo "Run it from the project root."
    exit 1
  fi
}

function ensure_conan_profile() {
  if ! conan profile list >/dev/null 2>&1; then
    echo "[CONAN] No profiles found, running 'conan profile detect --force'..."
    conan profile detect --force
  fi
}

# --------------------------------------------------------------------
# Core actions
# --------------------------------------------------------------------

function conan_install() {
  ensure_not_in_build_dirs
  ensure_conan_profile
  echo "[CONAN] Installing dependencies into '$CONAN_DIR/'..."
  conan install . \
    --output-folder="$CONAN_DIR" \
    --build=missing \
    -s build_type="$BUILD_TYPE"
}

function configure() {
  ensure_not_in_build_dirs

  if [[ ! -f "$TOOLCHAIN_FILE" ]]; then
    echo "[CONFIGURE] Toolchain file '$TOOLCHAIN_FILE' not found."
    echo "            Run './project.sh conan' or './project.sh setup' first."
    exit 1
  fi

  echo "[CMAKE] Configuring into '$BUILD_DIR/' with toolchain '$TOOLCHAIN_FILE'..."
  cmake -B "$BUILD_DIR" -S . \
    -DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN_FILE" \
    -DCMAKE_BUILD_TYPE="$BUILD_TYPE"
}

function build() {
  ensure_not_in_build_dirs
  echo "[BUILD] Building project in '$BUILD_DIR/'..."
  cmake --build "$BUILD_DIR"
}

function run_exe() {
  ensure_not_in_build_dirs
  local exe="./$BUILD_DIR/$PROJECT_NAME"
  if [[ ! -x "$exe" ]]; then
    echo "[RUN] Executable '$exe' not found or not built. Building first..."
    build
  fi
  echo "[RUN] Running '$exe'..."
  "$exe"
}

function format_all() {
  ensure_not_in_build_dirs
  echo "[FORMAT] Building 'format' and 'format-check' targets..."
  cmake --build "$BUILD_DIR" --target format
  cmake --build "$BUILD_DIR" --target format-check
}

function run_tests() {
  ensure_not_in_build_dirs
  echo "[TEST] Building and running tests via ctest..."
  cmake --build "$BUILD_DIR"
  ctest --test-dir "$BUILD_DIR"
}

function generate_docs() {
  echo "[DOCS] Generating Doxygen documentation..."
  cmake --build "$BUILD_DIR" --target docs
}

function clean() {
  ensure_not_in_build_dirs
  echo "[CLEAN] Removing '$BUILD_DIR/' and '$CONAN_DIR/'..."
  rm -rf "$BUILD_DIR" "$CONAN_DIR"
}

# --------------------------------------------------------------------
# High-level flows
# --------------------------------------------------------------------

function setup() {
  # From clean checkout to fully configured & built
  ensure_not_in_build_dirs
  echo "[SETUP] Full setup: Conan install + CMake configure + build"
  conan_install
  configure
  build
}

function rebuild() {
  ensure_not_in_build_dirs
  echo "[REBUILD] Clean + full setup..."
  clean
  setup
}

function help_menu() {
  cat <<EOF
Usage: ./project.sh <command>

Commands:
  setup        Run Conan install, configure CMake, and build (first-time setup)
  conan        Run only 'conan install' into '$CONAN_DIR/'
  configure    Run CMake configure using Conan toolchain
  build        Build the project
  run          Run the built executable ($PROJECT_NAME)
  format       Run clang-format (format + format-check)
  test         Build and run tests (ctest)
  docs         Generate Doxygen documentation
  clean        Remove '$BUILD_DIR/' and '$CONAN_DIR/'
  rebuild      Clean everything, then run full setup

Examples:
  ./project.sh setup
  ./project.sh build
  ./project.sh run
  ./project.sh format
  ./project.sh test
  ./project.sh clean
EOF
}

# --------------------------------------------------------------------
# Entry point
# --------------------------------------------------------------------

case "${1:-}" in
setup)
  setup
  ;;
conan)
  conan_install
  ;;
configure)
  configure
  ;;
build)
  build
  ;;
run)
  run_exe
  ;;
format)
  format_all
  ;;
test)
  run_tests
  ;;
docs)
  generate_docs
  ;;
clean)
  clean
  ;;
rebuild)
  rebuild
  ;;
*)
  help_menu
  ;;
esac
