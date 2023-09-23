package main

import "core:fmt"

NeuralNetwork :: struct {
	input:          int,
	hidden:         int,
	output:         int,
	learningRate:   f64,
	hidden_weights: Matrix,
	output_weights: Matrix,
}


newNeuralnet :: proc(i, h, o: int, lr: f64) -> NeuralNetwork {
	nn := NeuralNetwork {
		input          = i,
		hidden         = h,
		output         = o,
		learningRate   = lr,
		hidden_weights = createMatrix(h, i),
		output_weights = createMatrix(o, h),
	}
	return nn
}

main :: proc() {
	nn := newNeuralnet(4, 3, 2, .1)
	fillMatrix(nn.output_weights, 1.0)
	saveMatrix(nn.output_weights, "output_weights.txt")
	m := loadMatrix("./output_weights.txt")
	printMatrix(m)
	f := uniform_dist(23.1, 12490.31)
	fmt.println(f)

	m1 := createMatrix(3, 3)
	fillMatrix(m1, 1.0)
	randomizeMatrix(m1, 16)
	fmt.println("m1")
	printMatrix(m1)
	m2 := createMatrix(3, 3)
	fillMatrix(m1, 1.0)
	randomizeMatrix(m2, 16)
	fmt.println("m2")
	printMatrix(m2)
	m3 := addMatrix(m1, m2)
	fmt.println("m3")
	printMatrix(m3)


	m4 := createMatrix(4, 2)
	fillMatrix(m4, 1)
	randomizeMatrix(m4, 16)
	fmt.println("m4")
	printMatrix(m4)
	m5 := createMatrix(2, 4)
	fillMatrix(m5, 1)
	randomizeMatrix(m5, 16)
	fmt.println("m5")
	printMatrix(m5)
	m6 := dotMatrix(m4, m5)

	fmt.println("m6")
	printMatrix(m6)

	m7 := createMatrix(2, 4)
	fillMatrix(m7, 1)
	randomizeMatrix(m7, 16)
	fmt.println("m7")
	printMatrix(m7)

	m8 := transpose(m7)
	fmt.println("m8")
	printMatrix(m8)

	// matrixFill(m, 1)
	// m := matrix[4, 4]f64{
	// 	1, 2, 3, 4, 
	// 	5, 5, 4, 2, 
	// 	0, 1, 3, 0, 
	// 	0, 1, 4, 1, 
	// }
	//
	// v := [4]f64{1, 5, 4, 3}
	//
	// // treating 'v' as a column vector
	// fmt.println("m * v", m * v)
	//
	// // treating 'v' as a row vector
	// fmt.println("v * m", v * m)
	//
	// // Support with non-square matrices
	// s := matrix[2, 4]f64{ 	// [4][2]f32
	// 	2, 4, 3, 1, 
	// 	7, 8, 6, 5, 
	// }
	//
	// w := [2]f64{1, 2}
	// r: [4]f64 = w * s
	// fmt.println("r", r)
}
