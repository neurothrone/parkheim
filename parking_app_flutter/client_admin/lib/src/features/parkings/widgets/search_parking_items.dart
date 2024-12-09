import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';
import 'package:shared_widgets/shared_widgets.dart';

import '../state/parking_search_text_provider.dart';
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
    controller.text = context.watch<ParkingSearchTextProvider>().searchText;

    return TextField(
      controller: controller,
      autocorrect: false,
      textCapitalization: TextCapitalization.none,
      onSubmitted: (text) {
        context.read<ParkingSearchTextProvider>().search(text);
      },
      decoration: InputDecoration(
        hintText: "Search parkings by address",
        suffixIcon: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            context.read<ParkingSearchTextProvider>().search(controller.text);
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
    final searchText = context.watch<ParkingSearchTextProvider>().searchText;

    return FutureBuilder<List<Parking>>(
      future: RemoteParkingRepository.instance.searchParkings(searchText),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final parkings = snapshot.data!;
          if (parkings.isEmpty) {
            return ListTile(
              title: Text(searchText.isEmpty
                  ? "Try entering something."
                  : "No results."),
            );
          }

          return ParkingList(
            parkings: parkings,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          );
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        return CenteredProgressIndicator();
      },
    );
  }
}
