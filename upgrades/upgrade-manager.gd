class_name UpgradeManager
extends Node

@export var tutorial: Node
@export var alien: Alien

@export var isotope_scene: PackedScene

var upgrades: Array[Upgrade] = []
var upgrades_granted: int = 0


func _ready() -> void:
    upgrades.append(AlienSpeedChange.new(alien))


func grant_upgrade() -> String:
    upgrades_granted += 1
    if upgrades_granted == 1:
        # destroy tutorial, spawn isotope
        tutorial.queue_free()
        tutorial = null
        var isotope: Isotope = isotope_scene.instantiate()
        isotope.global_position = Vector2(0.0, -790.0)
        get_parent().add_child(isotope)
        activate_terminal()
        activate_terminal()
        activate_terminal()
        return "Here goes!"
    var upgrade: Upgrade = upgrades.pick_random()
    activate_terminal()
    ScoreTicker.add_score(upgrade.trigger())
    return upgrade.message


func activate_terminal() -> void:
    while true:
        var terminal: Terminal = get_tree().get_nodes_in_group(&"Terminal").pick_random()
        if not terminal.isActive:
            terminal.activate_terminal()
            break


class Upgrade:
    var message: String = "placeholder"

    func trigger() -> int:
        return 0


class AlienSpeedChange:
    extends Upgrade
    var alien: Alien

    func _init(a: Alien) -> void:
        alien = a

    func trigger() -> int:
        var mult := randf_range(0.8, 1.2)
        alien.move_multiplier *= mult
        message = "x%.3f Movement Speed" % mult
        return roundi(100 / mult)
