import 'package:kite_bird/kite_bird.dart';
// import 'package:kite_bird/models/model.dart';

Future main() async {
  final app = Application<KiteBirdChannel>()
      ..options.configurationFilePath = "config.yaml"
      ..options.port = 8888;

  final count = Platform.numberOfProcessors ~/ 2;
  await app.start(numberOfInstances: count > 0 ? count : 1);

  // // create indexes
  // final Model _model = Model(dbUrl: databaseUrl);
  // _model.indexes();

  print("Application started on port: ${app.options.port}.");
  print("Use Ctrl-C (SIGINT) to stop running the application.");
}