import 'package:kite_bird/controllers/accounts/register_accountverification_controller.dart';
import 'package:kite_bird/kite_bird.dart';

Router accountsRoute(Router router){
  router
    .route('/accounts/verifyNumber')
    .link(()=> RegisterAccountVerificationController());
  
  router
    .route('/verifyOtp')
    .link(()=> VerifyOtp());

  return router;
}