import 'package:kite_bird/kite_bird.dart';
import 'package:kite_bird/models/requests_model.dart';
import 'package:kite_bird/models/response_model.dart';
import 'package:kite_bird/models/user_models.dart';
import 'package:kite_bird/serializers/users_serializer.dart';

class UserController extends ResourceController{
  UserModel userModel = UserModel();
  @Operation.get()
  Future<Response> getAll()async{
    return Response.ok(await userModel.find(where.excludeFields(['password'])));
    }

  @Operation.get('userId')
  Future<Response> getOne(@Bind.path("userId") String userId)async{
      final Map<String, dynamic> _dbRes = await userModel.findById(userId, ['password']);
      if(_dbRes['status'] == 0){
        // Save request and response
        final ObjectId _requestId = ObjectId();
        final RequestsModel _requestsModel = RequestsModel(
          id: _requestId,
          url: '/cooprate/token',
          requestType: RequestType.token,
          account: _aouthDetails[0],
          metadata: {
            'clientId': _id,
            'entity': 'user'
          }
        );

        unawaited(_requestsModel.save());

        final ResponsesModel _responsesModel = ResponsesModel(
          requestId: _requestId.toJson(),
          responseType: ResposeType.token,
          responseBody: {"message": "Wrong Consumer Key"},
          status: ResponsesStatus.failed
        );
        unawaited(_responsesModel.save());

        return Response.ok(_dbRes);
      } else {
        return Response.badRequest(body: {"status": 1, "body": "invalid id"});
      }
  }

  @Operation.post()
  Future<Response> createUser(@Bind.body(require: ['email', 'password', 'role']) UsersSerializer usersSerializer)async{
    // validate email
    if(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(usersSerializer.email)){
      final UserModel _userModel = UserModel(
        email: usersSerializer.email,
        password: usersSerializer.password,
        role: userModel.userRoleFromString(usersSerializer.role.toLowerCase())
      );
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
    } else{
      return Response.badRequest(body: {'status': 1, 'body': "invalid email"});
    }

  }

  @Operation.delete('userId')
  Future<Response> delete(@Bind.path("userId") String userId)async{
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
    final Map<String, dynamic> _dbRes = await userModel.findBySelector(where.eq('email', email).excludeFields(['password']));
      if(_dbRes['status'] == 0){
        return Response.ok(_dbRes);
      } else {
        return Response.badRequest(body: {"status": 1, "body": "invalid id"});
      }
  }

 } 