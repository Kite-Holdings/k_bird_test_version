import 'package:kite_bird/routes/routers_export.dart';

import 'kite_bird.dart';
class KiteBirdChannel extends ApplicationChannel {
  @override
  Future prepare() async {
    logger.onRecord.listen((rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
  }

  @override
  Controller get entryPoint {
    final router = Router();

    router
      .route("/")
      .linkFunction((request) async {
        return Response.ok({"key": "value"});
      });

    // trial router
    trialRoute(router);

    // base users router
    baseUserRoute(router);

    // cooprate route
    cooprateRoute(router);

    // Accounts
    accountsRoute(router);


    return router;
  }
}