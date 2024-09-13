# Compiler and flags
CC = gcc
DEPS_CFLAGS = -I/usr/local/include
AM_CFLAGS = -I$(INCLUDE_DIR) $(DEPS_CFLAGS) -I/usr/local/include/opus
CPPFLAGS = -I/usr/local/include -I/usr/local/include/opus
CFLAGS = -Iinclude -pedantic -Wall -Wextra -Wno-sign-compare -Wno-parentheses -Wno-long-long -fvisibility=hidden -O2 $(DEPS_CFLAGS)
DEFS = -DHAVE_CONFIG_H -DRANDOM_PREFIX=libopusenc -DOUTSIDE_SPEEX  # Integrated flags here
LDFLAGS = -L/usr/local/lib -lopus -lm  # Added -lm for math library

# Directories
SRC_DIR = src
INCLUDE_DIR = include
OBJ_DIR = obj
LIB_DIR = lib
EXAMPLES_DIR = examples

# Source and object files
SOURCES = $(wildcard $(SRC_DIR)/*.c)
OBJECTS = $(patsubst $(SRC_DIR)/%.c, $(OBJ_DIR)/%.o, $(SOURCES))
LIBRARY = $(LIB_DIR)/libopusenc.a

# Example application
EXAMPLE_SOURCE = $(EXAMPLES_DIR)/opusenc_example.c
EXAMPLE_OBJECT = $(EXAMPLES_DIR)/opusenc_example.o
EXAMPLE_EXEC = $(EXAMPLES_DIR)/opusenc_example

# Create directories if they do not exist
$(shell mkdir -p $(OBJ_DIR) $(LIB_DIR))

# Default target: Build the library and example
all: $(LIBRARY) $(EXAMPLE_EXEC)

# Rule to create the static library
$(LIBRARY): $(OBJECTS)
	ar rcs $@ $^

# Rule to compile object files
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c $(SRC_DIR)/config.h  # Added dependency on config.h
	$(CC) $(CFLAGS) $(CPPFLAGS) $(DEFS) -I$(SRC_DIR) -c $< -o $@

# Rule to build the example application
$(EXAMPLE_EXEC): $(EXAMPLE_SOURCE) $(LIBRARY)
	$(CC) $(CFLAGS) $(CPPFLAGS) $(DEFS) -o $@ $^ $(LDFLAGS)

# Rule to compile example object file
$(EXAMPLE_OBJECT): $(EXAMPLE_SOURCE)
	$(CC) $(CFLAGS) $(CPPFLAGS) $(DEFS) -c $< -o $@

# Rule to clean generated files
clean:
	rm -f $(OBJ_DIR)/*.o $(LIB_DIR)/*.a $(EXAMPLE_EXEC) $(EXAMPLE_OBJECT)

# Phony targets to avoid conflicts with file names
.PHONY: all clean
