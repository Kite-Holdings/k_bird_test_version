import 'package:kite_bird/accounts/auth/accounts_auth.dart';
import 'package:kite_bird/bank/controllers/bank_controlers.dart';
import 'package:kite_bird/bank/modules/bank_modules.dart' show checkBalance;
import 'package:kite_bird/kite_bird.dart';

Router coopRoutes(Router router){

  // Cooperative Bank
  // pesalink send
  router
    .route('/transactions/bank/pesalink')
    .link(()=> Authorizer.bearer(AccountBearerAouthVerifier()))
    .link(() => PesaLinkSendController());

  // internal funds transfer send
  router
    .route('/transactions/bank/ift')
    .link(()=> Authorizer.bearer(AccountBearerAouthVerifier()))
    .link(() => BankInternalFundsTransferSendController());
  
  // internal funds transfer send
  router
    .route('/transactions/bank/mpesa')
    .link(()=> Authorizer.bearer(AccountBearerAouthVerifier()))
    .link(() => BankMpesaController());

  // Balance
  router
    .route('/bank/balance')
    .linkFunction((request)async{
      return Response.ok(await checkBalance(cooprateCode: '001'));
    });

  return router;
}