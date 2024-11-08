import 'dart:io';

import '../../../libraries/core/enums/model_type.dart';
import '../enums/main_menu_command.dart';
import '../enums/sub_menu_command.dart';
import 'constants.dart';

class Menu {
  Menu._internal();

  static void printMainMenu() {
    stdout.writeln(Constants.divider);
    stdout.writeln("Main Menu");
    stdout.writeln(Constants.divider);
    stdout.writeln("1. People");
    stdout.writeln("2. Vehicles");
    stdout.writeln("3. Parking spaces");
    stdout.writeln("4. Parkings");
    stdout.writeln("0. Quit");
    stdout.writeln(Constants.divider);
  }

  static void printSubMenu(ModelType managerType) {
    final singular = managerType.singular();
    final plural = managerType.plural();

    stdout.writeln(Constants.divider);
    stdout.writeln("$plural Manager");
    stdout.writeln(Constants.divider);
    stdout.writeln("1. Create new $singular");
    stdout.writeln("2. Show all $plural");
    stdout.writeln("3. Update $singular");
    stdout.writeln("4. Remove $singular");
    stdout.writeln("0. Back to Main Menu");
    stdout.writeln(Constants.divider);
  }

  static MainMenuCommand getMainMenuInput() {
    while (true) {
      final input = stdin.readLineSync() ?? "";
      final command = MainMenuCommand.fromString(input);
      if (command != MainMenuCommand.invalid) return command;

      stdout.writeln("Invalid command, try again.");
    }
  }

  static SubMenuCommand getSubMenuInput() {
    while (true) {
      final input = stdin.readLineSync() ?? "";
      final command = SubMenuCommand.fromString(input);
      if (command != SubMenuCommand.invalid) return command;

      stdout.writeln("Invalid command, try again.");
    }
  }
}
