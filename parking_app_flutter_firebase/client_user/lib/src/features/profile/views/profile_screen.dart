import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared_widgets/shared_widgets.dart';

import '../../../core/widgets/widgets.dart';
import '../../vehicles/widgets/person_details.dart';
import '../state/profile_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Profile",
      bottomNavigationBar: CustomNavigationBar(),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: ProfileDetails(),
      ),
    );
  }
}

class ProfileDetails extends StatelessWidget {
  const ProfileDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          return Column(
            children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       "Email:",
              //       style: Theme.of(context).textTheme.bodyLarge,
              //     ),
              //     Text(
              //        user.email!,
              //       style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //   ],
              // ),
              PersonDetails(person: state.person),
            ],
          );
        } else if (state is ProfileFailure) {
          return Center(child: Text("Error: ${state.message}"));
        }

        return CenteredProgressIndicator();
      },
    );
  }
}
