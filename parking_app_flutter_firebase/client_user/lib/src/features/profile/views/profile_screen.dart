import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared/shared.dart';
import 'package:shared_client_firebase/shared_client_firebase.dart';
import 'package:shared_widgets/shared_widgets.dart';

import '../../../core/cubits/app_user/app_user_cubit.dart';
import '../../../core/cubits/app_user/app_user_state.dart';
import '../../../core/widgets/widgets.dart';
import '../../people/widgets/person_details.dart';

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
    final appUserCubit = context.read<AppUserCubit>();
    final user = (appUserCubit.state as AppUserSignedIn).user;

    return FutureBuilder<Result<Person, String>>(
      future:
          RemotePersonRepository.instance.findPersonByName(user.displayName!),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final result = snapshot.data!;
          return result.when(
            success: (Person person) => Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Email:",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      user.email!,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                PersonDetails(person: person),
              ],
            ),
            failure: (error) => Center(child: Text("Error: $error")),
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
