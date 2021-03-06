import 'package:kite_bird/base_user/models/base_user_models.dart';
import 'package:kite_bird/base_user/requests/requests_manager.dart';
import 'package:kite_bird/base_user/serializers/base_user_serializers.dart';
import 'package:kite_bird/kite_bird.dart';
import 'package:kite_bird/response/models/response_models.dart';

class UserController extends ResourceController{
  UserModel userModel = UserModel();

  String _requestId;
  final ResposeType _responseType = ResposeType.baseUser;
  ResponsesStatus _responseStatus;
  dynamic _responseBodyModel;
  Map<String, dynamic> _responseBody;

  @Operation.get()
  Future<Response> getAll()async{
    String _email;
    final Map<String, dynamic> _dbResUser = await userModel.findById(request.authorization.clientID, fields: ['email']);
    if(_dbResUser['status'] == 0){
      _email  = _dbResUser['body']['email'].toString();
    }
    // save request
    final BaseUserRequests _baseUserRequests = BaseUserRequests(
      account: _email,
      baseUserRequestsType: BaseUserRequestsType.getAll,
      metadata: {
        "function": 'Get all users'
      },
    );
    _baseUserRequests.normalRequest();
    _requestId = _baseUserRequests.requestId();

    try{
      final Map<String, dynamic> _dbRes = await userModel.find(where.excludeFields(['password']));
      _responseBodyModel = {
        'body': _dbRes['status'] == 0 ? _dbRes['body'].length : _dbRes['body'],
      };
      _responseBody = _dbRes;
      

      if(_dbRes['status'] == 0){
        _responseStatus = ResponsesStatus.success;
        _responseBody = _dbRes;
        
      } else {
        _responseBody = {"body": 'An error occured!'};
        _responseStatus = ResponsesStatus.failed;
      }
    }catch(e){
      _responseBody = {"body": 'An error occured!'};
      _responseStatus = ResponsesStatus.error;
    }
    // Save response
    final ResponsesModel _responsesModel = ResponsesModel(requestId: _requestId, responseType: _responseType, status: _responseStatus, responseBody: _responseBodyModel != null ? _responseBodyModel : _responseBody);
    await _responsesModel.save();
    return _responsesModel.sendResponse(_responseBody);
    }

  @Operation.get('userId')
  Future<Response> getOne(@Bind.path("userId") String userId)async{
    String _email;
    final Map<String, dynamic> _dbResUser = await userModel.findById(request.authorization.clientID, fields: ['email']);
    if(_dbResUser['status'] == 0){
      _email  = _dbResUser['body']['email'].toString();
    }
    // Save request 
    final BaseUserRequests _baseUserRequests = BaseUserRequests(
      account: _email,
      baseUserRequestsType: BaseUserRequestsType.getByid,
      metadata: {
        "function": 'Get one users by userId',
        "userId": userId
      },
    );
    _baseUserRequests.normalRequest();
    _requestId = _baseUserRequests.requestId();


    try{
      final Map<String, dynamic> _dbRes = await userModel.findById(userId, exclude: ['password']);
      if(_dbRes['status'] == 0){
        _responseStatus = ResponsesStatus.success;
        _responseBody = _dbRes;
      } else {
        _responseStatus = ResponsesStatus.failed;
        _responseBody =  {"body": "invalid id"};
      }
    } catch (e){
      _responseStatus = ResponsesStatus.error;
      _responseBody = {"body": "An error occured!"};
    }
    // Save response
    final ResponsesModel _responsesModel = ResponsesModel(requestId: _requestId, responseType: _responseType, status: _responseStatus, responseBody: _responseBodyModel != null ? _responseBodyModel : _responseBody);
    await _responsesModel.save();
    return _responsesModel.sendResponse(_responseBody);
  }

  @Operation.post()
  Future<Response> createUser(@Bind.body(require: ['email', 'password', 'role']) UsersSerializer usersSerializer)async{
    String _email;
    // final Map<String, dynamic> _dbResUser = await userModel.findById(request.authorization.clientID, fields: ['email']);
    // if(_dbResUser['status'] == 0){
    //   _email  = _dbResUser['body']['email'].toString();
    // }
    // Save request 
    final BaseUserRequests _baseUserRequests = BaseUserRequests(
      account: _email,
      baseUserRequestsType: BaseUserRequestsType.create,
      metadata: usersSerializer.asMap(),
    );
    _baseUserRequests.normalRequest();
    _requestId = _baseUserRequests.requestId();


    final UserModel _userModel = UserModel(
      email: usersSerializer.email,
      password: usersSerializer.password,
      role: userModel.userRoleFromString(usersSerializer.role.toLowerCase())
    );
    try{
      final Map<String, dynamic> _dbRes = await _userModel.save();
      if(_dbRes['status'] == 0){
        _responseStatus = ResponsesStatus.success;
        _responseBody = {'body': "User saved."};
      } else {
        if(_dbRes['body']['code'] == 11000){
          _responseStatus = ResponsesStatus.warning;
          _responseBody = {'body': "email exixts"};
        } else {
          _responseStatus = ResponsesStatus.error;
          _responseBody = {'body': 'An error occured!'};
        }
      }
    }catch (e){
      _responseStatus = ResponsesStatus.error;
      _responseBody =  {'body': 'An error occured!'};
    }

    // Save response
    final ResponsesModel _responsesModel = ResponsesModel(requestId: _requestId, responseType: _responseType, status: _responseStatus, responseBody: _responseBodyModel != null ? _responseBodyModel : _responseBody);
    await _responsesModel.save();
    return _responsesModel.sendResponse(_responseBody);

  }

  @Operation.delete('userId')
  Future<Response> delete(@Bind.path("userId") String userId)async{
    String _email;
    final Map<String, dynamic> _dbResUser = await userModel.findById(request.authorization.clientID, fields: ['email']);
    if(_dbResUser['status'] == 0){
      _email  = _dbResUser['body']['email'].toString();
    }
    // Save request 
    final BaseUserRequests _baseUserRequests = BaseUserRequests(
      account: _email,
      baseUserRequestsType: BaseUserRequestsType.delete,
      metadata: {
        "function": 'Delete one users',
        "userId": userId
      },
    );
    _baseUserRequests.normalRequest();
    _requestId = _baseUserRequests.requestId();


    final Map<String, dynamic> _dbRes = await userModel.remove(where.id(ObjectId.parse(userId)));
      if(_dbRes['status'] == 0){
        _responseStatus = ResponsesStatus.success;
        _responseBody = {"body": "deleted successfully"};
      } else {
        _responseStatus = ResponsesStatus.success;
        _responseBody = {"body": "invalid id"};
      }
    // Save response
    final ResponsesModel _responsesModel = ResponsesModel(requestId: _requestId, responseType: _responseType, status: _responseStatus, responseBody: _responseBodyModel != null ? _responseBodyModel : _responseBody);
    await _responsesModel.save();
    return _responsesModel.sendResponse(_responseBody);
  }


}
 class UserFindByController extends ResourceController{
  UserModel userModel = UserModel();

  String _requestId;
  final ResposeType _responseType = ResposeType.baseUser;
  ResponsesStatus _responseStatus;
  dynamic _responseBodyModel;
  Map<String, dynamic> _responseBody;


  @Operation.get('email')
  Future<Response> getByNameSelector(@Bind.path("email") String email)async{
    String _email;
    final Map<String, dynamic> _dbResUser = await userModel.findById(request.authorization.clientID, fields: ['email']);
    if(_dbResUser['status'] == 0){
      _email  = _dbResUser['body']['email'].toString();
    }
    // Save request 
    final BaseUserRequests _baseUserRequests = BaseUserRequests(
      account: _email,
      baseUserRequestsType: BaseUserRequestsType.getByEmail,
      metadata: {
        "function": 'Get one users by email',
        "email": email
      },
    );
    _baseUserRequests.normalRequest();
    _requestId = _baseUserRequests.requestId();


    final Map<String, dynamic> _dbRes = await userModel.findBySelector(where.eq('email', email).excludeFields(['password']));
      if(_dbRes['status'] == 0){
        _responseStatus = ResponsesStatus.success;
        _responseBody = _dbRes;
      } else {
        _responseStatus = ResponsesStatus.success;
        _responseBody = {"body": "invalid id"};
      }
      // Save response
      final ResponsesModel _responsesModel = ResponsesModel(requestId: _requestId, responseType: _responseType, status: _responseStatus, responseBody: _responseBodyModel != null ? _responseBodyModel : _responseBody);
      await _responsesModel.save();
      return _responsesModel.sendResponse(_responseBody);
  }

 } 