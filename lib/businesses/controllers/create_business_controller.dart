import 'package:kite_bird/accounts/models/accounts_models.dart' show AccountModel;
import 'package:kite_bird/businesses/modules/business_modules.dart' show 
    CreateBussinessModule, 
    CreateBusinessStaffModule, BusinessStaffAccountState, BusinessStaffRole 
    ;
import 'package:kite_bird/businesses/request_manager/business_request_manager.dart';
import 'package:kite_bird/businesses/serializers/business_serializers.dart' show CreateBusinessSerializer;
import 'package:kite_bird/kite_bird.dart';
import 'package:kite_bird/response/models/response_models.dart';

class CreateBusinessController extends ResourceController{
  final AccountModel accountModel = AccountModel();

  String _requestId;
  final ResposeType _responseType = ResposeType.account;
  ResponsesStatus _responseStatus;
  Map<String, dynamic> _responseBody;


  @Operation.post()
  Future<Response> create(@Bind.body(require: ['name', 'uid']) CreateBusinessSerializer createBusinessSerializer)async{
    String _cooprateCode;
    String _phoneNo;
    // Save request 
    final BusinessRequest _businessRequest = BusinessRequest(
      account: request.authorization != null ? request.authorization.clientID : null,
      businessRequestsType: BusinessRequestsType.create,
      metadata: {
        "function": 'Create Business',
        "businessId": request.authorization.clientID,
        "metadata": createBusinessSerializer.asMap()
      },
    );
    _businessRequest.normalRequest();
    _requestId = _businessRequest.requestId();

    // user id
    final  String _userId = request.authorization.clientID;
    final Map<String, dynamic> _accDbRes = await accountModel.findById(_userId, fields: ['cooprateCode', 'phoneNo']);
    if(_accDbRes['status'] == 0){
      _cooprateCode = _accDbRes['body']['cooprateCode'].toString();
      _phoneNo = _accDbRes['body']['phoneNo'].toString();

    }else{
      _responseStatus = ResponsesStatus.error;
      _responseBody = {"body": "an error occured!"};
      // Save response
      final ResponsesModel _responsesModel = ResponsesModel(requestId: _requestId, responseType: _responseType, status: _responseStatus, responseBody: _responseBody);
      await _responsesModel.save();
      return _responsesModel.sendResponse();
    }

    // create
    final CreateBussinessModule createBussinessModule = CreateBussinessModule(
      name: createBusinessSerializer.name,
      cooprateCode: _cooprateCode,
      uid: createBusinessSerializer.uid
    );

    final bool created = await createBussinessModule.create();
    if(created){
      // create user as staff
      final CreateBusinessStaffModule _createBusinessStaffModule = CreateBusinessStaffModule(
        phoneNo: _phoneNo,
        businessId: createBussinessModule.businessId.toJson(),
        accountState: BusinessStaffAccountState.active,
        businessStaffRole: BusinessStaffRole.admin,
      );

      final bool _userAdded = await _createBusinessStaffModule.create();
      if(_userAdded){
        final Map<String, dynamic> _business = {
          'businessName': createBusinessSerializer.name,
          'shortCode': createBussinessModule.walletShortCode,
        };
        _responseStatus = ResponsesStatus.success;
        _responseBody = {"body": _business};
        // Save response
        final ResponsesModel _responsesModel = ResponsesModel(requestId: _requestId, responseType: _responseType, status: _responseStatus, responseBody: _responseBody);
        await _responsesModel.save();
        return _responsesModel.sendResponse();

      }else{
        _responseStatus = ResponsesStatus.warning;
        _responseBody = {"body": "Adding user as staff failed"};
        // Save response
        final ResponsesModel _responsesModel = ResponsesModel(requestId: _requestId, responseType: _responseType, status: _responseStatus, responseBody: _responseBody);
        await _responsesModel.save();
        return _responsesModel.sendResponse();
      }

    }else{
      _responseStatus = ResponsesStatus.failed;
      _responseBody = {"body": "Creating business failed"};
      // Save response
      final ResponsesModel _responsesModel = ResponsesModel(requestId: _requestId, responseType: _responseType, status: _responseStatus, responseBody: _responseBody);
      await _responsesModel.save();
      return _responsesModel.sendResponse();
    }

  }
}