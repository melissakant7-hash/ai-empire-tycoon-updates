extends SceneTree

func fail(message: String) -> void:
    push_error(message)
    quit(1)

func count_type(node: Node, class_name_text: String) -> int:
    var count = 1 if node.get_class() == class_name_text else 0
    for child in node.get_children():
        count += count_type(child, class_name_text)
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
    await process_frame
    await process_frame
    await process_frame

    if game.city_world == null:
        fail("Native 3D city world missing")
        return
    if not (game.city_world is SubViewportContainer):
        fail("City world is not a real SubViewportContainer 3D layer")
        return
    if game.city_world.viewport_3d == null or game.city_world.world_root == null:
        fail("3D viewport/world root was not created")
        return
    if not (game.city_world.camera is Camera3D):
        fail("Perspective Camera3D missing")
        return
    if game.city_world.world_root.name != "Native3DCityWorld":
        fail("Expected native 3D city root was not instantiated")
        return

    var mesh_count = count_type(game.city_world.world_root, "MeshInstance3D")
    if mesh_count < 700:
        fail("3D city is too sparse: only %d MeshInstance3D nodes" % mesh_count)
        return
    if game.city_world.buildings.size() < 200:
        fail("Expected 200+ persistent 3D buildings")
        return
    if game.city_world.cars.size() < 130:
        fail("Expected 130+ moving 3D vehicles")
        return
    if game.city_world.pedestrians.size() < 450:
        fail("Expected 450+ 3D citizens")
        return

    var first_car = game.city_world.cars[0]
    var car_node: Node3D = first_car.node
    var start_car_pos = car_node.position
    for i in range(8):
        game.city_world._process(0.20)
    if car_node.position.distance_to(start_car_pos) < 0.02:
        fail("3D vehicle did not move on the road graph")
        return

    var first_person = game.city_world.pedestrians[0]
    var person_node: Node3D = first_person.node
    var start_person_pos = person_node.position
    for i in range(12):
        game.city_world._process(0.20)
    if person_node.position.distance_to(start_person_pos) < 0.01:
        fail("3D citizen did not move along sidewalk route")
        return

    var old_distance = float(game.city_world.camera_distance)
    game.city_world._zoom_at(Vector2(600, 380), 1.15)
    if float(game.city_world.camera_distance) >= old_distance:
        fail("3D camera zoom failed")
        return
    var old_target = game.city_world.camera_target
    game.city_world._focus_district("Financial District")
    if game.city_world.camera_target.distance_to(old_target) < 0.5:
        fail("District focus did not move the 3D camera")
        return

    game.city_world.selected_district = "Financial District"
    game.city_world._update_district_highlight()
    await process_frame
    if game.city_world.district_highlight_root.get_child_count() < 4:
        fail("3D district selection border missing")
        return

    game._show_view("Loan Desk")
    await process_frame
    await process_frame
    if game.current_view != "Loan Desk":
        fail("Bank management overlay no longer works over 3D city")
        return
    game._toggle_view("Loan Desk")
    await process_frame
    if game.current_view != "":
        fail("Management overlay did not close over 3D city")
        return

    for i in range(35):
        game._advance_day()
    await process_frame
    print("CI_V07_NATIVE_3D_CITY_WORLD_OK")
    quit(0)
