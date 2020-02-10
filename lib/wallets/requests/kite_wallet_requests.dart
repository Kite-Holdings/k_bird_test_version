import 'package:kite_bird/requests/models/requests_models.dart' show 
        ObjectId, RequestMethod, RequestsModel, RequestType;

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
      case KiteWalletRequestsType.walletActivities:
        _requestMethod = RequestMethod.getmethod;
        _url = '/transactions/walletActivities';
        break;
      case KiteWalletRequestsType.transactions:
        _requestMethod = RequestMethod.getmethod;
        _url = '/transactions';
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
    await _requestsModel.save();
  }


}

enum KiteWalletRequestsType{
  balance,
  walletToWallet,
  walletActivities,
  transactions,
  
}