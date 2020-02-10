
import 'package:kite_bird/accounts/models/accounts_models.dart' show AccountModel;
import 'package:kite_bird/kite_bird.dart';
import 'package:kite_bird/response/models/response_models.dart';
import 'package:kite_bird/wallets/models/wallets_models.dart' show WalletActivitiesModel, WalletModel, where;
import 'package:kite_bird/wallets/requests/wallets_requests_manager.dart' show KiteWalletRequests, KiteWalletRequestsType;

class WalletActivitiesController extends ResourceController{
  final AccountModel accountModel = AccountModel();
  final WalletActivitiesModel walletActivitiesModel = WalletActivitiesModel();
  final WalletModel walletModel = WalletModel();

  String _requestId;
  final ResposeType _responseType = ResposeType.transactions;
  ResponsesStatus _responseStatus;
  dynamic _responseBody;

  @Operation.get()
  Future<Response> transactions()async{
    final String _accId = request.authorization.clientID;
    final Map<String, dynamic> _dbResAcc =await accountModel.findById(_accId, fields: ['phoneNo']);
    String _phoneNo;
    if(_dbResAcc['status'] == 0){
      _phoneNo  = _dbResAcc['body']['phoneNo'].toString();
    }
      // save request
    final KiteWalletRequests _kiteWalletRequests = KiteWalletRequests(
      account: _phoneNo,
      kiteWalletRequestsType: KiteWalletRequestsType.walletActivities
    );
    _kiteWalletRequests.normalRequest();
    _requestId = _kiteWalletRequests.requestId();

    // fetch account's wallet
    final Map<String, dynamic> _dbResWalletMap = await walletModel.findOneBy(where.eq('ownerId', _accId), fields: ['walletNo']);
    String _walletNo;
    if(_dbResWalletMap['status'] == 0){
      _walletNo = _dbResWalletMap['body']['walletNo'].toString();
    }

    // fetch transactions
    final Map<String, dynamic> _dbRes = await walletActivitiesModel.findBySelector(
      where.eq('walletNo', _walletNo).sortBy('_id', descending: true)
      );

    if(_dbRes['status'] == 0){
      _responseStatus = ResponsesStatus.success;
      _responseBody = {'body': _dbRes['body']};
    } else {
      _responseStatus = ResponsesStatus.error;
      _responseBody = {'body': 'an error occured'};
    }

    // save response
    final ResponsesModel _responsesModel = ResponsesModel(
      requestId: _requestId,
      responseType: _responseType,
      responseBody: _responseBody,
      status: _responseStatus
    );

    await _responsesModel.save();

    return _responsesModel.sendResponse();


  }

}