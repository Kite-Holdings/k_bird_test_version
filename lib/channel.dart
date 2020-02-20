import 'package:kite_bird/html_template/card_success.dart';
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
        print(await request.body.decode());
        return Response.ok({"key": "value"});
      });
    
    router
      .route("/cardSuccess")
      .linkFunction((request)async{
        final response = Response.ok(htmlTemplate)
          ..contentType = ContentType.html;
      return response;
    });

    // airtel router
    airtelRouters(router);

    // base users router
    baseUserRoute(router);

    // cooprate route
    cooprateRoute(router);

    // Accounts
    accountsRoute(router);


    // Businesses
    businessRouter(router);


    // Celulant
    cellulantRoutes(router);

    // Transactions
    transactionsRoutes(router);


    return router;
  }
}