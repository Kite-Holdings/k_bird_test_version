import 'package:kite_bird/accounts/models/accounts_models.dart' show AccountModel;
import 'package:kite_bird/accounts/request_manager/accounts_request_manager.dart';
import 'package:kite_bird/kite_bird.dart';
import 'package:kite_bird/response/models/response_models.dart';
import 'package:kite_bird/token/models/token_model.dart' show TokenModel, accountsCollection;

class AccountLoginController extends ResourceController{
  final AccountModel accountModel = AccountModel();
  static int duration = 300; // 300 seconds for 5 mins
  final int _validTill = (DateTime.now().millisecondsSinceEpoch/1000 + duration).floor();
  String _requestId;
  final ResposeType _responseType = ResposeType.account;
  ResponsesStatus _responseStatus;
  Map<String, dynamic> _responseBody;

  @Operation.get()
  Future<Response> getOtpToken()async{
    // Save request 
    final Map<String, dynamic> _dbResAcc =await accountModel.findById(request.authorization.clientID, fields: ['phoneNo']);
    String _phoneNo;
    if(_dbResAcc['status'] == 0){
      _phoneNo  = _dbResAcc['body']['phoneNo'].toString();
    }
    final AccountRequest _accountRequest = AccountRequest(
      account: _phoneNo,
      accountRequestsType: AccountRequestsType.login,
      metadata: {
        "function": 'Account Login',
        "accountId": _phoneNo
      },
    );
    _accountRequest.normalRequest();
    _requestId = _accountRequest.requestId();

    const String _collection = accountsCollection;
    final String _ownerId = request.authorization.clientID;
    final TokenModel _tokenModel = TokenModel(
      collection: _collection,
      ownerId: _ownerId,
      validTill: _validTill,
    );

    final Map<String, dynamic> _dbRes = await _tokenModel.save();

    if(_dbRes['status'] == 0){
      _responseStatus = ResponsesStatus.success;
      _responseBody = {
          "body": {
            "token": _tokenModel.token,
            "validTill": _validTill,
          }
        };
    } else {
      _responseStatus = ResponsesStatus.error;
      _responseBody = {"body": "an error occured."};
    }
    // Save response
    final ResponsesModel _responsesModel = ResponsesModel(requestId: _requestId, responseType: _responseType, status: _responseStatus, responseBody: _responseBody);
    await _responsesModel.save();
    return _responsesModel.sendResponse(_responseBody);

  }
}