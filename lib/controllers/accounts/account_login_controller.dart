import 'package:kite_bird/kite_bird.dart';
import 'package:kite_bird/models/response_model.dart';
import 'package:kite_bird/models/token_model.dart';
import 'package:kite_bird/requests_managers/account_request.dart';
import 'package:pedantic/pedantic.dart';

class AccountLoginController extends ResourceController{
  static int duration = 300; // 300 seconds for 5 mins
  final int _validTill = (DateTime.now().millisecondsSinceEpoch/1000 + duration).floor();
  String _requestId;
  final ResposeType _responseType = ResposeType.account;
  ResponsesStatus _responseStatus;
  Map<String, dynamic> _responseBody;

  @Operation.get()
  Future<Response> getOtpToken()async{
    // Save request 
    final AccountRequest _accountRequest = AccountRequest(
      account: request.authorization != null ? request.authorization.clientID : null,
      accountRequestsType: AccountRequestsType.verifyOtp,
      metadata: {
        "function": 'Account Login',
        "accountId": request.authorization.clientID
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
    unawaited(_responsesModel.save());
    return _responsesModel.sendResponse(_responseBody);

  }
}