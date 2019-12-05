import 'package:kite_bird/kite_bird.dart';
import 'package:kite_bird/models/cooprate_model.dart';
import 'package:kite_bird/requests_managers/cooperate_request.dart';
import 'package:kite_bird/serializers/cooprate_serializer.dart';

class CooprateController extends ResourceController{
  CooprateModel cooprateModel = CooprateModel();
  @Operation.get()
  Future<Response> getAll()async{
    // Save Request
    final CooperateRequest _cooperateRequest = CooperateRequest(
      account: request.authorization != null ? request.authorization.clientID : null,
      cooperateRequestsType: CooperateRequestsType.getAll,
      metadata: null
    );
    _cooperateRequest.normalRequest();

    final Map<String, dynamic> _dbRes = await cooprateModel.find();
    if(_dbRes['status'] == 0){
      return Response.ok(_dbRes);
    } else{
      return Response.serverError(body: {"status": 1, "body": "an error occured"});
    }
  }

  @Operation.get('cooperateId')
  Future<Response> getOne(@Bind.path("cooperateId") String cooperateId)async{
    // Save Request
    final CooperateRequest _cooperateRequest = CooperateRequest(
      account: request.authorization != null ? request.authorization.clientID : null,
      cooperateRequestsType: CooperateRequestsType.getByid,
      metadata: {
        "cooperateId": cooperateId
      }
    );
    _cooperateRequest.normalRequest();


    final Map<String, dynamic> _dbRes = await cooprateModel.findById(cooperateId);
      if(_dbRes['status'] == 0){
        return Response.ok(_dbRes);
      } else {
        return Response.badRequest(body: {"status": 1, "body": "invalid id"});
      }
  }

  @Operation.post()
  Future<Response> registerCompany(@Bind.body(require: ['name']) CoopratesSerializer coopratesSerializer)async{
    // Save Request
    final CooperateRequest _cooperateRequest = CooperateRequest(
      account: request.authorization != null ? request.authorization.clientID : null,
      cooperateRequestsType: CooperateRequestsType.create,
      metadata: coopratesSerializer.asMap()
    );
    _cooperateRequest.normalRequest();


    final CooprateModel _cooprateModel = CooprateModel(name: coopratesSerializer.name);
    await _cooprateModel.init();
    final Map<String, dynamic> _dbRes = await _cooprateModel.save();
    if(_dbRes['status'] == 0){
      return Response.ok({'status': 0, 'body': "Cooprate saved."});
    } else {
      if(_dbRes['body']['code'] == 11000){
        return Response.badRequest(body: {'status': 1, 'body': "name exixts"});
      } else {
        return Response.badRequest(body: {'status': 1, 'body': 'An error occured!'});
      }
    }
  }

  @Operation.delete('cooperateId')
  Future<Response> delete(@Bind.path("cooperateId") String cooperateId)async{
    // Save Request
    final CooperateRequest _cooperateRequest = CooperateRequest(
      account: request.authorization != null ? request.authorization.clientID : null,
      cooperateRequestsType: CooperateRequestsType.delete,
      metadata: {
        "cooperateId": cooperateId
      }
    );
    _cooperateRequest.normalRequest();

    final Map<String, dynamic> _dbRes = await cooprateModel.remove(where.id(ObjectId.parse(cooperateId)));
      if(_dbRes['status'] == 0){
        return Response.ok({"status": 0, "body": "deleted successfully"});
      } else {
        return Response.badRequest(body: {"status": 1, "body": "invalid id"});
      }
  }


}

class CooprateFindByController extends ResourceController{
  CooprateModel cooprateModel = CooprateModel();
  @Operation.get('cooprateName')
  Future<Response> getByNameSelector(@Bind.path("cooprateName") String cooprateName)async{
    // Save Request
    final CooperateRequest _cooperateRequest = CooperateRequest(
      account: request.authorization != null ? request.authorization.clientID : null,
      cooperateRequestsType: CooperateRequestsType.getByName,
      metadata: {
        "cooperateId": cooprateName
      }
    );
    _cooperateRequest.normalRequest();


    final Map<String, dynamic> _dbRes = await cooprateModel.findBySelector(where.eq('name', cooprateName));
      if(_dbRes['status'] == 0){
        return Response.ok(_dbRes);
      } else {
        return Response.badRequest(body: {"status": 1, "body": "invalid id"});
      }
  }
  @Operation.get('cooprateCode')
  Future<Response> getByCodeSelector(@Bind.path("cooprateCode") String cooprateCode)async{
    // Save Request
    final CooperateRequest _cooperateRequest = CooperateRequest(
      account: request.authorization != null ? request.authorization.clientID : null,
      cooperateRequestsType: CooperateRequestsType.getByCooprateCode,
      metadata: {
        "cooprateCode": cooprateCode
      }
    );
    _cooperateRequest.normalRequest();


    final Map<String, dynamic> _dbRes = await cooprateModel.findBySelector(where.eq('code', cooprateCode));
      if(_dbRes['status'] == 0){
        return Response.ok(_dbRes);
      } else {
        return Response.badRequest(body: {"status": 1, "body": "invalid id"});
      }
  }
}