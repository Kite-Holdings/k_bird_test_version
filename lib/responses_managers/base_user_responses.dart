import 'package:kite_bird/models/response_model.dart';

class BaseUserResponses extends ResponsesModel{
  BaseUserResponses({
    this.requestId,
    this.responseType,
    this.responseBody,
    this.status,
  }):super(requestId: requestId, responseType: responseType, responseBody: responseBody, status: status);

  final String requestId;
  final ResposeType responseType;
  final ResponsesStatus status;
  final dynamic responseBody;
}