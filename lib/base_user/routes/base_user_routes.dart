import 'package:kite_bird/base_user/auth/base_user_auth.dart';
import 'package:kite_bird/base_user/controllers/base_user_controlers.dart';
import 'package:kite_bird/kite_bird.dart';
import 'package:kite_bird/token/controllers/tokens_controller.dart' show BaseUserTokenController;

Router baseUserRoute(Router router){
  const String _rootPath = 'users';

  router
    .route('/$_rootPath/[:userId]')
    // .link(() => Authorizer.bearer(BaseUserBearerAouthVerifier()))
    .link(()=> UserController());

  router
    .route('/$_rootPath/email/:email')
    .link(() => Authorizer.bearer(BaseUserBearerAouthVerifier()))
    .link(()=> UserFindByController());
  router
    .route('/$_rootPath/login')
    .link(() => Authorizer.basic(BaseUserBasicAouthVerifier()))
    .link(()=> BaseUserTokenController());

  return router;
}