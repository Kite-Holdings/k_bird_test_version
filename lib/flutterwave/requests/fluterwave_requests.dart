import 'package:kite_bird/requests/models/requests_models.dart' show 
        ObjectId, RequestMethod, RequestsModel, RequestType;
        
class FlutterwaveRequests{
  FlutterwaveRequests({this.account, this.metadata});
  final String account;
  final dynamic metadata;

  ObjectId id = ObjectId();
  final String _url = '/transactions/cardToWallet';
  String requestId() => id.toJson();
  final RequestMethod _requestMethod = RequestMethod.postMethod;
  final RequestType _requestType = RequestType.mpesaStkPush;

  void normalRequest()async{
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