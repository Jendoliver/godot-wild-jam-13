class_name DropArea
extends Area2D

enum Kind { LEVEL, MERGER, INVENTORY }
export (Kind) var kind


#func _input_event(viewport, event, shape_idx):
#    if event.type == InputEvent.MOUSE_BUTTON \
#    and event.button_index == BUTTON_LEFT \
#    and event.pressed:
#        print("Clicked")
#        return self