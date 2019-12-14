import 'package:kite_bird/kite_bird.dart';
import 'package:kite_bird/models/accounts/account_model.dart';
import 'package:kite_bird/models/response_model.dart';
import 'package:kite_bird/models/wallets/wallet_model.dart';
import 'package:kite_bird/models/wallets/wallet_operations.dart';
import 'package:kite_bird/requests_managers/kite_wallet_requests.dart';
import 'package:kite_bird/serializers/kite_wallet/wallet_to_wallet_serializer.dart';

class WalletToWalletController extends ResourceController{
  final AccountModel accountModel = AccountModel();
  final WalletModel walletModel = WalletModel();

  String _requestId;
  final ResposeType _responseType = ResposeType.mpesaStkPush;
  ResponsesStatus _responseStatus;
  dynamic _responseBody;

  @Operation.post()
  Future<Response> transact(@Bind.body(require: ['amount', 'recipientNo']) WalletToWalletSerializer walletToWalletSerializer)async{
    final Map<String, dynamic> _dbResAcc =await accountModel.findById(request.authorization.clientID, fields: ['phoneNo']);
    String _phoneNo;
    if(_dbResAcc['status'] == 0){
      _phoneNo  = _dbResAcc['body']['phoneNo'].toString();
    }
    final Map<String, dynamic> _dbWallet = await walletModel.findOneBy(where.eq("ownerId", request.authorization.clientID), fields: ['walletNo']);
    String _walletNo;
    if(_dbWallet['status'] == 0){
      _walletNo = _dbWallet['body']['walletNo'].toString();
    }
    // save request
    final KiteWalletRequests kiteWalletRequests = KiteWalletRequests(
      account: _phoneNo,
      kiteWalletRequestsType: KiteWalletRequestsType.walletToWallet,
      metadata: {
        "walletNo": _walletNo,
        "recipientNo": walletToWalletSerializer.recipientNo,
        "amount": walletToWalletSerializer.amount,
      }
    );
    kiteWalletRequests.normalRequest();
    _requestId = kiteWalletRequests.requestId();

    // check if recipient exist
    final bool walletExist =await walletModel.exists(where.eq('walletNo', walletToWalletSerializer.recipientNo));

    if(!walletExist){
      _responseStatus = ResponsesStatus.failed;
      _responseBody = {"body": "Recipient Account does not exist"};
    } else{
      //  Transact
      final WalletOperations walletOperations = WalletOperations(
        amount: walletToWalletSerializer.amount,
        recipient: walletToWalletSerializer.recipientNo,
        sender: _walletNo
      );
      // TODO: save transaction
      if(await walletOperations.withdraw()){
        if(await walletOperations.deposit()){
          _responseStatus = ResponsesStatus.success;
          _responseBody = {"body": "Transaction successful"};
        } else{
          _responseStatus = ResponsesStatus.error;
          _responseBody = {"body": "Depositing to recipient failed!"};
        }
      } else{
        final Map<String, dynamic> _dbResWalletBalance = await walletModel.findOneBy(where.eq('walletNo', _walletNo), fields: ['balance']);
        if(_dbResWalletBalance['status'] == 0){
          if(double.parse(_dbResWalletBalance['body']['balance'].toString()) < walletToWalletSerializer.amount){
            _responseStatus = ResponsesStatus.failed;
            _responseBody = {"body": "Insuficient balance!"};
          } else {
            _responseStatus = ResponsesStatus.error;
            _responseBody = {"body": "An error occured"};
          }
        }else{
          _responseStatus = ResponsesStatus.error;
          _responseBody = {"body": "Getting account balance!"};
        }
      }

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