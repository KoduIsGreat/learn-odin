package main

import fmt "core:fmt"


main :: proc() {
	x: [dynamic][dynamic]int

	y: [dynamic]int
	append(&y, 1, 2, 3, 4, 5)
	append(&x, y)
	for i := 0; i < len(x); i = i + 1 {
		for j := 0; j < len(x[i]); j = j + 1 {
			fmt.println(x[i][j])
		}
	}
}
