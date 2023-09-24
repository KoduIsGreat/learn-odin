package main

import "core:bytes"
import "core:fmt"
import "core:os"
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

saveNN :: proc(nn: NeuralNetwork, filename: string) {
	buf: bytes.Buffer
	bytes.buffer_write_string(&buf, fmt.aprintf("%d\n", nn.input))
	bytes.buffer_write_string(&buf, fmt.aprintf("%d\n", nn.output))
	bytes.buffer_write_string(&buf, fmt.aprintf("%d\n", nn.hidden))
	bytes.buffer_write_string(&buf, fmt.aprintf("%f\n", nn.learningRate))
	saveMatrix(nn.hidden_weights, &buf)
	saveMatrix(nn.output_weights, &buf)
	os.write_entire_file(filename, buf.buf[:])
}


main :: proc() {
	// nn := newNeuralnet(4, 3, 2, .1)
	// saveNN(nn, "./data/test")
	// fillMatrix(nn.output_weights, 1.0)
	// saveMatrix(nn.output_weights, "output_weights.txt")
	// m := loadMatrix("./output_weights.txt")
	// printMatrix(m)
	// f := uniform_dist(23.1, 12490.31)
	// fmt.println(f)

	// imgs := csv_to_imgs("./mnist_train.csv", 1)
	// fmt.printf("label: %d\n", imgs[0].label)
	// printMatrix(imgs[0].data)

	matrix_example()

}
