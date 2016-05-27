# A sample Makefile for building Google Test and using it in user
# tests.  Please tweak it to suit your environment and project.  You
# may want to move it to your project's root directory.
#
# SYNOPSIS:
#
#   make [all]  - makes everything.
#   make TARGET - makes the given target.
#   make clean  - removes all files generated by make.

# Please tweak the following variable definitions as needed by your
# project, except GTEST_HEADERS, which you can use in your own targets
# but shouldn't modify.

# Points to the root of Google Test, relative to where this file is.
# Remember to tweak this if you move this file.
GTEST_DIR = ./gtest

# Where to find my code.
USER_DIR = ./src

# Where to find my tests
TEST_DIR = ./tests

# Hide all the .o and .a files here
OBJ_DIR = ./obj

# Flags passed to the preprocessor.
# Set Google Test's header directory as a system directory, such that
# the compiler doesn't generate warnings in Google Test headers.
CPPFLAGS += -isystem $(GTEST_DIR)/include

# Flags passed to the C++ compiler.
CXXFLAGS += -g -std=c++11 -Wall -Wextra -pthread

# Object files
OBJS = Card.o Deck.o Hand.o HandEvaluator.o
TEST_OBJS = card_unittest.o deck_unittest.o hand_unittest.o

# Header files
HEADERS = $(USER_DIR)/Card.h \
	  $(USER_DIR)/Deck.h

# All tests produced by this Makefile.  Remember to add new tests you
# created to the list.
TESTS = card_unittest deck_unittest hand_unittest

# All Google Test headers.  Usually you shouldn't change this
# definition.
GTEST_HEADERS = $(GTEST_DIR)/include/gtest/*.h \
                $(GTEST_DIR)/include/gtest/internal/*.h

# House-keeping build targets.

all : $(OBJS) $(TEST_OBJS) test_suite

test : test_suite

clean :
	rm -f $(TESTS) gtest.a gtest_main.a *.o test_suite

# Builds gtest.a and gtest_main.a.

# Usually you shouldn't tweak such internal variables, indicated by a
# trailing _.
GTEST_SRCS_ = $(GTEST_DIR)/src/*.cc $(GTEST_DIR)/src/*.h $(GTEST_HEADERS)

# For simplicity and to avoid depending on Google Test's
# implementation details, the dependencies specified below are
# conservative and not optimized.  This is fine as Google Test
# compiles fast and for ordinary users its source rarely changes.
gtest-all.o : $(GTEST_SRCS_)
	$(CXX) $(CPPFLAGS) -I$(GTEST_DIR) $(CXXFLAGS) -c \
            $(GTEST_DIR)/src/gtest-all.cc

gtest_main.o : $(GTEST_SRCS_)
	$(CXX) $(CPPFLAGS) -I$(GTEST_DIR) $(CXXFLAGS) -c \
            $(GTEST_DIR)/src/gtest_main.cc

gtest.a : gtest-all.o
	$(AR) $(ARFLAGS) $@ $^

gtest_main.a : gtest-all.o gtest_main.o
	$(AR) $(ARFLAGS) $@ $^

# Build the test suite
test_suite : gtest_main.o gtest_main.a $(TESTS) $(OBJS)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -lpthread gtest_main.o gtest_main.a \
	-o test_suite $(OBJS) $(TEST_OBJS)

# Build Card and tests
Card.o : $(USER_DIR)/Card.cc $(USER_DIR)/Card.h $(GTEST_HEADERS)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $(USER_DIR)/Card.cc

card_unittest.o : Card.o $(TEST_DIR)/card_unittest.cc \
		  $(USER_DIR)/Card.h $(GTEST_HEADERS)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -I $(USER_DIR) \
	-c $(TEST_DIR)/card_unittest.cc

card_unittest : Card.o card_unittest.o gtest_main.a
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -lpthread $^ -o $@

# Build Deck and tests
Deck.o : Card.o $(USER_DIR)/Deck.cc $(USER_DIR)/Deck.h $(GTEST_HEADERS)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $(USER_DIR)/Deck.cc

deck_unittest.o : Deck.o $(TEST_DIR)/deck_unittest.cc \
		  $(USER_DIR)/Deck.h $(GTEST_HEADERS)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -I $(USER_DIR) \
	-c $(TEST_DIR)/deck_unittest.cc

deck_unittest : Deck.o Card.o deck_unittest.o gtest_main.a
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -lpthread $^ -o $@

# Hand
Hand.o : Card.o HandEvaluator.o $(USER_DIR)/Hand.cc $(USER_DIR)/Hand.h \
	$(GTEST_HEADERS)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $(USER_DIR)/Hand.cc

hand_unittest.o : Hand.o $(TEST_DIR)/hand_unittest.cc $(GTEST_HEADERS)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -I $(USER_DIR) \
	-c $(TEST_DIR)/hand_unittest.cc

hand_unittest : Hand.o Card.o HandEvaluator.o hand_unittest.o gtest_main.a
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -lpthread $^ -o $@

# HandEvaluator
HandEvaluator.o : $(USER_DIR)/HandEvaluator.cc $(USER_DIR)/HandEvaluator.h \
	$(GTEST_HEADERS)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $(USER_DIR)/HandEvaluator.cc

