import 'package:kite_bird/auth/basic_auth.dart';
import 'package:kite_bird/auth/bearer_auth.dart';
import 'package:kite_bird/controllers/accounts/account_login_controller.dart';
import 'package:kite_bird/controllers/accounts/register_account.dart';
import 'package:kite_bird/controllers/accounts/register_accountverification_controller.dart';
import 'package:kite_bird/controllers/token_and_verification/tokens_controller.dart';
import 'package:kite_bird/kite_bird.dart';

Router accountsRoute(Router router){
  router
    .route('/accounts/login')
    .link(()=> Authorizer.basic(AccountLoginAouthVerifier()))
    .link(()=> AccountLoginController());

  router
    .route('/accounts/consumer')
    .link(()=> Authorizer.bearer(RegisterAccountBearerAouthVerifier()))
    .link(()=> RegisterConsumerAccount());
    
  router
    .route('/accounts/verifyNumber')
    .link(()=> Authorizer.bearer(CooprateBearerAouthVerifier()))
    .link(()=> RegisterAccountVerificationController());
  
  router
    .route('/verifyOtp')
    .link(()=> Authorizer.basic(AccountVerifyOtpAouthVerifier()))
    .link(() => AccoutRegisterTokenController());

  return router;
}