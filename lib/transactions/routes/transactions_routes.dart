import 'package:kite_bird/accounts/auth/accounts_auth.dart' show AccountBearerAouthVerifier;
import 'package:kite_bird/flutterwave/controllers/flutterwave_controlers.dart' show FlutterWaveCardTransactionController;
import 'package:kite_bird/kite_bird.dart';
import 'package:kite_bird/mpesa/controllers/mpesa_controlers.dart' show MpesaCbRequestController;
import 'package:kite_bird/transactions/controllers/transactions_controlers.dart';
import 'package:kite_bird/wallets/controllers/wallets_controlers.dart' show WalletToWalletController, WalletActivitiesController;

Router transactionsRoutes(Router router){
  const String _baseUrl = '/transactions';

  router
    .route('$_baseUrl/mpesaToWallet')
    .link(()=> Authorizer.bearer(AccountBearerAouthVerifier()))
    .link(()=> MpesaCbRequestController());

  // callback
  router
    .route('mResponces/cb/:requestId')
    .link(()=> MpesaStkCallbackController());

  // wallet to wallet
  router
    .route('/$_baseUrl/walletToWallet')
    .link(()=> Authorizer.bearer(AccountBearerAouthVerifier()))
    .link(()=> WalletToWalletController());

  // card to wallet
  router
    .route('/$_baseUrl/cardToWallet')
    .link(()=> Authorizer.bearer(AccountBearerAouthVerifier()))
    .link(()=> FlutterWaveCardTransactionController());

  // card callback
  router
    .route('/flutterWaveResponse')
    .link(()=> FlutterWaveResponseController());

  // transactions
  router
    .route('/$_baseUrl')
    .link(()=> Authorizer.bearer(AccountBearerAouthVerifier()))
    .link(() => TransactionsController());

  // wallet activities
  router
    .route('/$_baseUrl/walletActivities')
    .link(()=> Authorizer.bearer(AccountBearerAouthVerifier()))
    .link(() => WalletActivitiesController());


  return router;
}