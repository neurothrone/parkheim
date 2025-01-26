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

- Replaced old repositories with new firebase repositories.
- Refactored existing blocs to work with firebase and added new blocs for fetching statistics,
  parking history and creating the user profile.
- Moved firebase repositories to a new package called shared_client_firebase that is shared by the
  admin and user clients.
- Moved datetime extensions to a new package called shared_client_firebase.
- Removed cli client and server.
- Updated mocks and tests to work with the new repositories.

### Admin client

- Added blocs for active parkings, most popular parkings and parking revenue in statistics screen.
- Modified app.dart to fetch statistics when navigating to Statistics Screen for all blocs above.
- Added new SpaceHistoryBloc to fetch parking history for a specific parking space.
- Removed redundant provider implementations and package.
- Implemented realtime listening for Firestore by adding a stream to SpacesListBloc to listen to
  changes in parking spaces whenever one adds/deletes/modifies a parking space on firestore.
- Added auth feature to admin client by reusing the auth feature from the user client. Moved shared
  logic to a new package called shared_client_auth.
- Created a poor implementation for preventing access to app features until a user has the role "
  admin" and verifying the user's role by checking if a Person's role contains the string "admin".
  The plan was to use Firebase Functions to create a admin document in the admins collection in
  Firestore after a user successfully registers. Sadly I couldn't get it to work.

### User client

- Removed redundant people feature directory. Move widgets that were in use to vehicles feature.
- Added new blocs for creating profile, loading profile and parking history.
- Modified AppRouter to load profile or vehicles when switching tabs.
- Fixed some bugs with profile creation, adding vehicles and fetching owned vehicles after replacing
  the old repositories with the new firebase repositories.
- Renamed AddParkingForm to StartParkingForm and moved the owned vehicle list widget code inside to
  its own widget called VehicleDropDownField.

### TODOS (Mandatory)

- Auth for Admin client.
- Video demo
    - Authentication flow
    - CRUD operations towards Firestore
    - Eventual VG functionality

### TODOS (Optional)

- Create a script to run pubspec for all packages.

- Firebase Functions for Person management. Creates a Profil in Firestore when a user is created in
  Firebase Auth. Either do it by:
    - Refactoring registration form.
    - Implementing it with the admin registration.
- Log in with third-party providers (Google, Facebook, GitHub, etc).
- Implement realtime listening for Firestore.
    - Admin client: Listen for active parkings and statistics.
    - User client: Listen for changes in Available parking spaces.