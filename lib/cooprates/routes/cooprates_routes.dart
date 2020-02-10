import 'package:kite_bird/base_user/auth/base_user_auth.dart' show BaseUserBearerAouthVerifier;
import 'package:kite_bird/cooprates/auth/cooprates_auth.dart';
import 'package:kite_bird/cooprates/controllers/cooprates_controlers.dart' show 
                CooprateController,
                CooprateFindByController;
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

  return router;
}