enum MainMenuCommand {
  person,
  vehicle,
  parkingSpace,
  parking,
  quit,
  invalid;

  static MainMenuCommand fromString(String s) => switch (s) {
        "1" => MainMenuCommand.person,
        "2" => MainMenuCommand.vehicle,
        "3" => MainMenuCommand.parkingSpace,
        "4" => MainMenuCommand.parking,
        "0" => MainMenuCommand.quit,
        _ => MainMenuCommand.invalid
      };
}
