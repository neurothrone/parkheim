# Parking App

## Setup

Download the latest version of objectbox for your platform from
https://github.com/objectbox/objectbox-c/releases and move the downloaded file to `server/lib`
directory.

Some generated Swedish social security numbers for testing:

- 19900101-1239
- 20011231-5676
- 19871020+2345

## Fundamental implementations

- Both Admin and User clients now use BLoC for state management. Cubits (and HydratedBloc) where
  simple state management is needed, and Blocs where more complex state management is needed.
- Refactored most of the code that used FutureProviders and other segments that had access to
  repositories through singletons. Now, the BLoC classes are responsible for handling the
  repositories which are provided to them through dependency injection with the get_it package. Code
  is cleaner and more testable.
- Added tests for the BLoC classes.
