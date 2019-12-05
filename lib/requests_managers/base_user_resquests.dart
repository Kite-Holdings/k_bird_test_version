import 'package:kite_bird/models/requests_model.dart';

class BaseUserRequests {
  BaseUserRequests({this.account, this.metadata});
  final String account;
  final dynamic metadata;

  ObjectId id = ObjectId();
  String _url = '/users';
  String requestId() => id.toJson();
  final RequestType _requestType = RequestType.baseUser;

  void normalRequest(){
    final RequestsModel _requestsModel = RequestsModel(
      id: id,
      url: _url,
      requestType: _requestType,
      account: account,
      metadata: metadata
    );
    _requestsModel.save();
  }

  void loginRequest(){
    _url = '/users/login';
    final RequestsModel _requestsModel = RequestsModel(
      id: id,
      url: _url,
      requestType: _requestType,
      account: account,
      metadata: metadata
    );
    _requestsModel.save();
  }

  // token
}
