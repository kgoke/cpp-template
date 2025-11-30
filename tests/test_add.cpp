#include "project/add.hpp"

#include <catch2/catch_test_macros.hpp>

TEST_CASE("ADD::add adds two integer")
{
    REQUIRE(ADD::add(1, 2) == 3);
    REQUIRE(ADD::add(-1, 1) == 0);
    REQUIRE(ADD::add(10, -5) == 5);
}
