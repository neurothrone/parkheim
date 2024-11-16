import 'package:parking_app_cli/src/applications/server/app.dart';

Future<void> main(List<String> args) async {
  final app = App();
  await app.run();
}
