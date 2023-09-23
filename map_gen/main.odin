package main

import "core:fmt"
import "core:math/rand"


Map :: struct {
	Tiles: [20][30]int,
}

Node :: struct {
	X:      int,
	Y:      int,
	Width:  int,
	Height: int,
	Left:   ^Node,
	Right:  ^Node,
}


splitNode :: proc(node: ^Node, depth: int) {
	if depth <= 0 {
		return
	}
	fmt.println(depth, node.X, node.Y, node.Width, node.Height)

	horzSplit := rand.float32()
	horzSplitVal := node.Height > 0 ? rand.int_max(node.Height, nil) : 0
	vertSplitVal := node.Width > 0 ? rand.int_max(node.Width, nil) : 0
	fmt.println(horzSplit, horzSplitVal, vertSplitVal)
	if horzSplit > 0.5 {
		splitPos := node.Y + horzSplitVal
		node.Left = node
		node.Left.Width = node.Width
		node.Left.Height = splitPos - node.Y
		node.Right =
		&Node{
			X = node.X,
			Y = splitPos + 1,
			Width = node.Width,
			Height = node.Y + node.Height - splitPos - 1,
		}
	} else {
		splitPos := node.X + vertSplitVal
		node.Left = node
		node.Left.Width = splitPos - node.X
		node.Left.Height = node.Height
		node.Right =
		&Node{
			X = splitPos + 1,
			Y = node.Y,
			Width = node.X + node.Width - splitPos - 1,
			Height = node.Height,
		}
	}
	splitNode(node.Left, depth - 1)
	splitNode(node.Right, depth - 1)

}

createMap :: proc(node: ^Node, m: ^Map) {
	if node == nil {
		return
	}

	for i := 0; i < node.X + node.Width; i += 1 {
		for j := 0; j < node.Y + node.Height; j += 1 {
			fmt.println(i, j)
			m.Tiles[i][j] = 1
		}
	}
	createMap(node.Left, m)
	createMap(node.Right, m)
}

generateMap :: proc(m: ^Map, depth: int) {
	root := &Node{X = 0, Y = 0, Width = 30, Height = 30}
	splitNode(root, depth)
	createMap(root, m)
}

renderMap :: proc(m: ^Map) {
	w := len(m.Tiles)
	h := len(m.Tiles[0])
	fmt.println(w, h)
	for i := 0; i < w; i += 1 {
		for j := 0; j < h; j += 1 {
			if m.Tiles[i][j] == 0 {
				fmt.print(".")
			} else {
				fmt.print("#")
			}
		}
		fmt.print("\n")
	}
}

main :: proc() {
	m := Map{}
	generateMap(&m, 1)
	fmt.println("beginning loop")
	renderMap(&m)
}
