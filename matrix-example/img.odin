package main

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

Img :: struct {
	label: int,
	data:  Matrix,
}

csv_to_imgs :: proc(filename: string, numImg: int) -> []Img {

	imgs := make([]Img, numImg)

	data, ok := os.read_entire_file(filename, context.allocator)
	if !ok {
		// could not read file
		os.exit(1)
	}
	defer delete(data, context.allocator)

	it := string(data)
	lines := strings.split_lines(it)
	for i := 0; i < numImg; i = i + 1 {
		line := lines[i]
		parts := strings.split(line, ",")
		if len(parts) != 785 {
			// invalid line
			fmt.printf("invalid line len(parts)=%d\n", len(parts))
			os.exit(1)
		}
		imgs[i].label = strconv.atoi(parts[0])
		imgs[i].data = createMatrix(28, 28)
		for j in 1 ..= len(parts) - 1 {
			val := strconv.atof(parts[j - 1]) / 256.0
			imgs[i].data.data[j - 1] = val
		}
	}
	return imgs

}
