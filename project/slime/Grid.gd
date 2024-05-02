extends Node2D

var cell_size = 40
var draw_grid = true  # Toggle for drawing the grid
var grid = []
var grid_size = Vector2(30, 30)
var decay_rate = 0.72
var diffusion_rate = 0.7
var default_font = preload("res://assets/Montserrat-Regular.ttf")

func _ready():
	initialize_grid()
	set_process(true)

func initialize_grid():
	for y in range(grid_size.y):
		grid.append([])
		for x in range(grid_size.x):
			grid[y].append({
				'food': false,
				'food_amount': 500, 
				'pheromone': 0,
				'slime_amount': 0,
				'slime_life': null,
			})

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		toggle_food(event.position)

func toggle_food(mouse_position):
	var cell = get_cell_from_position(mouse_position)
	var isValidX = cell.x >= 0 and cell.x < grid_size.x
	var isValidY = cell.y >= 0 and cell.y < grid_size.y

	if isValidX and isValidY:
		grid[cell.y][cell.x]['food'] = !grid[cell.y][cell.x]['food']
		if grid[cell.y][cell.x]['food']:
			grid[cell.y][cell.x]['pheromone'] = 1
		queue_redraw()

func _process(delta):
	update_grid(delta)

func update_grid(delta):
	var new_grid = deepcopy(grid)
	
	for y in range(grid_size.y):
		for x in range(grid_size.x):
			if new_grid[y][x]['food']:
				new_grid[y][x]['food_amount'] -= 1
				if new_grid[y][x]['food_amount'] <= 0:
					new_grid[y][x]['food'] = false
			else: 
				var pheromone_sum = 0
				var neighbors = get_neighbors(x, y)
				for neighbor in neighbors:
					pheromone_sum += grid[neighbor.y][neighbor.x]['pheromone']
				var average_pheromone = pheromone_sum / neighbors.size()
				new_grid[y][x]['pheromone'] = grid[y][x]['pheromone'] * (1 - decay_rate) + average_pheromone * diffusion_rate
				
	grid = new_grid
	queue_redraw()

func get_neighbors(x, y):
	var neighbors = []
	for i in range(-1, 2):
		for j in range(-1, 2):
			var nx = x + i
			var ny = y + j
			if nx >= 0 and nx < grid_size.x and ny >= 0 and ny < grid_size.y and !(i == 0 and j == 0):
				neighbors.append(Vector2(nx, ny))
	return neighbors

func deepcopy(arr):
	var new_arr = []
	for row in arr:
		new_arr.append(row.duplicate(true))
	return new_arr

func get_cell_from_position(position):
	return Vector2(int(position.x / cell_size), int(position.y / cell_size))

func _draw():
	if draw_grid:
		draw_grid_lines()

func draw_grid_lines():
	var color = Color(0.8, 0.8, 0.8, 0.5)  # Color for the grid lines
	var food_color = Color(0, 1, 0, 1)  # Green color for food pellets
	var pheromone_color = Color(1, 0, 0, 0.8)  # Semi-transparent red for pheromones

	for y in range(grid_size.y):
		for x in range(grid_size.x):
			var cell_position = Vector2(x * cell_size, y * cell_size)
			var pheromone_level = clamp(grid[y][x]['pheromone'], 0, 1)
			draw_rect(Rect2(cell_position, Vector2(cell_size, cell_size)), color, false)
			if grid[y][x]['food']:
				draw_rect(Rect2(cell_position, Vector2(cell_size, cell_size)), food_color, true)
			elif pheromone_level > 0:
				draw_rect(Rect2(cell_position, Vector2(cell_size, cell_size)), pheromone_color * pheromone_level, true)
				var pheromone_text = "%.2f" % pheromone_level
				draw_string(default_font, cell_position + Vector2(2, cell_size / 2), pheromone_text, HORIZONTAL_ALIGNMENT_CENTER, -1, 12, Color.WHITE)
