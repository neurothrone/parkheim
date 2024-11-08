import 'package:server/src/app.dart';

Future<void> main(List<String> args) async {
  final app = App();
  await app.run();
}
