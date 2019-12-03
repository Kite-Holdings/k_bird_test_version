import 'package:kite_bird/kite_bird.dart';
import 'package:kite_bird/models/cooprate_model.dart';
import 'package:kite_bird/models/requests_model.dart';
import 'package:kite_bird/models/response_model.dart';
import 'package:kite_bird/models/token_model.dart';
import 'package:kite_bird/models/user_models.dart';

class CooprateTokenController extends ResourceController{
  TokenModel tokenModel = TokenModel();
  static int duration = 300; // 300 seconds for 5 mins
  final int _validTill = (DateTime.now().millisecondsSinceEpoch/1000 + duration).floor();

  @Operation.get()
  Future<Response> getCooprateToken()async{
    final String _collection = cooprateCollection;
    final String _ownerId = request.authorization.clientID;
    final TokenModel _tokenModel = TokenModel(
      collection: _collection,
      ownerId: _ownerId,
      validTill: _validTill,
    );

    final Map<String, dynamic> _dbRes = await _tokenModel.save();

    final CooprateModel _cooprateModel = CooprateModel();
    final Map<String, dynamic> _cooprateMap = await _cooprateModel.findById(request.authorization.clientID.toString());
    final _cooprate = _cooprateMap['body'];

     // Save Request 
      final ObjectId _requestId = ObjectId();
        final RequestsModel _requestsModel = RequestsModel(
          id: _requestId,
          url: '/cooprate/token',
          requestType: RequestType.token,
          account: _cooprate['consumerKey'].toString(),
          metadata: {
            'clientId': request.authorization.clientID,
            'entity': 'user'
          }
        );

        unawaited(_requestsModel.save());

    if(_dbRes['status'] == 0){
      // Save Response
        final ResponsesModel _responsesModel = ResponsesModel(
          requestId: _requestId.toJson(),
          responseType: ResposeType.token,
          responseBody: {
            "status": 0,
            "body": {
              "token": _tokenModel.token,
              "validTill": _validTill,
            }
          },
          status: ResponsesStatus.success
        );
        unawaited(_responsesModel.save());

        return Response.ok({
          "status": 0,
          "body": {
            "token": _tokenModel.token,
            "validTill": _validTill,
          }
        });
    } else {
      // Save Response
      final ResponsesModel _responsesModel = ResponsesModel(
        requestId: _requestId.toJson(),
        responseType: ResposeType.token,
        responseBody: {"status": 1, "body": "an error occured."},
        status: ResponsesStatus.failed
      );
      unawaited(_responsesModel.save());
      return Response.badRequest(body: {"status": 1, "body": "an error occured."});
    }
    
  }  
    
}


class BaseUserTokenController extends ResourceController{
  TokenModel tokenModel = TokenModel();
  static int duration = 300; // 300 seconds for 5 mins
  final int _validTill = (DateTime.now().millisecondsSinceEpoch/1000 + duration).floor();

  @Operation.get()
  Future<Response> getBaseUserToken()async{
    final String _collection = baseUserCollection;
    final String _ownerId = request.authorization.clientID;
    final TokenModel _tokenModel = TokenModel(
      collection: _collection,
      ownerId: _ownerId,
      validTill: _validTill,
    );

    final Map<String, dynamic> _dbRes = await _tokenModel.save();

    final UserModel _userModel = UserModel();
    final Map<String, dynamic> _userMap = await _userModel.findById(request.authorization.clientID.toString());
    final _user = _userMap['body'];

    // Save Request 
      final ObjectId _requestId = ObjectId();
        final RequestsModel _requestsModel = RequestsModel(
          id: _requestId,
          url: '/users/login',
          requestType: RequestType.token,
          account: _user['email'].toString(),
          metadata: {
            'clientId': request.authorization.clientID,
            'entity': 'user'
          }
        );

        unawaited(_requestsModel.save());

    if(_dbRes['status'] == 0){
      
        // Save Response
        final ResponsesModel _responsesModel = ResponsesModel(
          requestId: _requestId.toJson(),
          responseType: ResposeType.token,
          responseBody: {
            "status": 0,
            "body": {
              "token": _tokenModel.token,
              "validTill": _validTill,
            }
          },
          status: ResponsesStatus.success
        );
        unawaited(_responsesModel.save());


        return Response.ok({
          "status": 0,
          "body": {
            "token": _tokenModel.token,
            "validTill": _validTill,
          }
        });
    } else {
      // Save Response
      final ResponsesModel _responsesModel = ResponsesModel(
        requestId: _requestId.toJson(),
        responseType: ResposeType.token,
        responseBody: {"status": 1, "body": "an error occured."},
        status: ResponsesStatus.failed
      );
      unawaited(_responsesModel.save());
      return Response.badRequest(body: {"status": 1, "body": "an error occured."});
    }
    
  }
    
}

