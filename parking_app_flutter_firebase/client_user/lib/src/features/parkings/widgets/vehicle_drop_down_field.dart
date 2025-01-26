import 'package:flutter/material.dart';

import 'package:shared/shared.dart';

class VehicleDropDownField extends StatefulWidget {
  const VehicleDropDownField({
    super.key,
    required this.vehicles,
    required this.initialSelection,
    required this.onVehicleSelected,
  });

  final List<Vehicle> vehicles;
  final Vehicle initialSelection;
  final Function(Vehicle vehicle) onVehicleSelected;

  @override
  State<VehicleDropDownField> createState() => _VehicleDropDownFieldState();
}

class _VehicleDropDownFieldState extends State<VehicleDropDownField> {
  String _registrationNumber = "";

  @override
  void initState() {
    super.initState();
    _registrationNumber = widget.initialSelection.registrationNumber;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      onChanged: (String? newValue) {
        setState(() => _registrationNumber = newValue!);
        widget.onVehicleSelected(
          widget.vehicles.firstWhere(
            (vehicle) => vehicle.registrationNumber == _registrationNumber,
          ),
        );
      },
      validator: (String? value) {
        if (value == null || value == "") {
          return "Vehicle is required";
        }
        return null;
      },
      value: _registrationNumber,
      decoration: InputDecoration(labelText: "Vehicle"),
      items: widget.vehicles.map<DropdownMenuItem<String>>((Vehicle vehicle) {
        return DropdownMenuItem<String>(
          value: vehicle.registrationNumber,
          child: Text(
            vehicle.registrationNumber,
            style: TextStyle(
              fontWeight: _registrationNumber == vehicle.registrationNumber
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        );
      }).toList(),
    );
  }
}
