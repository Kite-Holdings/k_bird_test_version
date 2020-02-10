import 'package:kite_bird/accounts/auth/accounts_auth.dart' show AccountBearerAouthVerifier;
import 'package:kite_bird/businesses/controllers/business_controllers.dart';
import 'package:kite_bird/kite_bird.dart';

Router businessRouter(Router router){
  router
      .route('/business/create')
      .link(()=> Authorizer.bearer(AccountBearerAouthVerifier()))
      .link(()=> CreateBusinessController());

  router
      .route('/business/addStaff')
      .link(()=> Authorizer.bearer(AccountBearerAouthVerifier()))
      .link(()=> AddBusinessStaffController());
  

  return router;
}