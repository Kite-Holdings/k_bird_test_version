import 'package:kite_bird/models/response_model.dart';



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