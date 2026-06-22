extends "res://scripts/game_manager.gd"

func console_full_blood():
    print("NEW BLOOD")
    GameManager.get_player().blood_amount = GameManager.get_player().MAX_BLOOD