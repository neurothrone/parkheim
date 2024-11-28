enum SubMenuCommand {
  addItem,
  showAllItems,
  updateItem,
  removeItem,
  backToMainMenu,
  invalid;

  static SubMenuCommand fromString(String s) => switch (s) {
        "1" => SubMenuCommand.addItem,
        "2" => SubMenuCommand.showAllItems,
        "3" => SubMenuCommand.updateItem,
        "4" => SubMenuCommand.removeItem,
        "0" => SubMenuCommand.backToMainMenu,
        _ => SubMenuCommand.invalid
      };
}
