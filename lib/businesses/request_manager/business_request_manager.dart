import 'package:kite_bird/requests/models/requests_models.dart' show 
        ObjectId, RequestMethod, RequestsModel, RequestType;

class BusinessRequest{
  BusinessRequest({this.account, this.businessRequestsType, this.metadata});


  final String account;
  final dynamic metadata;
  final BusinessRequestsType businessRequestsType;

  ObjectId id = ObjectId();
  String _url = '/business';
  String requestId() => id.toJson();
  RequestMethod _requestMethod = RequestMethod.getmethod;
  final RequestType _requestType = RequestType.business;

    void normalRequest()async{
    switch (businessRequestsType) {
      case BusinessRequestsType.create:
        _requestMethod = RequestMethod.postMethod;
        _url = '/business/create';
        break;
      case BusinessRequestsType.fetchBusinesses:
        _requestMethod = RequestMethod.getmethod;
        _url = '/business';
        break;
      case BusinessRequestsType.addStaff:
        _requestMethod = RequestMethod.postMethod;
        _url = '/business/addStaff';
        break;
      case BusinessRequestsType.delete:
        _requestMethod = RequestMethod.deleteMethod;
        _url = '/business/:businessId';
        break;
      default:
    }

    final RequestsModel _requestsModel = RequestsModel(
      id: id,
      url: _url,
      requestType: _requestType,
      requestMethod: _requestMethod,
      account: account,
      metadata: metadata
    );
    await _requestsModel.save();
  }


}

enum BusinessRequestsType{
  create,
  delete,
  addStaff,
  fetchBusinesses,
}