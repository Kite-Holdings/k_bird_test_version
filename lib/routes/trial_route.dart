import 'package:kite_bird/kite_bird.dart';

Router trialRoute(Router router){

  router
    .route("/trial")
    .linkFunction((request) async {
      return Response.ok({"key": "Worked!!"});
    });

  return router;
}