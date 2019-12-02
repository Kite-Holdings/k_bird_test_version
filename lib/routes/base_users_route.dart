import 'package:kite_bird/controllers/users_controller.dart';
import 'package:kite_bird/kite_bird.dart';

Router baseUserRoute(Router router){
  const String _rootPath = 'users';

  router
    .route('/$_rootPath/[:userId]')
    .link(()=> UserController());

  router
    .route('/$_rootPath/email/:email')
    .link(()=> UserFindByController());

  return router;
}