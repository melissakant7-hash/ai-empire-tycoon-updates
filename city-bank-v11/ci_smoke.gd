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
    for marker in ["Gmail-inspired dark mode", "1f1f1f", "303134", "PDF Document", "Manual file verification", "every supporting PDF"]:
        if marker not in source_text:
            fail("v1.1 source marker missing: %s" % marker)
            return

    var packed = load("res://main.tscn")
    if packed == null:
        fail("Could not load main scene")
        return
    var game = packed.instantiate()
    root.add_child(game)
    for i in range(6):
        await process_frame

    game.selected_mail_id = -1
    game._show_view("Mail")
    await process_frame
    if not find_text(game.content, "CityMail") or not find_text(game.content, "Search mail"):
        fail("Dark Gmail mail shell did not render")
        return

    if game.applications.is_empty():
        fail("No application available for document test")
        return
    var ai = 0
    # Avoid mortgage-policy interference in the final lifecycle assertion.
    game.applications[ai].type = "Personal Loan"
    game.applications[ai].amount = min(float(game.applications[ai].amount), 25000.0)
    game.applications[ai].offer_amount = game.applications[ai].amount
    game.applications[ai].offer_term = 36
    game.applications[ai].offer_rate = game.policy.personal_rate
    var app_id = int(game.applications[ai].id)
    for di in range(game.applications[ai].documents.size()):
        var d = game.applications[ai].documents[di]
        d.status = "Received"
        d.reviewed = false
        d.reviewed_date = ""
        d.stamp = ""
        d.signed = false
        game.applications[ai].documents[di] = d

    var initial_gate = game._approval_document_gate(game.applications[ai])
    if bool(initial_gate.ready):
        fail("Approval gate incorrectly allowed unopened documents")
        return

    # Opening the application form alone must not allow APPROVED before support PDFs are VERIFIED.
    game._open_attachment(app_id, 0)
    await process_frame
    if not bool(game.applications[ai].documents[0].reviewed):
        fail("Opening application form did not mark it reviewed")
        return
    game._set_active_document_stamp("APPROVED")
    if String(game.applications[ai].documents[0].stamp) == "APPROVED":
        fail("Application could be APPROVED before supporting PDFs were VERIFIED")
        return
    game._close_document_modal(false)

    # Every supporting file must be explicitly opened and manually stamped VERIFIED.
    for di in range(1, game.applications[ai].documents.size()):
        game._open_attachment(app_id, di)
        await process_frame
        if not bool(game.applications[ai].documents[di].reviewed):
            fail("Supporting PDF %d was not marked reviewed" % di)
            return
        game._set_active_document_stamp("VERIFIED")
        if String(game.applications[ai].documents[di].stamp) != "VERIFIED":
            fail("Supporting PDF %d did not receive VERIFIED stamp" % di)
            return
        game._close_document_modal(false)

    var support = game._document_review_summary(game.applications[ai])
    if not bool(support.ready) or int(support.verified) != int(support.total):
        fail("Supporting PDF verification gate did not become ready")
        return

    game._open_attachment(app_id, 0)
    await process_frame
    game._apply_signature_points([Vector2(0,0), Vector2(24,12), Vector2(44,5)])
    game._set_active_document_stamp("APPROVED")
    if String(game.applications[ai].documents[0].stamp) != "APPROVED" or not bool(game.applications[ai].documents[0].signed):
        fail("Application form could not be signed and APPROVED after verification")
        return
    var final_gate = game._approval_document_gate(game.applications[ai])
    if not bool(final_gate.ready):
        fail("Final approval gate remained blocked after every PDF was reviewed/stamped")
        return
    game._close_document_modal(false)

    var loans_before = game.loans.size()
    game._approve_application(ai, float(game.applications[ai].offer_amount), float(game.applications[ai].offer_rate), int(game.applications[ai].offer_term))
    await process_frame
    if game.loans.size() != loans_before + 1:
        fail("Fully verified file did not enter Current Loans")
        return

    print("CI_V11_GMAIL_DARK_PDF_VERIFICATION_OK")
    quit(0)
