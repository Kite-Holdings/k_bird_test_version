import 'package:kite_bird/accounts/models/accounts_models.dart' show AccountModel;
import 'package:kite_bird/accounts/request_manager/accounts_request_manager.dart';
import 'package:kite_bird/kite_bird.dart';
import 'package:kite_bird/response/models/response_models.dart';
import 'package:kite_bird/wallets/models/wallets_models.dart' show WalletModel, WalletActivitiesModel, where;

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
        String _walletNo;
        try {
          _walletNo = _dbReswallet['body'][0]['walletNo'].toString();
        } catch (e) {
          print(e);
        }
        final Map<String, dynamic> _receivedMap = await walletActivitiesModel.findBySelector(where.eq("walletNo", _walletNo).and(where.eq("operation", "receive")), fields: ['amount']);
        final Map<String, dynamic> _sentMap = await walletActivitiesModel.findBySelector(where.eq("walletNo", _walletNo).and(where.eq("operation", "send")), fields: ['amount']);
        
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
    await _responsesModel.save();
    return _responsesModel.sendResponse();
  }
}