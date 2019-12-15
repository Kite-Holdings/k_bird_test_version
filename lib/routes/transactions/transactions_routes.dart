import 'package:kite_bird/auth/bearer_auth.dart';
import 'package:kite_bird/controllers/transactions/callbacks/flutterwave_callback.dart';
import 'package:kite_bird/controllers/transactions/callbacks/mpesa_callback_controller.dart';
import 'package:kite_bird/controllers/transactions/flutterwave/flutterwave_card.dart';
import 'package:kite_bird/controllers/transactions/kite_wallet/wallet_to_wallet.dart';
import 'package:kite_bird/controllers/transactions/mpesa/mpesa_cb_wallet.dart';
import 'package:kite_bird/kite_bird.dart';

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


  return router;
}