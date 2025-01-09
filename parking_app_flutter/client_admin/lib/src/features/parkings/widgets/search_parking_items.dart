import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared_widgets/shared_widgets.dart';

import '../state/parking_list_bloc.dart';
import '../state/parking_search_text_cubit.dart';
import 'parking_list.dart';

class SearchParkingItems extends StatelessWidget {
  const SearchParkingItems({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: AddressSearchBar(),
          ),
          Divider(height: 0),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: const Text("Results"),
          ),
          Divider(height: 0),
          SearchedParkingsList(),
        ],
      ),
    );
  }
}

class AddressSearchBar extends StatelessWidget {
  const AddressSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    controller.text = context.watch<ParkingSearchTextCubit>().state;

    return TextField(
      controller: controller,
      autocorrect: false,
      textCapitalization: TextCapitalization.none,
      onSubmitted: (text) {
        context.read<ParkingSearchTextCubit>().search(text);
        context
            .read<ParkingListBloc>()
            .add(ParkingListSearchItems(searchText: text));
      },
      decoration: InputDecoration(
        hintText: "Search parkings by address",
        suffixIcon: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            context.read<ParkingSearchTextCubit>().search(controller.text);
            context
                .read<ParkingListBloc>()
                .add(ParkingListSearchItems(searchText: controller.text));
          },
        ),
        border: OutlineInputBorder(),
      ),
    );
  }
}

class SearchedParkingsList extends StatelessWidget {
  const SearchedParkingsList({super.key});

  @override
  Widget build(BuildContext context) {
    final searchText = context.watch<ParkingSearchTextCubit>().state;

    return BlocBuilder<ParkingListBloc, ParkingListState>(
      builder: (context, state) {
        if (state is ParkingListLoaded) {
          if (state.parkings.isEmpty) {
            return ListTile(
              title: Text(searchText.isEmpty
                  ? "Try entering something."
                  : "No results."),
            );
          }
          return ParkingList(
            parkings: state.parkings,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          );
        }

        if (state is ParkingListFailure) {
          return Center(child: Text("Error: ${state.message}"));
        }

        return CenteredProgressIndicator();
      },
    );
  }
}
