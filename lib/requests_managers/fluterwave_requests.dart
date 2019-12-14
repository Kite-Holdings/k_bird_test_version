import 'package:kite_bird/models/requests_model.dart';
import 'package:pedantic/pedantic.dart';

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
    unawaited(_requestsModel.save());
  }


}