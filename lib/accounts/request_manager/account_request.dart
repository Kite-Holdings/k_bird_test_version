import 'package:kite_bird/requests/models/requests_models.dart' show 
        ObjectId, RequestMethod, RequestsModel, RequestType;

class AccountRequest{
  AccountRequest({this.account, this.accountRequestsType, this.metadata});


  final String account;
  final dynamic metadata;
  final AccountRequestsType accountRequestsType;

  ObjectId id = ObjectId();
  String _url = '/account';
  String requestId() => id.toJson();
  RequestMethod _requestMethod = RequestMethod.getmethod;
  final RequestType _requestType = RequestType.account;

    void normalRequest()async{
    switch (accountRequestsType) {
      case AccountRequestsType.registerConsumer:
        _requestMethod = RequestMethod.postMethod;
        _url = '/account/consumer/register';
        break;
      case AccountRequestsType.getDetails:
        _requestMethod = RequestMethod.getmethod;
        _url = '/account';
        break;
      case AccountRequestsType.registerMerchant:
        _requestMethod = RequestMethod.postMethod;
        _url = '/account/merchant';
        break;
      case AccountRequestsType.delete:
        _requestMethod = RequestMethod.deleteMethod;
        _url = '/account/:accountId';
        break;
      case AccountRequestsType.getAll:
        _requestMethod = RequestMethod.getmethod;
        break;
        case AccountRequestsType.getByPhoneNo:
        _requestMethod = RequestMethod.getmethod;
        _url = '/account/phoneNo/:phoneNo';
        break;
      case AccountRequestsType.getByid:
        _requestMethod = RequestMethod.getmethod;
        _url = '/account/:accountId';
        break;
       case AccountRequestsType.login:
        _requestMethod = RequestMethod.getmethod;
        _url = '/account/login';
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

enum AccountRequestsType{
  delete,
  getAll,
  getByid,
  getByPhoneNo,
  getDetails,
  login,
  registerConsumer,
  registerMerchant,
  verifyPhoneNo,
  
}