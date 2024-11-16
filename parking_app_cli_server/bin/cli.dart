import 'package:parking_app_cli_server/src/applications/cli/app.dart';

Future<void> main(List<String> arguments) async {
  final app = App();
  await app.run();
}
