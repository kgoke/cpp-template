#!/usr/bin/env bash

set -e

BUILD_DIR="build"
EXECUTABLE_NAME="cpp_template" # change this to the project name

function configure() {
  echo "[CONFIGURE] Running CMake configure..."
  cmake -B "$BUILD_DIR" -S .
}

function build() {
  echo "[BUILD] Building project..."
  cmake --build "$BUILD_DIR"
}

function run_exe() {
  echo "[RUN] Running executable..."
  "./$BUILD_DIR/$EXECUTABLE_NAME"
}

function format_all() {
  echo "[FORMAT] Running clang-format..."
  cmake --build "$BUILD_DIR" --target format
  echo "[FORMAT CHECK] Verifying formatting..."
  cmake --build "$BUILD_DIR" --target format-check
}

function clean() {
  echo "[CLEAN] Removing build directory..."
  rm -rf "$BUILD_DIR"
}

function help_menu() {
  echo "Usage: ./project.sh <command>"
  echo ""
  echo "Commands:"
  echo "  configure        Run CMake configuration"
  echo "  build            Build the project"
  echo "  run              Run the compiled executable"
  echo "  format           Format code + check formatting"
  echo "  clean            Remove build/ directory"
  echo ""
  echo "Examples:"
  echo "  ./project.sh configure"
  echo "  ./project.sh build"
  echo "  ./project.sh format"
  echo "  ./project.sh run"
}

case "$1" in
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
clean)
  clean
  ;;
*)
  help_menu
  ;;
esac
