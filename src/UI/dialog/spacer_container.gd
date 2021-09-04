"""
SpacerContainer
An empty container to create vertical space matching another node.
Purpose is to keep space even when other sibling container is hidden within 
another container node, as if the sibling container was still present.
Assumes other node (most likely sibling container node) has rect_size property.
"""
extends MarginContainer
class_name SpacerContainer

export(NodePath) onready var node = get_node(node)

# Called when the node enters the scene tree for the first time.
func _ready():
	self.rect_min_size.y = node.rect_size.y
