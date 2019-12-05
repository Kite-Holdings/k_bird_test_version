import 'package:kite_bird/kite_bird.dart';
import 'package:kite_bird/models/requests_model.dart';
import 'package:kite_bird/models/response_model.dart';
import 'package:kite_bird/models/user_models.dart';
import 'package:kite_bird/requests_managers/base_user_resquests.dart';
import 'package:kite_bird/serializers/users_serializer.dart';

class UserController extends ResourceController{
  UserModel userModel = UserModel();
  @Operation.get()
  Future<Response> getAll()async{
    // save request
    final BaseUserRequests _baseUserRequests = BaseUserRequests(
      account: request.authorization != null ? request.authorization.clientID : null,
      baseUserRequestsType: BaseUserRequestsType.getAll,
      metadata: {
        "function": 'Get all users'
      },
    );
    _baseUserRequests.normalRequest();
    final String _requestId = _baseUserRequests.requestId();

    try{
      final Map<String, dynamic> _dbRes = await userModel.find(where.excludeFields(['password']));
      final dynamic _respBody = _dbRes['status'] == 0 ? _dbRes['body'].length : _dbRes['body'];
      if(_dbRes['status'] == 0){
        return Response.ok(_dbRes);
      } else {
        return Response.badRequest(body: {
          "status": 1,
          "body": 'An error occured!'
        });
      }
    }catch(e){
      return Response.serverError(body: {
        "status": 1,
        "body": 'An error occured!'
      });
    }
    }

  @Operation.get('userId')
  Future<Response> getOne(@Bind.path("userId") String userId)async{
    // Save request 
    final BaseUserRequests _baseUserRequests = BaseUserRequests(
      account: request.authorization != null ? request.authorization.clientID : null,
      baseUserRequestsType: BaseUserRequestsType.getByid,
      metadata: {
        "function": 'Get one users by userId',
        "userId": userId
      },
    );
    _baseUserRequests.normalRequest();
    final String _requestId = _baseUserRequests.requestId();


    try{
      final Map<String, dynamic> _dbRes = await userModel.findById(userId, ['password']);
      if(_dbRes['status'] == 0){
        
        return Response.ok(_dbRes);
      } else {
        return Response.badRequest(body: {"status": 1, "body": "invalid id"});
      }
    } catch (e){
      return Response.serverError(body: {"status": 1, "body": "An error occured!"});
    }
  }

  @Operation.post()
  Future<Response> createUser(@Bind.body(require: ['email', 'password', 'role']) UsersSerializer usersSerializer)async{
    // Save request 
    final BaseUserRequests _baseUserRequests = BaseUserRequests(
      account: request.authorization != null ? request.authorization.clientID : null,
      baseUserRequestsType: BaseUserRequestsType.create,
      metadata: usersSerializer.asMap(),
    );
    _baseUserRequests.normalRequest();
    final String _requestId = _baseUserRequests.requestId();


    // validate email
    if(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(usersSerializer.email)){
      final UserModel _userModel = UserModel(
        email: usersSerializer.email,
        password: usersSerializer.password,
        role: userModel.userRoleFromString(usersSerializer.role.toLowerCase())
      );
      try{
        final Map<String, dynamic> _dbRes = await _userModel.save();
        if(_dbRes['status'] == 0){
          return Response.ok({'status': 0, 'body': "User saved."});
        } else {
          if(_dbRes['body']['code'] == 11000){
            return Response.badRequest(body: {'status': 1, 'body': "email exixts"});
          } else {
            return Response.badRequest(body: {'status': 1, 'body': 'An error occured!'});
          }
        }
      }catch (e){
        return Response.serverError(body: {'status': 1, 'body': 'An error occured!'});
      }
    } else{
      return Response.badRequest(body: {'status': 1, 'body': "invalid email"});
    }

  }

  @Operation.delete('userId')
  Future<Response> delete(@Bind.path("userId") String userId)async{
    // Save request 
    final BaseUserRequests _baseUserRequests = BaseUserRequests(
      account: request.authorization != null ? request.authorization.clientID : null,
      baseUserRequestsType: BaseUserRequestsType.delete,
      metadata: {
        "function": 'Delete one users',
        "userId": userId
      },
    );
    _baseUserRequests.normalRequest();
    final String _requestId = _baseUserRequests.requestId();


    final Map<String, dynamic> _dbRes = await userModel.remove(where.id(ObjectId.parse(userId)));
      if(_dbRes['status'] == 0){
        return Response.ok({"status": 0, "body": "deleted successfully"});
      } else {
        return Response.badRequest(body: {"status": 1, "body": "invalid id"});
      }
  }


}
 class UserFindByController extends ResourceController{
  UserModel userModel = UserModel();
  @Operation.get('email')
  Future<Response> getByNameSelector(@Bind.path("email") String email)async{
    // Save request 
    final BaseUserRequests _baseUserRequests = BaseUserRequests(
      account: request.authorization != null ? request.authorization.clientID : null,
      baseUserRequestsType: BaseUserRequestsType.getByEmail,
      metadata: {
        "function": 'Get one users by email',
        "email": email
      },
    );
    _baseUserRequests.normalRequest();
    final String _requestId = _baseUserRequests.requestId();


    final Map<String, dynamic> _dbRes = await userModel.findBySelector(where.eq('email', email).excludeFields(['password']));
      if(_dbRes['status'] == 0){
        return Response.ok(_dbRes);
      } else {
        return Response.badRequest(body: {"status": 1, "body": "invalid id"});
      }
  }

 } 