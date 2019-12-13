import 'package:kite_bird/models/requests_model.dart';
import 'package:pedantic/pedantic.dart';

class KiteWalletRequests{
  KiteWalletRequests({this.account, this.metadata, this.kiteWalletRequestsType});
  final String account;
  final dynamic metadata;
  final KiteWalletRequestsType kiteWalletRequestsType;

  ObjectId id = ObjectId();
  String _url;
  String requestId() => id.toJson();
  RequestMethod _requestMethod;
  final RequestType _requestType = RequestType.wallet;

  void normalRequest()async{
    switch (kiteWalletRequestsType) {
      case KiteWalletRequestsType.balance:
        _requestMethod = RequestMethod.getmethod;
        _url = '/transactions/wallet/balance';
        break;
      case KiteWalletRequestsType.walletToWallet:
        _requestMethod = RequestMethod.postMethod;
        _url = '/transactions/walletToWallet';
        break;
        default:
    }

    final RequestsModel _requestsModel = RequestsModel(
      id: id,
      url: _url,
      requestType: _requestType,
      requestMethod: _requestMethod,
      account: account,
      metadata: metadata
    );
    unawaited(_requestsModel.save());
  }


}

enum KiteWalletRequestsType{
  balance,
  walletToWallet,
  
}