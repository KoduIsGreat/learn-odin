package main

import "core:fmt"
import "core:os"
import "core:strings"

read_file_by_lines_in_whole :: proc(filepath: string) {
	data, ok := os.read_entire_file(filepath, context.allocator)
	if !ok {
		// could not read file
		return
	}
	defer delete(data, context.allocator)

	it := string(data)
	for line in strings.split_lines_iterator(&it) {
		// process line
		fmt.println(line)
	}
}


main :: proc() {
	read_file_by_lines_in_whole("./hello.txt")
}
