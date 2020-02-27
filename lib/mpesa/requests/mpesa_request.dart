import 'package:kite_bird/requests/models/requests_models.dart' show 
        ObjectId, RequestMethod, RequestsModel, RequestType;

class MpesaRequest{
  MpesaRequest({this.account, this.metadata, this.mpesaRequestsType});
  final String account;
  final dynamic metadata;
  final MpesaRequestsType mpesaRequestsType;

  ObjectId id = ObjectId();
  String _url;
  String requestId() => id.toJson();
  RequestMethod _requestMethod = RequestMethod.postMethod;
  final RequestType _requestType = RequestType.mpesaStkPush;

  void normalRequest()async{
    switch (mpesaRequestsType) {
      case MpesaRequestsType.bc:
        _requestMethod = RequestMethod.postMethod;
        _url = '/transactions/mpesa/bc';
        break;
      case MpesaRequestsType.stkPush:
        _requestMethod = RequestMethod.postMethod;
        _url = '/transactions/mpesa/cb';
        break;
      
      case MpesaRequestsType.stkQuery:
        _requestMethod = RequestMethod.postMethod;
        _url = '/transactions/mpesa/stkQuery';
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

enum MpesaRequestsType{
  stkPush,
  stkQuery,
  bc
}