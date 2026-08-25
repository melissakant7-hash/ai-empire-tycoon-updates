extends SceneTree

func fail(message: String) -> void:
    push_error(message)
    quit(1)

func has_notification(game, needle: String) -> bool:
    for item in game.game_notifications:
        if needle in String(item.get("title", "")):
            return true
    return false

func has_mail_subject(game, needle: String) -> bool:
    for item in game.mail_messages:
        if needle in String(item.get("subject", "")):
            return true
    return false

func _initialize() -> void:
    call_deferred("_run")

func _run() -> void:
    var packed = load("res://main.tscn")
    if packed == null:
        fail("Could not load main scene")
        return
    var game = packed.instantiate()
    root.add_child(game)
    for i in range(8):
        await process_frame

    if game.city_world == null:
        fail("3D city world missing")
        return
    if game.city_world.facade_materials.is_empty():
        fail("Facade materials were not created")
        return
    for key in game.city_world.facade_materials.keys():
        var mat: StandardMaterial3D = game.city_world.facade_materials[key]
        if mat.albedo_texture != null:
            fail("Facade %s still depends on runtime albedo texture and may render white in Windows export" % String(key))
            return
        var c = mat.albedo_color
        if c.r > 0.92 and c.g > 0.92 and c.b > 0.92:
            fail("Facade %s is effectively white" % String(key))
            return

    if game.applications.size() < 2:
        fail("Need at least two applications for counter-offer test")
        return

    var first_id = int(game.applications[0].id)
    var first_amount = float(game.applications[0].amount)
    var first_rate = float(game.applications[0].offer_rate)
    var first_term = int(game.applications[0].offer_term)
    game._send_offer(0, first_amount * 0.94, first_rate + 0.35, first_term)
    if String(game.applications[0].status) != "Awaiting counter-offer response":
        fail("Counter-offer was not placed into awaiting-response state")
        return
    game.applications[0].offer_accept_chance = 1.0
    game.applications[0].offer_response_due_day = game._serial_day()
    game._resolve_counter_offer(0)
    if not has_notification(game, "ACCEPTED"):
        fail("Accepted counter-offer did not create a notification")
        return
    if not has_mail_subject(game, "accepted your counter-offer"):
        fail("Accepted counter-offer did not create a mail response")
        return
    if int(game.applications[0].id) != first_id or not bool(game.applications[0].offer_accepted):
        fail("Accepted counter-offer did not remain ready for final decision")
        return

    var second_index = 1
    var second_name = String(game.applications[second_index].name)
    var second_amount = float(game.applications[second_index].amount)
    var second_rate = float(game.applications[second_index].offer_rate)
    var second_term = int(game.applications[second_index].offer_term)
    game._send_offer(second_index, second_amount * 0.90, second_rate + 0.6, second_term)
    game.applications[second_index].offer_accept_chance = -1.0
    game.applications[second_index].offer_response_due_day = game._serial_day()
    game._resolve_counter_offer(second_index)
    if not has_notification(game, "DECLINED"):
        fail("Declined counter-offer did not create a notification")
        return
    if not has_mail_subject(game, "declined your counter-offer"):
        fail("Declined counter-offer did not create a mail response")
        return
    for app in game.applications:
        if String(app.name) == second_name:
            fail("Declined counter-offer application was not withdrawn")
            return

    game.loans.append({
        "id": 990001,
        "borrower": "CI Current Loan",
        "subject_id": 1,
        "is_business": false,
        "principal": 25000.0,
        "original_principal": 25000.0,
        "balance": 22000.0,
        "rate": 6.5,
        "term": 48,
        "months_left": 41,
        "monthly_payment": 595.0,
        "pd": 2.2,
        "type": "Personal Loan",
        "purpose": "CI test",
        "collateral": "None",
        "collateral_value": 0.0,
        "status": "Current",
        "delinquency": 0,
        "payment_history": [],
        "restructured": false,
        "collection_strategy": "Standard"
    })
    game._show_view("Current Loans")
    await process_frame
    await process_frame
    if game.current_view != "Current Loans":
        fail("Current Loans system did not open")
        return

    game._show_view("Notifications")
    await process_frame
    if game.current_view != "Notifications":
        fail("Notifications center did not open")
        return

    print("CI_V09_COUNTEROFFER_LOANS_CITY_MATERIALS_OK")
    quit(0)
