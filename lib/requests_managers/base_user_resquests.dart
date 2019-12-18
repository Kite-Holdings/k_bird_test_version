import 'package:kite_bird/models/requests_model.dart';

class BaseUserRequests {
  BaseUserRequests({this.account, this.metadata, this.baseUserRequestsType});
  final String account;
  final dynamic metadata;
  final BaseUserRequestsType baseUserRequestsType;

  ObjectId id = ObjectId();
  String _url = '/users';
  String requestId() => id.toJson();
  RequestMethod _requestMethod = RequestMethod.getmethod;
  final RequestType _requestType = RequestType.baseUser;

  void normalRequest()async{
    switch (baseUserRequestsType) {
      case BaseUserRequestsType.create:
        _requestMethod = RequestMethod.postMethod;
        break;
      case BaseUserRequestsType.delete:
        _requestMethod = RequestMethod.deleteMethod;
        _url = '/users/:userId';
        break;
      case BaseUserRequestsType.getAll:
        _requestMethod = RequestMethod.getmethod;
        break;
        case BaseUserRequestsType.getByEmail:
        _requestMethod = RequestMethod.getmethod;
        _url = '/users/email/:email';
        break;
      case BaseUserRequestsType.getByid:
        _requestMethod = RequestMethod.getmethod;
        _url = '/users/:userId';
        break;
       case BaseUserRequestsType.login:
        _requestMethod = RequestMethod.getmethod;
        _url = '/users/login';
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
enum BaseUserRequestsType{
  create,
  getAll,
  getByid,
  getByEmail,
  delete,
  login
}