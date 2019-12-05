import 'package:kite_bird/auth/basic_auth.dart';
import 'package:kite_bird/auth/bearer_auth.dart';
import 'package:kite_bird/controllers/tokens_controller.dart';
import 'package:kite_bird/controllers/users_controller.dart';
import 'package:kite_bird/kite_bird.dart';

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