import 'package:kite_bird/controllers/cooprate_controller.dart';
import 'package:kite_bird/kite_bird.dart';

Router cooprateRoute(Router router){

  const String _rootPath = 'cooprate';

  router
    .route("/$_rootPath/[:cooprateId]")
    .link(() => CooprateController());
  router
    .route("/$_rootPath/name/:cooprateName")
    .link(() => CooprateFindByController());  
  router
    .route("/$_rootPath/code/:cooprateCode")
    .link(() => CooprateFindByController());

  return router;
}