import 'package:kite_bird/accounts/auth/accounts_auth.dart' show 
                  AccountLoginAouthVerifier, 
                  AccountBearerAouthVerifier, 
                  AccountVerifyOtpAouthVerifier;
import 'package:kite_bird/accounts/controllers/accounts_controlers.dart' show 
                  AccountLoginController, 
                  AccountController,
                  RegisterConsumerAccount,
                  // RegisterMerchantAccount,
                  RegisterAccountVerificationController;
import 'package:kite_bird/cooprates/auth/cooprates_auth.dart' show CooprateBearerAouthVerifier;
import 'package:kite_bird/kite_bird.dart';

Router accountsRoute(Router router){
  router
    .route('/accounts/login')
      .link(()=> Authorizer.basic(AccountLoginAouthVerifier()))
      .link(()=> AccountLoginController());
  
  router
      .route('/account')
      .link(()=> Authorizer.bearer(AccountBearerAouthVerifier()))
      .link(()=> AccountController());

  router
    .route('/accounts/consumer/register')
    .link(()=> Authorizer.basic(AccountVerifyOtpAouthVerifier()))
    .link(()=> RegisterConsumerAccount());
  router
    .route('/accounts/register')
    .link(()=> Authorizer.basic(AccountVerifyOtpAouthVerifier()))
    .link(()=> RegisterConsumerAccount());
  
  // router
  //   .route('/accounts/merchant/register')
  //   // .link(()=> Authorizer.basic(AccountVerifyOtpAouthVerifier())) will be users
  //   .link(()=> RegisterMerchantAccount());

  
    
  router
    .route('/accounts/verifyNumber')
    .link(()=> Authorizer.bearer(CooprateBearerAouthVerifier()))
    .link(()=> RegisterAccountVerificationController());

  return router;
}