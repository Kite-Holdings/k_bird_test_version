import 'package:kite_bird/models/model.dart';
export 'package:kite_bird/models/model.dart' show where, modify, ObjectId;

class StkProcessModel extends Model{
  StkProcessModel({
    this.processId,
    this.processState,
    this.requestId,
    this.checkoutRequestID
  }) : super(dbUrl: databaseUrl, collectionName: stkPushProcessesCollection){
    timeInitiated = DateTime.now();
    super.document = asMap();
  }

  final String processId;
  final ProcessState processState;
  final String requestId;
  final String checkoutRequestID;
  DateTime timeInitiated;

  Map<String, dynamic> asMap()=> {
      'processState': processStateValue(),
      'requestId': requestId,
      'checkoutRequestID': checkoutRequestID,
      'timeInitiated': timeInitiated
    };
  
  void updateProcessStateById() async {
    await findAndModify(
      selector: where.id(ObjectId.parse(processId)), 
      modifier: modify.set('processState', processStateValue())
    );
  }

  void updateProcessStateByRequestId() async {
    await findAndModify(
      selector: where.eq('requestId', requestId), 
      modifier: modify.set('processState', processStateValue())
    );
  }

  void updateProcessStateByCheckoutRequestID() async {
    await findAndModify(
      selector: where.eq('checkoutRequestID', checkoutRequestID), 
      modifier: modify.set('processState', processStateValue())
    );
  }

  Future<bool> isPending()async{
    final Map<String, dynamic> _queryRes = await findOneBy(where.eq('requestId', requestId),);
    return _queryRes['body']['processState']== 'pending';
  }


  String processStateValue(){
    switch (processState) {
      case ProcessState.pending:
        return 'pending';
        break;
      case ProcessState.cancel:
        return 'cancel';
        break;
      case ProcessState.complete:
        return 'complete';
        break;
      case ProcessState.failed:
        return 'failed';
        break;
      case ProcessState.terminated:
        return 'terminated';
        break;
      default:
        return 'undefiened';
    }
  }
}


enum ProcessState{
  pending,
  cancel,
  complete,
  failed,
  terminated
}