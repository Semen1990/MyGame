extends ParallaxBackground

#var speed = 100
#
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#scroll_offset. x -= speed * delta



var speed = 100
var is_scrolling = true  # Флаг для управления прокруткой

func _process(delta):
	if is_scrolling:
		scroll_offset.x -= speed * delta

# Функция для изменения скорости
func set_speed(new_speed):
	speed = new_speed

# Функция для включения/выключения прокрутки
func toggle_scrolling():
	is_scrolling = not is_scrolling
