extends SceneTree

func fail(message: String) -> void:
    push_error(message)
    quit(1)

func _initialize() -> void:
    call_deferred("_run")

func _run() -> void:
    var project_file = FileAccess.open("res://project.godot", FileAccess.READ)
    if project_file == null:
        fail("Could not read project.godot")
        return
    if 'config/version="1.3.0"' not in project_file.get_as_text():
        fail("v1.3 version marker missing")
        return

    var source = FileAccess.open("res://scripts/main.gd", FileAccess.READ)
    if source == null:
        fail("Could not read main.gd")
        return
    var source_text = source.get_as_text()
    for marker in ["BANK PROFIT (LAST MO.)", "CITY TAX REVENUE (EST.)", "CITY BALANCE (LAST MO.)", "city_balance_label"]:
        if marker not in source_text:
            fail("v1.3 topbar marker missing: %s" % marker)
            return

    var packed = load("res://main.tscn")
    if packed == null:
        fail("Could not load main scene")
        return
    var game = packed.instantiate()
    root.add_child(game)
    for i in range(6):
        await process_frame

    game.last_month_profit = -8930000.0
    game.government.monthly_balance = 43360000.0
    game._refresh_topbar()
    if String(game.profit_label.text) != game._money(-8930000.0):
        fail("Bank profit KPI did not refresh independently")
        return
    if String(game.city_balance_label.text) != game._money(43360000.0):
        fail("Positive city balance KPI did not refresh")
        return
    if String(game.tax_income_label.text) != game._money(game._monthly_tax_revenue_estimate()):
        fail("City tax revenue KPI is not using the live tax estimate")
        return

    game.government.monthly_balance = -17250000.0
    game.last_month_profit = 6250000.0
    game._refresh_topbar()
    if String(game.city_balance_label.text) != game._money(-17250000.0):
        fail("Negative city balance KPI did not refresh")
        return
    if String(game.profit_label.text) != game._money(6250000.0):
        fail("Positive bank profit KPI did not refresh independently")
        return

    print("CI_V13_BANK_CITY_FINANCE_HUD_OK")
    quit(0)
