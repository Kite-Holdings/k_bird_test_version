import 'package:kite_bird/requests/models/requests_models.dart' show 
        ObjectId, RequestMethod, RequestsModel, RequestType;

class BankRequest{
  BankRequest({this.account, this.metadata, this.bankRequestsType});
  final String account;
  final dynamic metadata;
  final BankRequestsType bankRequestsType;

  ObjectId id = ObjectId();
  String _url;
  String requestId() => id.toJson();
  RequestMethod _requestMethod = RequestMethod.postMethod;
  final RequestType _requestType = RequestType.mpesaStkPush;

  void normalRequest()async{
    switch (bankRequestsType) {
      case BankRequestsType.ift:
        _requestMethod = RequestMethod.postMethod;
        _url = '/transactions/bank/ift';
        break;
      case BankRequestsType.pesalink:
        _requestMethod = RequestMethod.postMethod;
        _url = '/transactions/bank/pesalink';
        break;
      case BankRequestsType.mpesa:
        _requestMethod = RequestMethod.postMethod;
        _url = '/transactions/bank/mpesa';
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

enum BankRequestsType{
  pesalink,
  ift,
  mpesa,
}