import 'package:kite_bird/kite_bird.dart';
import 'package:kite_bird/models/response_model.dart';

class RegisterAccountVerificationController extends ResourceController{
  // String _requestId;
  // final ResposeType _responseType = ResposeType.baseUser;
  ResponsesStatus _responseStatus;
  // dynamic _responseBodyModel;
  Map<String, dynamic> _responseBody;

  
  @Operation.post()
  Future<Response> confirmPhoneNo()async{
    _responseStatus = ResponsesStatus.success;
    _responseBody = {"jss": "xnx"};
    print(await request.body.decode());
    final ResponsesModel _responsesModel = ResponsesModel(responseBody: _responseBody, status: _responseStatus);
    return _responsesModel.sendResponse();
  }
}