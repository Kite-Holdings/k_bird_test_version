import 'package:kite_bird/kite_bird.dart';
import 'package:kite_bird/third_party_operations/mpesa/check_stk_process.dart';
// import 'package:kite_bird/models/model.dart';

Future main() async {
  final app = Application<KiteBirdChannel>()
      ..options.configurationFilePath = "config.yaml"
      ..options.port = 2027;

  final count = Platform.numberOfProcessors ~/ 2;
  await app.start(numberOfInstances: count > 0 ? count : 1);

  // // create indexes
  // final Model _model = Model(dbUrl: databaseUrl);
  // _model.indexes();
  // int i = 0;
  const bool _check = true;
  while(_check){
    // i++;
    // print('........................................$i');
    await checkStkProcessStatus();
    await Future.delayed(const Duration(seconds: 100));
  }

  print("Application started on port: ${app.options.port}.");
  print("Use Ctrl-C (SIGINT) to stop running the application.");
}