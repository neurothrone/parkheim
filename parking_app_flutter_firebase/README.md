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

- Removed cli client and server.
- shared_client_firebase
- Added a new package called shared_client_firebase to share the firebase client between the admin
  and user clients. Implemented firebase repositories. Moved datetime extensions to this new
  package. Removed the old repositories that connected to the shelf server.

### Admin client

- Modified app.dart to add loading events to fetch statistics when navigation to Statistics Screen.
- Removed redundant provider implementations and package.
  Fixed. TODO

### User client

