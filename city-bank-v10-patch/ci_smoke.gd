extends SceneTree

func fail(message: String) -> void:
    push_error(message)
    quit(1)

func find_text(node: Node, needle: String) -> bool:
    if node is Label and needle in String(node.text):
        return true
    if node is Button and needle in String(node.text):
        return true
    if node is LineEdit and needle in String(node.placeholder_text):
        return true
    for child in node.get_children():
        if find_text(child, needle):
            return true
    return false

func _initialize() -> void:
    call_deferred("_run")

func _run() -> void:
    var source = FileAccess.open("res://scripts/main.gd", FileAccess.READ)
    if source == null:
        fail("Could not read main.gd")
        return
    var source_text = source.get_as_text()
    if "Competitors" in source_text or "_competitor_pressure" in source_text or "_seed_competitors" in source_text:
        fail("Competitor system still exists in v1.0 source")
        return
    if "CityMail" not in source_text or "Taxes & City Budget" not in source_text or "City Services" not in source_text:
        fail("v1.0 Gmail/city administration source markers missing")
        return

    var packed = load("res://main.tscn")
    if packed == null:
        fail("Could not load main scene")
        return
    var game = packed.instantiate()
    root.add_child(game)
    for i in range(7):
        await process_frame

    game._show_view("City Hall")
    await process_frame
    if game.current_view != "City Hall" or not find_text(game.content, "City Hall"):
        fail("City Hall view did not open")
        return

    game._show_view("City Services")
    await process_frame
    if not find_text(game.content, "Healthcare department") or not find_text(game.content, "Police department"):
        fail("City service budget controls missing")
        return
    if not find_text(game.content, "Healthcare subsidy"):
        fail("Healthcare subsidy control missing")
        return

    var spend_100 = game._monthly_city_service_spending_estimate()
    game.government.police_budget = 150.0
    var spend_150 = game._monthly_city_service_spending_estimate()
    if spend_150 <= spend_100:
        fail("Increasing police budget did not increase city spending")
        return
    game.government.police_budget = 100.0

    var tax_18 = game._monthly_tax_revenue_estimate()
    game.policy.income_tax = 30.0
    var tax_30 = game._monthly_tax_revenue_estimate()
    if tax_30 <= tax_18:
        fail("Increasing income tax did not increase estimated tax revenue")
        return
    game.policy.income_tax = 18.0

    for key in ["payroll_tax", "fuel_tax", "hotel_tax", "utility_tax", "vacant_property_tax", "land_value_tax"]:
        if not game.policy.has(key):
            fail("Expanded tax system missing %s" % key)
            return

    game.government.healthcare_subsidy = 100.0
    game._simulate_month()
    if game.city.healthcare_cost_monthly > 0.01:
        fail("100% healthcare subsidy did not make direct healthcare cost free")
        return
    if not game.government.has("monthly_revenue") or game.government.monthly_revenue <= 0.0:
        fail("City government revenue accounting did not run")
        return
    if game.government.monthly_spending <= 0.0:
        fail("City government service spending did not run")
        return

    game._show_view("Taxes & Budget")
    await process_frame
    if not find_text(game.content, "Payroll tax") or not find_text(game.content, "Land value tax"):
        fail("Expanded city taxes are not visible in the UI")
        return

    game.selected_mail_id = -1
    game._show_view("Mail")
    await process_frame
    if not find_text(game.content, "CityMail") or not find_text(game.content, "Compose") or not find_text(game.content, "Search mail"):
        fail("Gmail-style mail shell missing")
        return
    if not find_text(game.content, "Inbox") or not find_text(game.content, "Starred") or not find_text(game.content, "Sent"):
        fail("Gmail-style folders missing")
        return

    var payload = game._save_payload()
    if not payload.has("government"):
        fail("Government state is not saved")
        return

    if game.city_world == null or not (game.city_world is SubViewportContainer):
        fail("3D city world regressed")
        return
    if not (game.city_world.camera is Camera3D):
        fail("3D city camera regressed")
        return
    print("CI_V10_BANK_CITY_GMAIL_OK")
    quit(0)
