import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared_widgets/shared_widgets.dart';

import '../../../core/widgets/widgets.dart';
import '../state/spaces_list_bloc.dart';
import '../widgets/parking_space_list.dart';
import 'add_space_screen.dart';

class SpacesScreen extends StatelessWidget {
  const SpacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Spaces",
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AddSpaceScreen(),
              ),
            ),
            tooltip: "Add Parking Space",
            icon: Icon(Icons.add_rounded),
          ),
        ],
      ),
      body: Row(
        children: [
          CustomNavigationRail(),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: ParkingSpaceItems(),
          ),
        ],
      ),
    );
  }
}

class ParkingSpaceItems extends StatefulWidget {
  const ParkingSpaceItems({super.key});

  @override
  State<ParkingSpaceItems> createState() => _ParkingSpaceItemsState();
}

class _ParkingSpaceItemsState extends State<ParkingSpaceItems> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<SpacesListBloc>().add(SpacesListLoad());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpacesListBloc, SpacesListState>(
      builder: (context, state) {
        if (state is SpacesListLoading) {
          return CenteredProgressIndicator();
        } else if (state is SpacesListLoaded) {
          if (state.spaces.isEmpty) {
            return const Center(
              child: Text("No parking spaces available."),
            );
          }
          return ParkingSpaceList(spaces: state.spaces);
        } else if (state is SpacesListFailure) {
          return Center(child: Text("Error: ${state.message}"));
        }

        return CenteredProgressIndicator();
      },
    );
  }
}
