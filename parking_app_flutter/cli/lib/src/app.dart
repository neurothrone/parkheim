import 'dart:io';

import 'enums/main_menu_command.dart';
import 'managers/parking_manager.dart';
import 'managers/parking_space_manager.dart';
import 'managers/people_manager.dart';
import 'managers/vehicle_manager.dart';
import 'ui/menu.dart';

class App {
  Future<void> run() async {
    while (true) {
      Menu.printMainMenu();

      final command = Menu.getMainMenuInput();
      switch (command) {
        case MainMenuCommand.person:
          final manager = PersonManager();
          await manager.run();
          break;
        case MainMenuCommand.vehicle:
          final manager = VehicleManager();
          await manager.run();
          break;
        case MainMenuCommand.parkingSpace:
          final manager = ParkingSpaceManager();
          await manager.run();
          break;
        case MainMenuCommand.parking:
          final manager = ParkingManager();
          await manager.run();
          break;
        case MainMenuCommand.quit:
          stdout.writeln("Terminating program.");
          return;
        default:
          break;
      }
    }
  }
}
