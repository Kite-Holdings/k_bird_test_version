import 'package:kite_bird/base_user/auth/base_user_auth.dart' show BaseUserBearerAouthVerifier;
import 'package:kite_bird/cooprates/auth/cooprates_auth.dart';
import 'package:kite_bird/cooprates/controllers/cooprates_controlers.dart' show 
                CooprateController,
                CooprateFindByController,
                CooprateBankController, CooprateCardController, CooprateMpesaController,
                CooprateMpesaStkController, CooprateCardTransactionController;
import 'package:kite_bird/kite_bird.dart';
import 'package:kite_bird/token/controllers/tokens_controller.dart' show CooprateTokenController;

Router cooprateRoute(Router router){

  const String _rootPath = 'cooperate';

  router
    .route("/$_rootPath/[:cooperateId]")
    .link(() => Authorizer.bearer(BaseUserBearerAouthVerifier()))
    .link(() => CooprateController());
  router
    .route("/$_rootPath/name/:cooperateName")
    .link(() => Authorizer.bearer(BaseUserBearerAouthVerifier()))
    .link(() => CooprateFindByController());  
  router
    .route("/$_rootPath/code/:cooperateCode")
    .link(() => Authorizer.bearer(BaseUserBearerAouthVerifier()))
    .link(() => CooprateFindByController());
  router
    .route("/$_rootPath/token")
    .link(() => Authorizer.basic(CooprateBasicAouthVerifier()))
    .link(() => CooprateTokenController());

  // settings (accounts)
  router
    .route("/$_rootPath/settings/bank")
    .link(() => Authorizer.basic(CooprateBasicAouthVerifier()))
    .link(() => CooprateBankController());
  router
    .route("/$_rootPath/settings/card")
    .link(() => Authorizer.basic(CooprateBasicAouthVerifier()))
    .link(() => CooprateCardController());
  router
    .route("/$_rootPath/settings/mpesa")
    .link(() => Authorizer.basic(CooprateBasicAouthVerifier()))
    .link(() => CooprateMpesaController());
  router
    .route("/$_rootPath/transaction/card")
    .link(() => Authorizer.basic(CooprateBasicAouthVerifier()))
    .link(() => CooprateCardTransactionController());
  router
    .route("/$_rootPath/transaction/mpesa")
    .link(() => Authorizer.basic(CooprateBasicAouthVerifier()))
    .link(() => CooprateMpesaStkController());
  
    

  

  return router;
}