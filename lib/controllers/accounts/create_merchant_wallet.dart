import 'package:kite_bird/models/utils/increment_counter.dart';
import 'package:kite_bird/models/wallets/merchant_wallet_model.dart';

Future<Map<String, dynamic>> createMerchantController({String companyName, String accountId})async{
  bool _success = false;
  // create shortcode
  final int _count = await databaseCounter('merchantWallet');
  final String _shortCode = _count.toString().padLeft(6, '0');

  final MerchantWalletModel _merchantWalletModel = MerchantWalletModel(
    accountId: accountId,
    companyName: companyName,
    shortCode: _shortCode
  );
  try {
    await _merchantWalletModel.save();   
    _success = true; 
  } catch (e) {
    _success = false;
  }
  return {
    'success': _success,
    'shortCode': _shortCode
  };
}