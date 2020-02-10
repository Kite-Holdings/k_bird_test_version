import 'package:kite_bird/models/model.dart';
import 'package:mongo_dart/mongo_dart.dart';

Future<int> databaseCounter (String documentLabel)async {
  final Db db =  Db(databaseUrl);
  await db.open();
  final DbCollection _counterCollection = db.collection(counterCollection);

  final doc = await _counterCollection.findOne({'label': documentLabel});
  if(doc == null){
    await _counterCollection.insert({
      'label': documentLabel,
      'value': 0,
    });
  }


  final Map<String, dynamic> newc =await _counterCollection.findAndModify(
    query: {"label": documentLabel},
    update: {"\$inc":{'value':1}},
    returnNew: true,

  );
  await db.close();
  final value = newc['value'].toString();
  return int.parse(value);
}