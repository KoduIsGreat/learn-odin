package main

import "core:fmt"
import math "core:math"
import rl "vendor:raylib"

Window :: struct {
	name:          cstring,
	width:         i32,
	height:        i32,
	fps:           i32,
	control_flags: rl.ConfigFlags,
}

User_Input :: struct {
	left_mouse_clicked:   bool,
	right_mouse_clicked:  bool,
	toggle_pause:         bool,
	space_pressed:        bool,
	mouse_world_position: i32,
	mouse_tile_x:         i32,
	mouse_tile_y:         i32,
}

Game :: struct {
	partical_groups: [dynamic][dynamic]Partical,
}


Partical :: struct {
	x:     f32,
	y:     f32,
	vx:    f32,
	vy:    f32,
	mxd:   f32,
	color: rl.Color,
}
create :: proc(color: rl.Color, number: int, mxd: int, g: ^Game) {
	group: [dynamic]Partical
	for i := 0; i < number; i = i + 1 {
		p := Partical {
			x     = f32(rl.GetRandomValue(25, 999)),
			y     = f32(rl.GetRandomValue(25, 999)),
			mxd   = f32(mxd),
			vx    = 0,
			vy    = 0,
			color = color,
		}
		append(&group, p)
	}

	append(&g.partical_groups, group)
}

render_partical :: proc(p: ^Partical) {
	rl.DrawCircle(i32(p.x), i32(p.y), 2, p.color)
}


init_game :: proc(g: ^Game) {
	create(rl.RED, 200, 80, g)
	create(rl.GREEN, 300, 120, g)
	create(rl.BLUE, 200, 70, g)
	create(rl.WHITE, 300, 300, g)
	create(rl.YELLOW, 400, 300, g)
}
tick :: proc(g: ^Game) {
	red := g.partical_groups[0]
	green := g.partical_groups[1]
	blue := g.partical_groups[2]
	white := g.partical_groups[3]
	yellow := g.partical_groups[4]
	//the jelly boy
	rule(white, white, -0.7)
	rule(white, red, -0.17)
	rule(white, blue, 0.34)
	rule(white, yellow, 0.2)
	rule(red, red, -0.1)
	rule(red, white, -0.34)
	rule(red, yellow, -0.2)
	rule(red, green, -0.2)
	rule(blue, blue, 0.15)
	rule(blue, white, -0.2)
	rule(blue, green, -0.29)
	rule(blue, yellow, -0.27)
	rule(green, green, -0.32)
	rule(green, red, 0.01)
	rule(green, blue, -1.34)
	rule(green, white, -0.01)
	rule(green, yellow, -0.2)

	rule(yellow, yellow, 0.13)
	rule(yellow, white, 0.1)
	rule(yellow, green, -0.2)
	rule(yellow, blue, -0.5)
	// jellyboy end
}

render_game :: #force_inline proc(g: ^Game) {
	rl.BeginDrawing()
	rl.ClearBackground(rl.BLACK)
	for i := 0; i < len(g.partical_groups); i = i + 1 {
		for j := 0; j < len(g.partical_groups[i]); j = j + 1 {
			render_partical(&g.partical_groups[i][j])
		}
	}
	rl.DrawFPS(12, 12)
	rl.EndDrawing()
}
rule :: proc(ap: [dynamic]Partical, bp: [dynamic]Partical, g: f32) {
	for i := 0; i < len(ap); i = i + 1 {
		fx: f32
		fy: f32
		for j := 0; j < len(bp); j = j + 1 {
			dx := ap[i].x - bp[j].x
			dy := ap[i].y - bp[j].y
			d := math.sqrt(dx * dx + dy * dy)
			if d > 0 && d < bp[j].mxd {
				f := g * 1 / d
				fx = fx + (f * dx)
				fy = fy + (f * dy)
			}
		}

		ap[i].vx = (ap[i].vx + fx) * .5
		ap[i].vy = (ap[i].vy + fy) * .5
		ap[i].x = ap[i].x + ap[i].vx
		ap[i].y = ap[i].y + ap[i].vy
		if ap[i].x <= 25 || ap[i].x >= 1024 {
			ap[i].vx = ap[i].vx * -1
		}
		if ap[i].y <= 25 || ap[i].y >= 1024 {
			ap[i].vy = ap[i].vy * -1
		}
	}
}

process_input :: proc(g: ^Game) {
	if rl.IsKeyPressed(.SPACE) {
		fmt.println("space pressed")
		g.partical_groups = [dynamic][dynamic]Partical{}
		init_game(g)
	}
}
main :: proc() {
	window := Window{
		"Life simulator",
		1024,
		1024,
		60,
		rl.ConfigFlags{.WINDOW_RESIZABLE},
	}
	game := Game{}
	init_game(&game)
	rl.InitWindow(window.width, window.height, window.name)
	rl.SetWindowState(window.control_flags)
	rl.SetTargetFPS(window.fps)
	for !rl.WindowShouldClose() {
		process_input(&game)
		tick(&game)
		render_game(&game)
	}
}
