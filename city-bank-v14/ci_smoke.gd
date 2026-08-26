extends SceneTree

func fail(message: String) -> void:
    push_error(message)
    quit(1)

func _initialize() -> void:
    call_deferred("_run")

func _collect_sliders(node: Node, out: Array) -> void:
    if node is HSlider:
        out.append(node)
    for child in node.get_children():
        _collect_sliders(child, out)

func _run() -> void:
    var project_file = FileAccess.open("res://project.godot", FileAccess.READ)
    if project_file == null or 'config/version="1.4.0"' not in project_file.get_as_text():
        fail("v1.4 version marker missing")
        return

    var packed = load("res://main.tscn")
    if packed == null:
        fail("Could not load main scene")
        return
    var game = packed.instantiate()
    root.add_child(game)
    for i in range(8):
        await process_frame

    var original_population = float(game.city.population)
    var original_gdp = float(game.city.gdp)
    var tax_before = game._monthly_tax_revenue_estimate()
    var spend_before = game._monthly_city_service_spending_estimate()
    game.city.population = original_population * 1.25
    game.city.gdp = original_gdp * 1.25
    var tax_after = game._monthly_tax_revenue_estimate()
    var spend_after = game._monthly_city_service_spending_estimate()
    if tax_after <= tax_before * 1.15:
        fail("Tax revenue does not scale upward with population/economic base")
        return
    if spend_after <= spend_before * 1.15:
        fail("City service costs do not scale upward with population")
        return
    game.city.population = original_population
    game.city.gdp = original_gdp

    for view_name in ["Taxes & Budget", "City Services", "Bank Policies", "Housing"]:
        game._show_view(view_name)
        for i in range(4):
            await process_frame
        var sliders: Array = []
        _collect_sliders(game.content, sliders)
        if sliders.is_empty():
            fail("No sliders found in %s" % view_name)
            return
        for slider in sliders:
            if slider.scrollable:
                fail("Mouse wheel can still modify a slider in %s" % view_name)
                return

    game._show_view("Taxes & Budget")
    for i in range(5):
        await process_frame
    var scroll = game._find_vertical_scroll_container(game.content)
    if scroll == null:
        fail("Taxes scroll container missing")
        return
    var bar = scroll.get_v_scroll_bar()
    var max_scroll = max(0.0, bar.max_value - bar.page)
    if max_scroll < 60.0:
        fail("Taxes page was not vertically scrollable in smoke test")
        return
    var target = int(min(240.0, max_scroll * 0.65))
    scroll.scroll_vertical = target
    for i in range(2):
        await process_frame
    var preserved = int(scroll.scroll_vertical)
    game._refresh_current_view_after_slider(preserved)
    for i in range(5):
        await process_frame
    var scroll_after = game._find_vertical_scroll_container(game.content)
    if scroll_after == null or abs(int(scroll_after.scroll_vertical) - preserved) > 4:
        fail("Slider refresh did not preserve vertical scroll position")
        return

    game.current_view = "Taxes & Budget"
    game.selected_district = "Financial District"
    game.selected_mail_folder = "Starred"
    game.selected_application = 2
    game._autosave()
    var SaveManager = load("res://scripts/core/save_manager.gd")
    var saved = SaveManager.load_json("user://city_bank_autosave.json")
    for key in ["bank", "city", "policy", "government", "applications", "loans", "customers", "businesses", "history", "news", "game_notifications", "mail_messages", "closed_applications", "current_view", "selected_district", "selected_mail_folder", "selected_application", "rng_state"]:
        if not saved.has(key):
            fail("Autosave missing state key: %s" % key)
            return
    if String(saved.current_view) != "Taxes & Budget" or String(saved.selected_district) != "Financial District":
        fail("Autosave did not preserve active game/UI state")
        return

    print("CI_V14_POPULATION_AUTOSAVE_SLIDER_OK")
    quit(0)
