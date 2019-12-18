import 'package:kite_bird/kite_bird.dart';
import 'package:kite_bird/models/accounts/account_model.dart';
import 'package:kite_bird/models/response_model.dart';
import 'package:kite_bird/models/wallets/wallet_model.dart';
import 'package:kite_bird/models/wallets/wallet_operations.dart';
import 'package:kite_bird/requests_managers/account_request.dart';
import 'package:pedantic/pedantic.dart';

class AccountController extends ResourceController{
  final AccountModel accountModel = AccountModel();
  final WalletModel walletModel = WalletModel();
  final WalletActivitiesModel walletActivitiesModel = WalletActivitiesModel();

  String _requestId;
  final ResposeType _responseType = ResposeType.account;
  ResponsesStatus _responseStatus;
  Map<String, dynamic> _responseBody;
  
  @Operation.get()
  Future<Response> accountDetails()async{
    // Save request 
    final AccountRequest _accountRequest = AccountRequest(
      account: request.authorization != null ? request.authorization.clientID : null,
      accountRequestsType: AccountRequestsType.getDetails,
      metadata: {
        "function": 'Account Details',
        "accountId": request.authorization.clientID
      },
    );
    _accountRequest.normalRequest();
    _requestId = _accountRequest.requestId();

    final  String _accountId = request.authorization.clientID;
    final Map<String, dynamic> _dbRes = await accountModel.findById(_accountId, exclude: ['password']);
    if(_dbRes['status'] == 0){
      _responseStatus = ResponsesStatus.success;
      final _account = _dbRes['body'];
      _responseBody = {"body": _account};
      final Map<String, dynamic> _dbReswallet = await walletModel.findBySelector(
        where.eq('ownerId', _account['_id'].toJson()), exclude: ['cooprateCode', 'ownerId', 'walletType']);
        final Map<String, dynamic> _receivedMap = await walletActivitiesModel.findBySelector(where.eq("operation", "receive"), fields: ['amount']);
        final Map<String, dynamic> _sentMap = await walletActivitiesModel.findBySelector(where.eq("operation", "send"));
        
        double _received = 0;
        double _sent = 0;
        try{
          final dynamic _receivedList = _receivedMap['body'];
          final dynamic _sentList = _sentMap['body'];
          _receivedList.forEach((item){
            try {
              _received += double.parse(item['amount'].toString());
            } catch (e) {
              print(e);
            }
          });
          _sentList.forEach((item){
            try {
              _sent += double.parse(item['amount'].toString());
            } catch (e) {
              print(e);
            }
          });
        } catch(e){
          print(e);
        }

      if(_dbReswallet['status'] == 0){
        _account['received'] = _received;
        _account['sent'] = _sent;
        _account['wallet'] = _dbReswallet['body'];
        _responseBody = {"body": _account};
      }
    } else{
      _responseStatus = ResponsesStatus.error;
      _responseBody = {"body": "an error occured!"};
    }

    // Save response
    final ResponsesModel _responsesModel = ResponsesModel(requestId: _requestId, responseType: _responseType, status: _responseStatus, responseBody: _responseBody);
    unawaited(_responsesModel.save());
    return _responsesModel.sendResponse();
  }
}