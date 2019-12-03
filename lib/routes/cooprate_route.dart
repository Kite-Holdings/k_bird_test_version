import 'package:kite_bird/auth/basic_auth.dart';
import 'package:kite_bird/auth/bearer_auth.dart';
import 'package:kite_bird/controllers/cooprate_controller.dart';
import 'package:kite_bird/controllers/tokens_controller.dart';
import 'package:kite_bird/kite_bird.dart';

Router cooprateRoute(Router router){

  const String _rootPath = 'cooprate';

  router
    .route("/$_rootPath/[:cooprateId]")
    .link(() => Authorizer.bearer(BaseUserBearerAouthVerifier()))
    .link(() => CooprateController());
  router
    .route("/$_rootPath/name/:cooprateName")
    .link(() => Authorizer.bearer(BaseUserBearerAouthVerifier()))
    .link(() => CooprateFindByController());  
  router
    .route("/$_rootPath/code/:cooprateCode")
    .link(() => Authorizer.bearer(BaseUserBearerAouthVerifier()))
    .link(() => CooprateFindByController());
  router
    .route("/$_rootPath/token")
    .link(() => Authorizer.basic(CooprateBasicAouthVerifier()))
    .link(() => CooprateTokenController());

  return router;
}