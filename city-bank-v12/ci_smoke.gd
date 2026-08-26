extends SceneTree

func fail(message: String) -> void:
    push_error(message)
    quit(1)

func collect_scrolls(node: Node, out: Array) -> void:
    if node is ScrollContainer:
        out.append(node)
    for child in node.get_children():
        collect_scrolls(child, out)

func assert_no_horizontal_scroll(node: Node, context: String) -> void:
    var scrolls: Array = []
    collect_scrolls(node, scrolls)
    for s in scrolls:
        if s.horizontal_scroll_mode != ScrollContainer.SCROLL_MODE_DISABLED:
            fail("Horizontal scroll still enabled in %s" % context)
            return

func _initialize() -> void:
    call_deferred("_run")

func _run() -> void:
    var project_file = FileAccess.open("res://project.godot", FileAccess.READ)
    if project_file == null:
        fail("Could not read project.godot")
        return
    var project_text = project_file.get_as_text()
    if 'config/version="1.3.0"' not in project_text:
        fail("v1.3 compatibility version marker missing")
        return
    if 'window/stretch/aspect="expand"' not in project_text:
        fail("16:10 expand stretch setting missing")
        return

    var source = FileAccess.open("res://scripts/main.gd", FileAccess.READ)
    if source == null:
        fail("Could not read main.gd")
        return
    var source_text = source.get_as_text()
    for marker in ["Loan servicing actions", "Create acceleration notice", "Send to borrower", "_refresh_city_services_labels", "SCROLL_MODE_DISABLED"]:
        if marker not in source_text:
            fail("v1.2 source marker missing: %s" % marker)
            return

    var packed = load("res://main.tscn")
    if packed == null:
        fail("Could not load main scene")
        return
    var game = packed.instantiate()
    root.add_child(game)
    for i in range(6):
        await process_frame

    game.bank.deposits += 1234567.0
    game.bank.loan_book += 765432.0
    game.last_month_profit = -12345.0
    game._refresh_topbar()
    if String(game.deposits_label.text) != game._money(game.bank.deposits):
        fail("Total deposits HUD did not refresh from bank state")
        return
    if String(game.active_loans_label.text) != game._money(game.bank.loan_book):
        fail("Active loans HUD did not refresh from bank state")
        return
    if String(game.profit_label.text) != game._money(game.last_month_profit):
        fail("Profit HUD did not refresh from state")
        return
    if String(game.tax_income_label.text) != game._money(game._monthly_tax_revenue_estimate()):
        fail("Tax income HUD did not refresh from live estimate")
        return

    game._show_view("City Services")
    await process_frame
    assert_no_horizontal_scroll(game.content, "City Services")
    game.government.healthcare_subsidy = 100.0
    game._refresh_reactive_view_labels()
    var free_text = String(game.city_services_health_label.text)
    if "FREE" not in free_text or "€0.00" not in free_text:
        fail("Healthcare subsidy text did not react at 100%")
        return
    game.government.healthcare_subsidy = 0.0
    game._refresh_reactive_view_labels()
    var paid_text = String(game.city_services_health_label.text)
    if paid_text == free_text or "€245.00" not in paid_text:
        fail("Healthcare subsidy text did not react at 0%")
        return

    for view_name in ["Current Loans", "Taxes & Budget", "Mail", "Dashboard"]:
        game._show_view(view_name)
        await process_frame
        assert_no_horizontal_scroll(game.content, view_name)

    var test_loan = {
        "id": 90001,
        "borrower": "CI Borrower",
        "subject_id": 0,
        "is_business": false,
        "type": "Personal Loan",
        "original_principal": 25000.0,
        "balance": 18350.0,
        "rate": 8.25,
        "term": 48,
        "months_left": 31,
        "monthly_payment": 620.0,
        "pd": 9.5,
        "collateral": "Vehicle",
        "collateral_value": 12000.0,
        "delinquency": 2,
        "status": "60 days overdue",
        "payment_history": [],
        "restructured": false,
        "collection_strategy": "None"
    }
    game.loans.append(test_loan)
    var li = game.loans.size() - 1
    var availability = game._loan_servicing_action_availability(game.loans[li], "acceleration_notice")
    if not bool(availability.allowed):
        fail("Acceleration should be available at 60 days delinquent")
        return
    game._prepare_loan_servicing_document(li, "acceleration_notice")
    await process_frame
    if game.loans[li].servicing_documents.size() != 1:
        fail("Acceleration document was not created")
        return
    game._open_loan_servicing_document(li, 0)
    await process_frame
    assert_no_horizontal_scroll(game.active_loan_document_modal, "loan PDF viewer")
    if not bool(game.loans[li].servicing_documents[0].opened):
        fail("Opening loan document did not mark it reviewed/opened")
        return

    game._send_active_loan_document()
    if bool(game.loans[li].servicing_documents[0].sent):
        fail("Unsigned servicing document was sent")
        return

    game._apply_loan_signature_points([Vector2(0.05,0.70), Vector2(0.40,0.30), Vector2(0.75,0.60)])
    game._set_active_loan_document_stamp("ISSUED")
    game._send_active_loan_document()
    await process_frame
    if not bool(game.loans[li].servicing_documents[0].sent):
        fail("Signed and ISSUED servicing document did not send")
        return
    if String(game.loans[li].status) != "Accelerated - full balance due":
        fail("Acceleration notice did not make the full balance due")
        return

    game._show_view("Current Loans")
    await process_frame
    assert_no_horizontal_scroll(game.content, "Current Loans after servicing")

    print("CI_V12_RESPONSIVE_SERVICING_OK")
    quit(0)
