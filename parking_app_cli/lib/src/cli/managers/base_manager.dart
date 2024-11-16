import 'dart:io';

import '../../libraries/core/enums/vehicle_type.dart';
import '../../libraries/core/models/base_model.dart';
import '../../libraries/core/models/parking.dart';
import '../../libraries/core/models/parking_space.dart';
import '../../libraries/core/models/person.dart';
import '../../libraries/core/models/vehicle.dart';
import '../../libraries/core/repositories/remote/remote_parking_repository.dart';
import '../../libraries/core/repositories/remote/remote_parking_space_repository.dart';
import '../../libraries/core/repositories/remote/remote_person_repository.dart';
import '../../libraries/core/repositories/remote/remote_vehicle_repository.dart';
import '../../libraries/core/utils/validation_helper.dart';
import '../enums/model_type.dart';
import '../enums/sub_menu_command.dart';
import '../ui/constants.dart';
import '../ui/menu.dart';
import '../utils/input_helper.dart';
import '../utils/vehicle_type_extensions.dart';

abstract class BaseManager {
  // region Fields & Properties

  // !: In-memory repositories
  // final PersonRepository personRepository = PersonRepository.instance;
  // final VehicleRepository vehicleRepository = VehicleRepository.instance;
  // final ParkingRepository parkingRepository = ParkingRepository.instance;
  // final ParkingSpaceRepository parkingSpaceRepository =
  //     ParkingSpaceRepository.instance;

  // !: Remote repositories
  final RemotePersonRepository personRepository =
      RemotePersonRepository.instance;
  final RemoteVehicleRepository vehicleRepository =
      RemoteVehicleRepository.instance;
  final RemoteParkingRepository parkingRepository =
      RemoteParkingRepository.instance;
  final RemoteParkingSpaceRepository parkingSpaceRepository =
      RemoteParkingSpaceRepository.instance;

  ModelType get modelType;

  // endregion

  // region Core

  Future<void> run() async {
    stdout.writeln("You have chosen ${modelType.plural()}. What would "
        "you like to do?");

    while (true) {
      Menu.printSubMenu(modelType);

      final command = Menu.getSubMenuInput();
      switch (command) {
        case SubMenuCommand.addItem:
          await addItem(modelType);
          break;
        case SubMenuCommand.showAllItems:
          await showAllItems(modelType);
          break;
        case SubMenuCommand.updateItem:
          await updateItem(modelType);
          break;
        case SubMenuCommand.removeItem:
          await deleteItem(modelType);
          break;
        case SubMenuCommand.backToMainMenu:
          return;
        default:
          break;
      }
    }
  }

  Future<void> addItem(ModelType modelType) async {
    final BaseModel? item = switch (modelType) {
      ModelType.person => createPerson(),
      ModelType.vehicle => await createVehicle(),
      ModelType.parking => await createParking(),
      ModelType.parkingSpace => createParkingSpace(),
    };
    if (item == null) {
      return;
    }

    switch (modelType) {
      case ModelType.person:
        await personRepository.create(item as Person);
      case ModelType.vehicle:
        await vehicleRepository.create(item as Vehicle);
      case ModelType.parking:
        await parkingRepository.create(item as Parking);
      case ModelType.parkingSpace:
        await parkingSpaceRepository.create(item as ParkingSpace);
    }

    stdout.writeln("✅ -> ${modelType.singular()} created.");
  }

  Future<void> showAllItems(ModelType modelType) async {
    final List<BaseModel> items = switch (modelType) {
      ModelType.person => await personRepository.getAll(),
      ModelType.vehicle => await vehicleRepository.getAll(),
      ModelType.parking => await parkingRepository.getAll(),
      ModelType.parkingSpace => await parkingSpaceRepository.getAll(),
    };

    if (items.isEmpty) {
      stdout.writeln("No ${modelType.plural()} yet, try adding one first.");
      return;
    }

    stdout.writeln(modelType.plural());
    stdout.writeln(Constants.divider);
    for (var item in items) {
      stdout.writeln("- $item");
    }
  }

  Future<void> updateItem(ModelType modelType) async {
    final List<BaseModel> items = switch (modelType) {
      ModelType.person => await personRepository.getAll(),
      ModelType.vehicle => await vehicleRepository.getAll(),
      ModelType.parking => await parkingRepository.getAll(),
      ModelType.parkingSpace => await parkingSpaceRepository.getAll(),
    };
    if (items.isEmpty) {
      stdout.writeln(
          "Nothing to update, try adding ${modelType.plural()} first.");
      return;
    }

    listOneBasedIndexedItems(items);
    int index = getValidIndexedItem(items.length, modelType);
    if (index == -1) {
      return; // Abort
    }

    stdout.writeln(
        "Enter what the prompts require or enter 0 at any time to abort.");
    final bool? updated = switch (modelType) {
      ModelType.person => await updatePerson(items[index] as Person),
      ModelType.vehicle => await updateVehicle(items[index] as Vehicle),
      ModelType.parking => await updateParking(items[index] as Parking),
      ModelType.parkingSpace =>
        await updateParkingSpace(items[index] as ParkingSpace),
    };
    if (updated == null) {
      return;
    }

    if (updated) {
      stdout.writeln("✅ -> ${modelType.singular()} updated.");
    } else {
      stdout.writeln("⚠️ -> ${modelType.singular()} NOT updated.");
    }
  }

  Future<void> deleteItem(ModelType modelType) async {
    BaseModel? selection = await selectItem(modelType);
    if (selection == null) {
      return;
    }

    // TODO: Should deleting a existing Person remove it existing Vehicles?
    // await _vehicleRepository.removeOwnerFromVehicles(person);
    // TODO: Should deleting a Vehicle remove it from existing Parkings?
    // TODO: Should deleting a ParkingSpace remove it from existing Parkings?

    final deleted = switch (modelType) {
      ModelType.person => await personRepository.delete(selection.id),
      ModelType.vehicle => await vehicleRepository.delete(selection.id),
      ModelType.parking => await parkingRepository.delete(selection.id),
      ModelType.parkingSpace =>
        await parkingSpaceRepository.delete(selection.id),
    };

    if (deleted) {
      stdout.writeln("✅ -> ${modelType.singular()} deleted.");
    } else {
      stdout.writeln("⚠️ -> ${modelType.singular()} NOT deleted.");
    }
  }

  // endregion

  // region Helpers

  void listOneBasedIndexedItems(List<BaseModel> items) {
    stdout.writeln(Constants.divider);
    for (int i = 0; i < items.length; i++) {
      stdout.writeln("${i + 1} - ${items[i]}");
    }
    stdout.writeln(Constants.divider);
  }

  int getValidIndexedItem(int itemsLength, ModelType modelType) {
    stdout.writeln("Select ${modelType.singular()} by number or 0 to abort:");

    while (true) {
      var input = stdin.readLineSync() ?? "";
      var selection = int.tryParse(input);
      if (selection == null) {
        stdout.writeln("Invalid input. Try again.");
        continue;
      }

      // Abort
      if (selection == 0) {
        return -1;
      }

      // Check if valid index
      int index = selection - 1;
      if (index < 0 || index >= itemsLength) {
        stdout.writeln("That is not a valid choice, try again");
        continue;
      }

      return index;
    }
  }

  // endregion

  // region Select

  Future<BaseModel?> selectItem(ModelType modelType) async {
    final List<BaseModel> items = switch (modelType) {
      ModelType.person => await personRepository.getAll(),
      ModelType.vehicle => await vehicleRepository.getAll(),
      ModelType.parking => await personRepository.getAll(),
      ModelType.parkingSpace => await personRepository.getAll(),
    };

    if (items.isEmpty) {
      stdout.writeln("No ${modelType.singular()} to select.");
      return null;
    }

    listOneBasedIndexedItems(items);
    int index = getValidIndexedItem(items.length, modelType);
    if (index == -1) {
      return null;
    }

    return items[index];
  }

  VehicleType? selectVehicleType() {
    VehicleTypeExtensions.listOneBasedIndexedValues();
    stdout.writeln("Select Vehicle Type by number or 0 to abort:");

    VehicleType vehicleType = VehicleType.unknown;
    while (true) {
      final input = stdin.readLineSync() ?? "";

      if (input == "0") {
        return null;
      }

      vehicleType = VehicleType.fromString(input);
      if (vehicleType != VehicleType.unknown) {
        return vehicleType;
      }

      stdout.writeln("That is not a valid selection, try again.");
    }
  }

  // endregion

  // region Create

  Person? createPerson() {
    stdout.writeln(
        "Enter what the prompts require or enter 0 at any time to abort.");

    String? name = InputHelper.geStringInput("Name");
    if (name == null) {
      return null;
    }

    String? socialSecurityNumber =
        InputHelper.geStringInput("Social security number");
    if (socialSecurityNumber == null) {
      return null;
    }

    return Person(
      name: name,
      socialSecurityNumber: socialSecurityNumber,
    );
  }

  Future<Vehicle?> createVehicle() async {
    stdout.writeln(
        "Enter what the prompts require or enter 0 at any time to abort.");

    String? registrationNumber;
    while (true) {
      registrationNumber = InputHelper.geStringInput("Registration number");
      if (registrationNumber == null) {
        return null;
      }

      if (ValidationHelper.isValidRegistrationNumber(registrationNumber)) {
        break;
      }

      stdout.writeln("That is not a valid Swedish registration number.");
    }

    VehicleType? vehicleType = selectVehicleType();
    if (vehicleType == null) {
      return null;
    }

    Person? owner = (await selectItem(ModelType.person)) as Person?;
    if (owner == null) {
      return null;
    }

    return Vehicle(
      registrationNumber: registrationNumber,
      vehicleType: vehicleType,
      owner: owner,
    );
  }

  ParkingSpace? createParkingSpace() {
    stdout.writeln(
        "Enter what the prompts require or enter 0 at any time to abort.");

    String? address = InputHelper.geStringInput("Address");
    if (address == null) {
      return null;
    }

    double? pricePerHour = InputHelper.getDoubleInput("Price per hour");
    if (pricePerHour == null) {
      return null;
    }

    return ParkingSpace(address: address, pricePerHour: pricePerHour);
  }

  Future<Parking?> createParking() async {
    stdout.writeln(
        "Enter what the prompts require or enter 0 at any time to abort.");

    Vehicle? vehicle = (await selectItem(ModelType.vehicle)) as Vehicle?;
    if (vehicle == null) {
      return null;
    }

    ParkingSpace? parkingSpace =
        (await selectItem(ModelType.parkingSpace)) as ParkingSpace?;
    if (parkingSpace == null) {
      return null;
    }

    DateTime? startTime = InputHelper.getCustomDateTimeInput("Start time");
    if (startTime == null) {
      return null;
    }

    // TODO: What else is needed
    // Situations:
    // - Adding parkings that has already happened
    // - Parkings that just started.
    DateTime? endTime;

    return Parking(
      vehicle: vehicle,
      parkingSpace: parkingSpace,
      startTime: startTime,
      endTime: endTime,
    );
  }

  // endregion

  // region Update

  Future<bool?> updatePerson(Person person) async {
    String? newName = InputHelper.geStringInput(
      "Name",
      message: "Enter new name or leave empty not to update",
      canBeEmpty: true,
    );
    if (newName == null) {
      return null;
    }

    String? newSocialSecurityNumber = InputHelper.geStringInput(
      "Social security number",
      message: "Enter new social security number or leave empty not to update",
      canBeEmpty: true,
    );
    if (newSocialSecurityNumber == null) {
      return null;
    }

    if (newName.isEmpty && newSocialSecurityNumber.isEmpty) {
      return null;
    }

    final updatedPerson = person.copyWith(
      name: newName.isEmpty ? null : newName,
      socialSecurityNumber:
          newSocialSecurityNumber.isEmpty ? null : newSocialSecurityNumber,
    );
    return await personRepository.update(updatedPerson);
  }

  Future<bool?> updateVehicle(Vehicle vehicle) async {
    String? newRegistrationNumber = InputHelper.geStringInput(
      "Registration number",
      message: "Enter new registration number or leave empty not to update",
      canBeEmpty: true,
    );
    if (newRegistrationNumber == null) {
      return null;
    }

    VehicleType? newVehicleType = selectVehicleType();
    if (newVehicleType == null) {
      return null;
    }

    stdout.writeln("Enter y to change owner, r to remove current owner, "
        "n to leave as be and 0 to abort:");

    Person? owner;
    bool setOwnerToNull = false;

    while (true) {
      final input = stdin.readLineSync() ?? "";
      if (input == "0") {
        return null;
      }
      if (input == "r") {
        owner = null;
        setOwnerToNull = true;
        break;
      }
      if (input == "n") {
        owner = vehicle.owner;
        setOwnerToNull = false;
        break;
      }
      if (input == "y") {
        owner = (await selectItem(ModelType.person)) as Person?;
        break;
      }

      stdout.writeln("That is not a valid choice, try again.");
    }

    final vehicleToUpdate = vehicle.copyWith(
      registrationNumber:
          newRegistrationNumber.isEmpty ? null : newRegistrationNumber,
      vehicleType: newVehicleType,
      owner: owner,
      setOwnerToNull: setOwnerToNull,
    );
    return await vehicleRepository.update(vehicleToUpdate);
  }

  Future<bool?> updateParking(Parking parking) async {
    stdout.writeln("Enter y to change vehicle, r to remove current vehicle, "
        "n to leave as be and 0 to abort:");

    Vehicle? vehicle;
    bool setVehicleToNull = false;

    while (true) {
      final input = stdin.readLineSync() ?? "";
      if (input == "0") {
        return null;
      }
      if (input == "r") {
        vehicle = null;
        setVehicleToNull = true;
        break;
      }
      if (input == "n") {
        vehicle = parking.vehicle;
        setVehicleToNull = false;
        break;
      }
      if (input == "y") {
        vehicle = (await selectItem(ModelType.vehicle)) as Vehicle?;
        break;
      }

      stdout.writeln("That is not a valid choice, try again.");
    }

    stdout.writeln("Enter y to change parking space, r to remove current "
        "parking space, n to leave as be and 0 to abort:");

    ParkingSpace? parkingSpace;
    bool setParkingSpaceToNull = false;

    while (true) {
      final input = stdin.readLineSync() ?? "";
      if (input == "0") {
        return null;
      }
      if (input == "r") {
        parkingSpace = null;
        setParkingSpaceToNull = true;
        break;
      }
      if (input == "n") {
        parkingSpace = parking.parkingSpace;
        setParkingSpaceToNull = false;
        break;
      }
      if (input == "y") {
        parkingSpace =
            (await selectItem(ModelType.parkingSpace)) as ParkingSpace?;
        break;
      }

      stdout.writeln("That is not a valid choice, try again.");
    }

    DateTime? startTime = InputHelper.getCustomDateTimeInput("Start time");
    DateTime? endTime =
        InputHelper.getCustomDateTimeInput("Start time", start: startTime);

    final parkingToUpdate = parking.copyWith(
      vehicle: vehicle,
      setVehicleToNull: setVehicleToNull,
      parkingSpace: parkingSpace,
      setParkingSpaceToNull: setParkingSpaceToNull,
      startTime: startTime,
      endTime: endTime,
    );
    return await parkingRepository.update(parkingToUpdate);
  }

  Future<bool?> updateParkingSpace(ParkingSpace parkingSpace) async {
    String? newAddress = InputHelper.geStringInput(
      "Address",
      message: "Enter new address or leave empty not to update",
      canBeEmpty: true,
    );
    if (newAddress == null) {
      return null;
    }

    double? pricePerHour = InputHelper.getDoubleInput("Price per hour");
    if (pricePerHour == null) {
      return null;
    }

    final parkingSpaceToUpdate = parkingSpace.copyWith(
      address: newAddress.isEmpty ? null : newAddress,
      pricePerHour: pricePerHour,
    );
    return await parkingSpaceRepository.update(parkingSpaceToUpdate);
  }

  // endregion

  // region Search

  Future<List<Vehicle>> findVehiclesByOwner(Person owner) async {
    return await vehicleRepository.findVehiclesByOwner(owner);
  }

  Future<List<ParkingSpace>> findParkingSpacesByVehicle(Vehicle vehicle) async {
    return await parkingRepository.findParkingSpacesByVehicle(vehicle);
  }

// endregion
}
