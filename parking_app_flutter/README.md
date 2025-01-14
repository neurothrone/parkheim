# Parking App

## Setup

Download the latest version of objectbox for your platform from
https://github.com/objectbox/objectbox-c/releases and move the downloaded file to `server/lib`
directory.

Some generated Swedish social security numbers for testing:

- 19900101-1239
- 20011231-5676
- 19871020+2345

## Changes overview

- Both Admin and User clients now use BLoC for state management. Cubits (and HydratedBloc) where
  simple state management is needed, and Blocs where more complex state management is needed.
- Refactored most of the code that used FutureProviders and other segments that had access to
  repositories through singletons. Now, the BLoC classes are responsible for handling the
  repositories which are provided to them through dependency injection with the get_it package. Code
  is now cleaner and more testable.
- Added tests for all core BLoC classes.

### Admin client

- AuthCubit (HydratedCubit) now handles the authentication state of the admin client instead of
  AuthProvider.
- ParkingTabCubit now handles the state of the parking tab instead of ParkingTabProvider.
- ParkingSearchTextCubit now handles the state of the search text field instead of
  ParkingSearchTextProvider.
- ParkingListBloc now handles the state of the parking list instead of ParkingListProvider.
- SpacesListBloc now handles the state of the spaces list instead of SpacesListProvider.
- Added tests for AuthBloc, ParkingListBloc and SpacesListBloc.

### User client

- AuthBloc and AppUserCubit already existed and was used for handling the authentication state of
  the user client.
- BottomNavigationCubit also already existed and handles the state of the bottom navigation bar.
- VehicleListBloc was created to handle the state of the vehicle list of current user's owned
  vehicles, adding new vehicles and removing existing ones.
- ActiveParkingsBloc was created to handle the state of the active parkings list and to end active
  parkings.
- AvailableSpacesBloc was created to handle the state of the available spaces list and to start
  parkings.
- Added tests for AuthBloc, ActiveParkingsBloc, AvailableSpacesBloc and VehicleListBloc.