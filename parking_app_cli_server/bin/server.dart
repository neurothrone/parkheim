import 'package:parking_app_cli_server/src/applications/server/app.dart';

Future<void> main(List<String> args) async {
  final app = App();
  await app.run();
}
