# Parking App

## Setup

Download the latest version of objectbox for your platform from
https://github.com/objectbox/objectbox-c/releases and move the downloaded file to `server/lib`
directory.

Some generated Swedish social security numbers for testing:

- 19900101-1239
- 20011231-5676
- 19871020+2345

## Fundamental functionality

### Admin features

- Spaces Tab:
    - Users can add, delete and list parking spaces.
    - Users can navigate to the parking space details screen by tapping on a parking space in the
      list and see a history of parkings.
- Parkings Tab:
    - Users can list existing parkings by active (ongoing), all and by searching (case insensitive)
      by address.
- Statistics Tab:
    - Users can see statistics about the parking spaces and parkings, such as active parkings, total
      revenue and the five (can be adjusted by limit parameter) most popular parking spaces.

### Client features

- Authentication:
    - Sign in with email and password.
    - Sign up with email and password.
    - Create a profile with a name and a Swedish social security number. (Used for creating a Person
      entity in the server).
- Parkings Tab:
    - Users can list active parkings (Active tab).
        - Users can navigate to the parking details screen by tapping on an active parking in the
          list.
        - They can end the parking by tapping on the stop button in the parking details screen.
    - Users can list available parking spaces (Available tab).
        - Users can navigate to the parking details screen by tapping on an available parking space
          in the list.
        - They can start a parking by tapping on the start button in the parking details screen.
    - Users can see a history of their parkings (History tab).
        - Users can navigate to the parking details screen by tapping on a finished parking in the
          list.
        - They can see the start, end time and the total cost of the parking.
- Vehicles Tab:
    - Users can add, delete and list vehicles.
    - Users can navigate to the vehicle details screen by tapping on a vehicle in the list.
- Profile Tab:
    - Users can see their profile information (Email, Name & SSN).
- Settings Tab:
    - Dark mode toggle.
    - Sign out button.

### Advanced features

#### Search functionality (Admin app)

The admin app has a search functionality that allows the user to search for existing parkings by
address.

#### Sorting options for lists

The bottom Parkings tab in the bottom tab bar in the client app has a top tab bar that allows the
user to switch between sorting Parkings by Active (Ongoing), Available and History (Finished
parkings).

#### Dark/Light Theme

The client app support both dark and light themes. The feature with its state and UI can be
found in the `lib/src/feature/settings` directory inside `client_user` project.

#### Shared code libraries

- The `shared` package contains shared code libraries that are used by both the client and server,
  such as the domain models, enums, interfaces and utilities.
- The `shared_client` package contains shared client repositories and utils for the client
  applications.
- The `shared_widgets` package contains Flutter widgets, validators, services and dialogs that are
  shared between the client applications.

## Known limitations

- Admin app currently only works on desktop (MacOS verified). I suspect CORS is not set up
  correctly for the web version.
- I tried to implement the Parkings section in the Admin app with a CustomScrollView and slivers.
  Sadly, I ran into multiple issues and eventually settled for using SingleChildScrollView.

## Notes

- Many specific implementations have been done in the client repositories instead of the server
  repositories because I know we will replace the local `shelf` server for Firebase later.
- At the end of the dart course I refactored the repositories to use the Result pattern. Some of my
  implementations use the result object in the UI and some do not. I was not sure what the best
  practices were in this case so there is some variations in their use. Eventually I will settle
  permanently for one approach when I have a better understanding of the best practices.
- Concerning state management solutions, I used `Provider` for the admin app and `Bloc` for the
  client app. I wanted to try out `Bloc` for the client app since I have used `Provider` before.
- The authentication in the client app uses Firebase Authentication. When a user creates an account
  they need to create a person through a profile form which is used to set their name to displayName
  in Firebase Authentication.