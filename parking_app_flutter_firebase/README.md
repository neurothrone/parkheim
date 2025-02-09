# Parking App

## Setup

Some generated Swedish social security numbers for testing:

- 19900101-1239
- 20011231-5676
- 19871020+2345

## Changes overview

- User client: Implement local notifications for parking reminders on Android and iOS.

### User client

- Set up local notifications for Android and iOS.
- Make `endTime` non-nullable in `Parking` model.
- Add `isActive` getter to `Parking` to check if the current time is before the `endTime`.
- Refactor `Parking` model, repositories, and blocs to use a new `isActive` getter for filtering
  active parkings.
- Set default 1-hour duration for parking creation.
- Add `Duration` extension to format time.
- Implement `NotificationRepository` to handle local notifications.
- Implement `ParkingCountdown` widget.
- Add extend parking functionality.
- Implement parking notifications.
- Refactor `ActiveParkingScreen` to add new functionality.
- Mock `NotificationRepository`, Update tests and blocs to use the new `Parking` and `isActive`
  getter.
