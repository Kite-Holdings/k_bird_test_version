
import 'package:kite_bird/controllers/transactions/callbacks/mpesa_callback_controller.dart';
import 'package:kite_bird/models/mpesa/skt_process_model.dart';
import 'package:kite_bird/models/mpesa/stk_query_response_model.dart';
import 'package:kite_bird/third_party_operations/mpesa/stkpush_query_request.dart';

Future<void> checkStkProcessStatus() async {
  const int _duration = 120000;

  final StkProcessModel stkProcessModel = StkProcessModel();

  final Map<String, dynamic> _map = await stkProcessModel.findBySelector(where.eq('processState', 'pending'));
  final _body = _map['body'];


  for(int i = 0; i < int.parse(_body.length.toString()); i++){
    final DateTime _processDatetime = DateTime.parse(_body[i]['timeInitiated'].toString()).toLocal();
    final DateTime _now = DateTime.now();
    final int _nowInt = _now.millisecondsSinceEpoch;
    final int _pastInt = _processDatetime.millisecondsSinceEpoch;
    final int _diff = _nowInt - _pastInt;
    
    // if duration is greter than 2 minutes query status
    if(_diff > _duration){

      final checkoutRequestID = _body[i]['checkoutRequestID'].toString();
      final String _id = _body[i]['_id'].toString().split('"')[1];
      if(checkoutRequestID != 'null'){
        final StkPushQueryRequest _stkPushQueryRequest = StkPushQueryRequest(checkoutRequestID: checkoutRequestID);

        final Map<String, dynamic> _querRes = await _stkPushQueryRequest.process();
        // save response
        final StkQuerResponseModel _stkQuerResponseModel = StkQuerResponseModel(body: _querRes);
        await _stkQuerResponseModel.save();
        // print('........${_querRes.toString()}..........${_body[i]['checkoutRequestID'].toString()}');
        if(_querRes['status'] != 101){

          if(_querRes['status'] == 0){
            if(_querRes['resultCode'] == '0'){

              // Send callback
              try{
                processMpesaResponse(success: true, body: _querRes, recieptNo: _body[i]['_id'].toJson().toString(), requestId: _body[i]['requestId'].toString());

                // update state to complete
                final StkProcessModel _stkProcessModel = StkProcessModel(checkoutRequestID: checkoutRequestID, processState: ProcessState.complete);
                _stkProcessModel.updateProcessStateByCheckoutRequestID();
              } catch (e){
                print("Error!!!!!!!!!");
                print(e);
              }
            } else{
              
              // Send callback
              try{
                processMpesaResponse(success: false, body: _querRes, recieptNo: _body[i]['_id'].toJson().toString(), requestId: _body[i]['requestId'].toString());

                // update state to failed
                final StkProcessModel _stkProcessModel = StkProcessModel(checkoutRequestID: checkoutRequestID, processState: ProcessState.failed);
                _stkProcessModel.updateProcessStateByCheckoutRequestID();
              } catch (e){
                print("Error!!!!!!!!!");
                print(e);
              }
            }
          } else if(_querRes['status'] == 1){
            if(_querRes['body']['errorMessage'] != null && _querRes['body']['errorMessage'] == 'The transaction is being processed'){
              if(_diff > (_duration * 10)){
                // update state to cancel
                final StkProcessModel _stkProcessModel = StkProcessModel(checkoutRequestID: checkoutRequestID, processState: ProcessState.cancel);
                _stkProcessModel.updateProcessStateByCheckoutRequestID();
              }
            }
          }
        }
      } else{
        // update state to terminated
        final StkProcessModel _stkProcessModel = StkProcessModel(processId: _id.toString(), processState: ProcessState.terminated);
        _stkProcessModel.updateProcessStateById();
      }
    }

  }
}