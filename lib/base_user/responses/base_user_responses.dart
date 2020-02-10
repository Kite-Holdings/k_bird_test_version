import 'package:kite_bird/response/models/response_models.dart' show
        ResponsesModel, ObjectId, ResponsesStatus, ResposeType;

class BaseUserResponses extends ResponsesModel{
  BaseUserResponses({
    this.st,
    this.resBody,
    this.resType,
  }):super(requestId: ObjectId().toJson(), responseType: resType, responseBody: resBody, status: st);
  final ResponsesStatus st;
  final ResposeType resType;
  final dynamic resBody;

  
}