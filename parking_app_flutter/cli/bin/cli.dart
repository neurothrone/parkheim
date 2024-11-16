import 'package:cli/src/app.dart';

Future<void> main(List<String> arguments) async {
  final app = App();
  await app.run();
}
