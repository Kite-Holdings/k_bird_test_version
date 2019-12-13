import 'package:kite_bird/controllers/transactions/mpesa/mpesa_cb_wallet.dart';
import 'package:kite_bird/kite_bird.dart';

Router transactionsRoutes(Router router){
  const String _baseUrl = '/transactions';

  router
    .route('$_baseUrl/mpesa/cb')
    .link(()=> MpesaCbRequestController());


  return router;
}