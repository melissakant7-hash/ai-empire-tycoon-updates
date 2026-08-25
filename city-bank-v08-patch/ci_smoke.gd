extends SceneTree

func fail(message: String) -> void:
    push_error(message)
    quit(1)

func count_type(node: Node, class_name_text: String) -> int:
    var count = 1 if node.get_class() == class_name_text else 0
    for child in node.get_children():
        count += count_type(child, class_name_text)
    return count

func count_named(node: Node, needle: String) -> int:
    var count = 1 if needle in String(node.name) else 0
    for child in node.get_children():
        count += count_named(child, needle)
    return count

func _initialize() -> void:
    call_deferred("_run")

func _run() -> void:
    var packed = load("res://main.tscn")
    if packed == null:
        fail("Could not load main scene")
        return
    var game = packed.instantiate()
    root.add_child(game)
    for i in range(6):
        await process_frame

    if game.city_world == null or not (game.city_world is SubViewportContainer):
        fail("v0.8 3D city layer missing")
        return
    if not (game.city_world.camera is Camera3D):
        fail("Camera3D missing")
        return
    if game.city_world.buildings.size() < 300:
        fail("Visual overhaul expected at least 300 building records, got %d" % game.city_world.buildings.size())
        return
    if game.city_world.cars.size() < 180:
        fail("Expected at least 180 vehicles")
        return
    if game.city_world.pedestrians.size() < 650:
        fail("Expected at least 650 citizens")
        return
    if game.city_world.boats.size() < 8:
        fail("Expected moving river boats")
        return
    if game.city_world.facade_materials.size() < 10:
        fail("Procedural facade material library was not generated")
        return
    if game.city_world.night_lights.size() < 10:
        fail("Night street lighting system missing")
        return

    var mesh_count = count_type(game.city_world.world_root, "MeshInstance3D")
    if mesh_count < 2400:
        fail("v0.8 city is too visually sparse: only %d MeshInstance3D nodes" % mesh_count)
        return
    if count_named(game.city_world.world_root, "Wheel") < 500:
        fail("Detailed vehicle wheels were not created")
        return
    if count_named(game.city_world.world_root, "LeftArm") < 600:
        fail("Detailed citizen limbs were not created")
        return
    if count_named(game.city_world.world_root, "StreetLight") < 20:
        fail("Street lighting props were not created")
        return
    if count_named(game.city_world.world_root, "ShopAwning") < 15:
        fail("Retail facade details are missing")
        return
    if count_named(game.city_world.world_root, "Balcony") < 20:
        fail("Residential facade detail is too sparse")
        return
    if count_named(game.city_world.world_root, "CityHall") < 1 or count_named(game.city_world.world_root, "RiversideHotel") < 1:
        fail("New landmark buildings are missing")
        return

    var first_car = game.city_world.cars[0]
    var car_node: Node3D = first_car.node
    var car_start = car_node.position
    var first_person = game.city_world.pedestrians[0]
    var person_node: Node3D = first_person.node
    var person_start = person_node.position
    var left_arm: MeshInstance3D = first_person.left_arm
    var arm_start = left_arm.rotation_degrees.x
    var first_boat = game.city_world.boats[0]
    var boat_node: Node3D = first_boat.node
    var boat_start = boat_node.position
    for i in range(18):
        game.city_world._process(0.20)
    if car_node.position.distance_to(car_start) < 0.05:
        fail("Detailed vehicle did not move")
        return
    if person_node.position.distance_to(person_start) < 0.02:
        fail("Detailed citizen did not move")
        return
    if abs(left_arm.rotation_degrees.x - arm_start) < 0.5:
        fail("Citizen walk animation did not animate limbs")
        return
    if boat_node.position.distance_to(boat_start) < 0.05:
        fail("River boat did not move")
        return

    game.city_world.world_time = 0.86
    game.city_world._update_day_night()
    var lit = false
    for lamp in game.city_world.night_lights:
        if is_instance_valid(lamp) and lamp.light_energy > 0.1:
            lit = true
            break
    if not lit:
        fail("Night lighting did not activate")
        return

    game._show_view("Loan Desk")
    await process_frame
    await process_frame
    if game.current_view != "Loan Desk":
        fail("Banking overlay broke after visual overhaul")
        return
    game._toggle_view("Loan Desk")
    await process_frame
    if game.current_view != "":
        fail("Banking overlay could not close")
        return

    for i in range(35):
        game._advance_day()
    await process_frame
    print("CI_V08_CITY_VISUAL_OVERHAUL_OK")
    quit(0)
