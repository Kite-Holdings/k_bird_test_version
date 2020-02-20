import 'package:kite_bird/airtel/controllers/airtel_controllers.dart';
import 'package:kite_bird/kite_bird.dart';

Router airtelRouters(Router router){
  const String _path = '/airtel';
  router
    .route('$_path/bc')
    .link(()=> AirtelBCController());

  router
    .route('$_path/cb')
    .link(()=> AirtelCBController());

  router
    .route('$_path/enroll')
    .link(()=> AirtelEnrollController());

  return router;
}