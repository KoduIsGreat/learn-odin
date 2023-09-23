package main

import "core:bytes"
import "core:fmt"
import "core:math"
import "core:math/rand"
import "core:os"
import "core:strconv"
import "core:strings"

Matrix :: struct {
	rows: int,
	cols: int,
	data: []f64,
}

checkDims :: proc(m1: Matrix, m2: Matrix) {
	if m1.rows != m2.rows || m1.cols != m2.cols {
		panic("Matrix dimensions must match")
	}
}
createMatrix :: proc(rows: int, cols: int) -> Matrix {
	return Matrix{rows = rows, cols = cols, data = make([]f64, rows * cols)}
}
fillMatrix :: proc(m: Matrix, val: f64) {
	for i := 0; i < m.rows; i = i + 1 {
		for j := 0; j < m.cols; j = j + 1 {
			m.data[i * m.cols + j] = val
		}
	}
}
printMatrix :: proc(m: Matrix) {
	for i := 0; i < m.rows; i = i + 1 {
		for j := 0; j < m.cols; j = j + 1 {
			fmt.print(m.data[i * m.cols + j])
			fmt.print(" ")
		}
		fmt.println("")
	}
}
copyMatrix :: proc(m: Matrix) -> Matrix {

	copy := createMatrix(m.rows, m.cols)

	for i := 0; i < m.rows; i = i + 1 {
		for j := 0; j < m.cols; j = j + 1 {
			copy.data[i * m.cols + j] = m.data[i * m.cols + j]
		}
	}
	return copy
}

saveMatrix :: proc(m: Matrix, filename: string) {
	buf: bytes.Buffer
	bytes.buffer_write_string(&buf, fmt.aprintf("%d %d\n", m.rows, m.cols))
	for i := 0; i < m.rows; i = i + 1 {
		for j := 0; j < m.cols; j = j + 1 {
			bytes.buffer_write_string(
				&buf,
				fmt.aprintf("%f", m.data[i * m.cols + j]),
			)
			if j + 1 < m.cols {
				bytes.buffer_write_string(&buf, " ")
			}
		}
		bytes.buffer_write_string(&buf, "\n")
	}
	os.write_entire_file(filename, buf.buf[:])
}

loadMatrix :: proc(filepath: string) -> Matrix {
	data, ok := os.read_entire_file(filepath, context.allocator)
	if !ok {
		// could not read file
		os.exit(1)
	}
	defer delete(data, context.allocator)

	it := string(data)
	m: Matrix
	rc: int
	for line in strings.split_lines_iterator(&it) {
		// process line
		parts := strings.split(line, " ")
		if len(parts) == 2 {
			row := strconv.atoi(parts[0])
			col := strconv.atoi(parts[1])
			m = createMatrix(row, col)
		} else if len(parts) == m.cols {
			for i := 0; i < m.cols; i = i + 1 {
				val := strconv.atof(parts[i])
				m.data[rc * m.cols + i] = val
			}
		} else {
			fmt.print(parts)
			panic("boom bitch")
		}
	}
	return m
}

uniform_dist :: proc(low, high: f64) -> f64 {
	return low + (high - low) * rand.float64()
}

randomizeMatrix :: proc(m: Matrix, n: f64) {
	min := -1 / math.sqrt_f64(n)
	max := 1 / math.sqrt_f64(n)
	for i := 0; i < m.rows; i = i + 1 {
		for j := 0; j < m.cols; j = j + 1 {
			m.data[i * m.cols + j] = uniform_dist(min, max)
		}
	}
}

addMatrix :: proc(m1, m2: Matrix) -> Matrix {
	checkDims(m1, m2)
	m := createMatrix(m1.rows, m1.cols)
	for i := 0; i < m1.rows; i = i + 1 {
		for j := 0; j < m1.cols; j = j + 1 {
			m.data[i * m1.cols + j] =
				m1.data[i * m1.cols + j] + m2.data[i * m1.cols + j]
		}
	}
	return m
}


subMatrix :: proc(m1, m2: Matrix) -> Matrix {
	checkDims(m1, m2)
	m := createMatrix(m1.rows, m1.cols)
	for i := 0; i < m1.rows; i = i + 1 {
		for j := 0; j < m1.cols; j = j + 1 {
			m.data[i * m1.cols + j] =
				m1.data[i * m1.cols + j] - m2.data[i * m1.cols + j]
		}
	}
	return m
}

mulMatrix :: proc(m1, m2: Matrix) -> Matrix {
	checkDims(m1, m2)
	m := createMatrix(m1.rows, m1.cols)
	for i := 0; i < m1.rows; i = i + 1 {
		for j := 0; j < m1.cols; j = j + 1 {
			m.data[i * m1.cols + j] =
				m1.data[i * m1.cols + j] * m2.data[i * m1.cols + j]
		}
	}
	return m
}

dotMatrix :: proc(m1, m2: Matrix) -> Matrix {
	if m1.rows == m2.cols {
		m := createMatrix(m1.rows, m2.cols)

		for i := 0; i < m1.rows; i = i + 1 {
			for j := 0; j < m2.cols; j = j + 1 {
				sum := 0.0
				for k := 0; k < m2.rows; k = k + 1 {
					sum =
						sum +
						m1.data[i * m1.cols + k] * m2.data[k * m2.cols + j]
				}
				m.data[i * m1.cols + j] = sum
			}
		}
		return m
	} else {
		panic("boom")
	}
}

scaleMatrix :: proc(m: Matrix, sf: f64) -> Matrix {
	cm1 := copyMatrix(m)

	for i := 0; i < m.rows; i = i + 1 {
		for j := 0; j < m.cols; j = j + 1 {
			cm1.data[i * m.cols + j] = m.data[i * m.cols + j] * sf
		}
	}
	return cm1
}

addScalarMatrix :: proc(m: Matrix, sf: f64) -> Matrix {
	cm1 := copyMatrix(m)

	for i := 0; i < m.rows; i = i + 1 {
		for j := 0; j < m.cols; j = j + 1 {
			cm1.data[i * m.cols + j] = m.data[i * m.cols + j] + sf
		}
	}
	return cm1
}

transpose :: proc(m: Matrix) -> Matrix {
	tm := createMatrix(m.cols, m.rows)

	for i := 0; i < m.rows; i = i + 1 {
		for j := 0; j < m.cols; j = j + 1 {
			tm.data[j * m.rows + i] = m.data[i * m.cols + j]
		}
	}
	return tm
}
