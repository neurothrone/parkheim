import 'package:parking_app_cli/src/cli/app.dart';

Future<void> main(List<String> arguments) async {
  final app = App();
  await app.run();
}
