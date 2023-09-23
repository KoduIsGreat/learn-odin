package main

import rand "core:math/rand"
import time "core:time"
import fmt "core:fmt"
import rl "vendor:raylib"

Window :: struct {
	name:          cstring,
	width:         i32,
	height:        i32,
	fps:           i32,
	control_flags: rl.ConfigFlags,
}

Point :: struct {
	x: i32,
	y: i32,
}
User_Input :: struct {
	left_mouse_clicked:   bool,
	mouse_world_position: i32,
	mouse_tile_x:         i32,
	mouse_tile_y:         i32,
}

Player :: struct {
	input:    User_Input,
}


GameState :: struct {
	rooms: [dynamic]rl.Rectangle,
}
Game :: struct {
	state: GameState,
	music: rl.Wave,
}


init_game :: proc() -> Game {
	return(
		Game{
			state = GameState{rooms = generate_random_rooms()},
			music = rl.LoadWave("digital.wav"),
		} 
	)
}

generate_random_rooms :: proc() -> [dynamic]rl.Rectangle {
	rooms: [dynamic]rl.Rectangle
	for len(rooms) < 10 {
		rect := rl.Rectangle {
			x      = rand.float32_range(50, 975.0),
			y      = rand.float32_range(50, 975.0),
			width  = rand.float32_range(200, 300.0),
			height = rand.float32_range(200, 300.0),
		}
		collides := false
		for room in rooms {
			if rl.CheckCollisionRecs(room, rect) {
				collides = true
				break
			}
		}
		if !collides {
			append(&rooms, rect)
		}
	}
	return rooms
}


render_game :: #force_inline proc(game: Game) {
	rl.BeginDrawing()
	rl.ClearBackground(rl.DARKGRAY)
	for room in game.state.rooms {
		rl.DrawRectangleRec(room, rl.LIGHTGRAY)
	}

	rl.DrawFPS(12, 12)
	rl.EndDrawing()
}

tick :: proc(game: Game) {
	// time.sleep(1)
}

process_input :: proc(game: ^Game) {
	if rl.IsKeyPressed(.SPACE) {
		reset_state(game)
	}
	if rl.IsKeyPressed(.FIVE) {
		fmt.println("hello")
	}
}
reset_state :: proc(game: ^Game) {
	game.state = GameState {
		rooms = generate_random_rooms(),
	}
}

main :: proc() {
	window := Window{
		"Room generator",
		1024,
		1024,
		60,
		rl.ConfigFlags{.WINDOW_RESIZABLE},
	}

	game := init_game()
	rl.InitWindow(window.width, window.height, window.name)
	rl.SetWindowState(window.control_flags)
	rl.SetTargetFPS(window.fps)
	for !rl.WindowShouldClose() {
		process_input(&game)
		tick(game)
		render_game(game)
	}
}
