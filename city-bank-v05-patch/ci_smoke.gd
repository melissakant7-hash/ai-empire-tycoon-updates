extends SceneTree

func fail(message: String) -> void:
    push_error(message)
    quit(1)

func has_button_text(node: Node, wanted: String) -> bool:
    if node is Button and String(node.text) == wanted:
        return true
    for child in node.get_children():
        if has_button_text(child, wanted):
            return true
    return false

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
        fail("Persistent native city world missing")
        return
    if bool(game.policy.get("auto_loans_enabled", true)):
        fail("Auto Loans must be disabled by default")
        return
    for application in game.applications:
        if String(application.type) == "Auto Loan":
            fail("Auto Loan generated while product is disabled")
            return

    game._show_view("Mail")
    await process_frame
    await process_frame
    if game.current_view != "Mail":
        fail("Mail did not open")
        return
    if game.content.get_child_count() < 1:
        fail("Mail overlay missing")
        return
    var mail_overlay = game.content.get_child(0)
    if not has_button_text(mail_overlay, "✕"):
        fail("Mail overlay has no close X")
        return
    var mail_rect = game.content.get_global_rect()
    var district_rect = game.district_panel.get_global_rect()
    if mail_rect.end.x > district_rect.position.x + 0.5:
        fail("Mail UI overlaps the district overview")
        return

    game._toggle_view("Mail")
    await process_frame
    await process_frame
    if game.current_view != "" or game.content.get_child_count() != 0:
        fail("Clicking Mail a second time did not close it")
        return
    game._toggle_view("Mail")
    await process_frame
    await process_frame
    if game.current_view != "Mail" or game.content.get_child_count() < 1:
        fail("Mail did not reopen after toggle")
        return

    if not has_button_text(game.district_panel, "✕"):
        fail("District overview has no close X")
        return
    game.district_panel.visible = false
    game._on_district_selected("Financial District")
    await process_frame
    if not game.district_panel.visible:
        fail("Clicking a district did not reopen the overview")
        return

    var old_zoom = float(game.city_world.view_zoom)
    game.city_world._zoom_at(Vector2(500, 400), 1.12)
    if float(game.city_world.view_zoom) <= old_zoom:
        fail("Native city camera zoom failed")
        return
    if game.city_world.cars.size() < 80 or game.city_world.pedestrians.size() < 250:
        fail("Living city traffic/pedestrian population was not expanded")
        return

    game.applications.clear()
    game.mail_messages.clear()
    game.policy["auto_loans_enabled"] = false
    for i in range(80):
        game._generate_application()
    for application in game.applications:
        if String(application.type) == "Auto Loan":
            fail("Disabled Auto Loans still generated applications")
            return

    game._set_auto_loans_enabled(true)
    game.applications.clear()
    game.mail_messages.clear()
    var found_auto = false
    for i in range(320):
        game._generate_application()
        if not game.applications.is_empty() and String(game.applications.back().type) == "Auto Loan":
            found_auto = true
            break
    if not found_auto:
        fail("Enabling Auto Loans did not allow vehicle-finance applications")
        return

    game.applications.clear()
    game.mail_messages.clear()
    var chosen_index = -1
    for i in range(100):
        game._generate_application()
        if not game.applications.is_empty():
            var candidate_index = game.applications.size() - 1
            var candidate_type = String(game.applications[candidate_index].type)
            if candidate_type != "Mortgage" and candidate_type != "Auto Loan":
                chosen_index = candidate_index
                break
    if chosen_index < 0:
        fail("Could not generate deterministic approvable document case")
        return
    game.bank.cash = max(float(game.bank.cash), 1000000000.0)
    var app_id = int(game.applications[chosen_index].id)
    game._select_mail_for_application(app_id)
    game._show_view("Mail")
    await process_frame
    await process_frame
    game._open_attachment(app_id, 0)
    await process_frame
    if game.active_document_modal == null:
        fail("Document modal did not open")
        return
    game._set_active_document_stamp("APPROVED")
    var app_index = game._active_application_index_by_id(app_id)
    if app_index < 0:
        fail("Active application disappeared before signing")
        return
    var app = game.applications[app_index]
    var doc = app.documents[0]
    doc.signed = true
    doc.signature_points = [[0.1,0.6],[0.25,0.4],[0.4,0.65],[0.6,0.35],[0.8,0.55]]
    app.documents[0] = doc
    game.applications[app_index] = app
    game._refresh_active_document()
    await process_frame
    game._finalize_document_decision()
    await process_frame
    if game.loans.size() < 1:
        fail("Signed and APPROVED case did not enter portfolio")
        return

    for i in range(35):
        game._advance_day()
    await process_frame
    print("CI_V05_UI_AUTO_CITY_DOCUMENT_SMOKE_OK")
    quit(0)
