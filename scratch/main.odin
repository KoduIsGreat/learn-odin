package main

import "core:fmt"
import "core:strconv"
append_float_example :: proc() {
	buf: [8]byte
	result := strconv.append_float(buf[:], 3.14159, 'f', 2, 64)
	fmt.println(result, buf)
}
main :: proc() {
	append_float_example()

}
