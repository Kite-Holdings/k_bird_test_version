import 'package:kite_bird/accounts/models/accounts_models.dart' show where;
import 'package:kite_bird/businesses/models/business_models.dart' show BusinessWalletModel, BusinessStaffModel, BusinessStaffAccountState;
import 'package:kite_bird/businesses/modules/business_modules.dart' show CreateBusinessStaffModule;
import 'package:kite_bird/businesses/request_manager/business_request_manager.dart';
import 'package:kite_bird/businesses/serializers/business_serializers.dart' show AddBusinessStaffSerializer;
import 'package:kite_bird/kite_bird.dart';
import 'package:kite_bird/response/models/response_models.dart';
import 'package:kite_bird/jarvis/modules/jarvis_modules.dart' show jarvisSendSms;

class AddBusinessStaffController extends ResourceController{
  final BusinessWalletModel _businessWalletModel = BusinessWalletModel();
  final BusinessStaffModel _businessStaffModel = BusinessStaffModel();


  String _requestId;
  final ResposeType _responseType = ResposeType.account;
  ResponsesStatus _responseStatus;
  Map<String, dynamic> _responseBody;

  @Operation.post()
  Future<Response> add(@Bind.body(require: ['phoneNo', 'businessCode', 'role']) AddBusinessStaffSerializer addBusinessStaffSerializer)async{
    String _businessId;
    // Save request 
    final BusinessRequest _businessRequest = BusinessRequest(
      account: request.authorization != null ? request.authorization.clientID : null,
      businessRequestsType: BusinessRequestsType.addStaff,
      metadata: {
        "function": 'Add business staff',
        "businessId": request.authorization.clientID,
        "metadata": addBusinessStaffSerializer.asMap()
      },
    );
    _businessRequest.normalRequest();
    _requestId = _businessRequest.requestId();

    // get businessId
    final Map<String, dynamic> _busRes = await _businessWalletModel.findOneBy(
      where.eq('shortCode', addBusinessStaffSerializer.businessCode),
      fields: ['businessId']
    );
    if(_busRes['status'] == 0){
      _businessId = _busRes['body']['businessId'].toString();

    }else{
      _responseStatus = ResponsesStatus.error;
      _responseBody = {"body": "an error occured!"};
      // Save response
      final ResponsesModel _responsesModel = ResponsesModel(requestId: _requestId, responseType: _responseType, status: _responseStatus, responseBody: _responseBody);
      await _responsesModel.save();
      return _responsesModel.sendResponse();
    }

    final CreateBusinessStaffModule createBusinessStaffModule = CreateBusinessStaffModule(
      phoneNo: addBusinessStaffSerializer.phoneNo,
      businessId: _businessId,
      businessStaffRole: _businessStaffModel.businessStaffRoleFromSring(addBusinessStaffSerializer.role),
      accountState: BusinessStaffAccountState.active,
    );

    final bool _added = await createBusinessStaffModule.create();
    if(_added){

      // send notification(sms) to the staff
      await jarvisSendSms(
        phoneNo: addBusinessStaffSerializer.phoneNo,
        body: '''
        You have been added as a staff of business shortcode ${addBusinessStaffSerializer.businessCode},
        with a role of ${addBusinessStaffSerializer.role}
        '''
      );


      _responseStatus = ResponsesStatus.success;
      _responseBody = {"body": "Staff added"};
      // Save response
      final ResponsesModel _responsesModel = ResponsesModel(requestId: _requestId, responseType: _responseType, status: _responseStatus, responseBody: _responseBody);
      await _responsesModel.save();
      return _responsesModel.sendResponse();

    }else{
      _responseStatus = ResponsesStatus.error;
      _responseBody = {"body": "an error occured!"};
      // Save response
      final ResponsesModel _responsesModel = ResponsesModel(requestId: _requestId, responseType: _responseType, status: _responseStatus, responseBody: _responseBody);
      await _responsesModel.save();
      return _responsesModel.sendResponse();
    }

  }

  

}