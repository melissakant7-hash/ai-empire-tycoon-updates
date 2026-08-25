extends SceneTree

func fail(message: String) -> void:
    push_error(message)
    quit(1)

func collect_scrolls(node: Node, out: Array) -> void:
    if node is ScrollContainer:
        out.append(node)
    for child in node.get_children():
        collect_scrolls(child, out)

func _initialize():
    call_deferred("_run")

func _run():
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
        fail("City world missing")
        return
    if game.city_world.road_xs.size() < 8 or game.city_world.road_ys.size() < 7:
        fail("Expanded road network missing")
        return
    if game.city_world.cars.size() < 110:
        fail("City traffic population not expanded")
        return
    if game.city_world.pedestrians.size() < 400:
        fail("City pedestrian population not expanded")
        return
    if game.city_world.buildings.size() < 200:
        fail("Persistent city buildings not generated")
        return

    var first_car = game.city_world.cars[0].duplicate(true)
    var before_pair = Vector2i(int(first_car.ix), int(first_car.iy))
    for i in range(240):
        game.city_world._process(0.05)
    var moved_car = game.city_world.cars[0]
    if is_equal_approx(float(moved_car.progress), float(first_car.progress)) and Vector2i(int(moved_car.ix), int(moved_car.iy)) == before_pair:
        fail("Road-network vehicles did not advance")
        return

    var old_zoom = float(game.city_world.view_zoom)
    game.city_world._zoom_at(Vector2(800, 450), 1.4)
    if float(game.city_world.view_zoom) <= old_zoom:
        fail("City zoom failed")
        return
    game.city_world._focus_district("Financial District")
    if float(game.city_world.view_zoom) < 1.8:
        fail("District focus camera failed")
        return

    if bool(game.policy.get("auto_loans_enabled", true)):
        fail("Auto Loans regressed to enabled-by-default")
        return

    game._show_view("Loan Desk")
    await process_frame
    await process_frame
    if game.current_view != "Loan Desk" or game.content.get_child_count() < 1:
        fail("Loan Desk did not open")
        return
    if game.applications.is_empty():
        fail("No applications available for underwriting test")
        return
    game.selected_application = 0
    game._show_view("Loan Desk")
    await process_frame
    await process_frame

    var scrolls: Array = []
    collect_scrolls(game.content.get_child(0), scrolls)
    if scrolls.size() < 2:
        fail("Expected underwriting scroll containers were not found")
        return
    for sc in scrolls:
        if sc.horizontal_scroll_mode != ScrollContainer.SCROLL_MODE_DISABLED:
            fail("Loan Desk still has horizontal scrolling enabled")
            return
        if sc.get_h_scroll_bar().visible:
            fail("Loan Desk horizontal scrollbar is visible")
            return

    var widest_overflow = 0.0
    for sc in scrolls:
        if sc.get_child_count() > 0:
            var child = sc.get_child(0)
            widest_overflow = max(widest_overflow, child.get_combined_minimum_size().x - sc.size.x)
    if widest_overflow > 3.0:
        fail("Underwriting content still requires rightward overflow: %.1f px" % widest_overflow)
        return

    game._toggle_view("Mail")
    await process_frame
    await process_frame
    if game.current_view != "Mail":
        fail("Mail regression: failed to open")
        return
    game._toggle_view("Mail")
    await process_frame
    await process_frame
    if game.current_view != "" or game.content.get_child_count() != 0:
        fail("Mail regression: second click failed to close")
        return
    if not game.district_panel.visible:
        fail("District panel was not restored after closing Mail")
        return

    print("CI_V06_RESPONSIVE_LOAN_AND_CITY_WORLD_OK")
    quit(0)
