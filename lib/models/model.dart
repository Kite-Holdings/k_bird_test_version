// import 'package:kite_bird/models/utils/database_collection_names.dart';
import 'package:mongo_dart/mongo_dart.dart';
export 'package:kite_bird/models/utils/settings.dart' show databaseUrl, databaseName;
export 'package:kite_bird/models/utils/database_collection_names.dart';
export 'package:mongo_dart/mongo_dart.dart' show where, modify, ObjectId;

/// This class creates a bridge to the database
/// It takes database url and collection name as the parameter
/// 
/// ---
/// 
/// ## Operations
/// 
/// It enables; 
/// Saving a document [save]. Takes a [Map<String, dynamic>] of the document to save.
/// Insert a document [insert]. Takes a [Map<String, dynamic>] of the document to insert.
/// Checks if document [exists]. Takes a [SelectorBuilder] of the query.
/// Gets all the documents [find]. Takes nothing as arguments/parameters.
/// Gets one document by its _id [findById]. Takes a [String] of the id.
/// Gets a list of documents filtered by a selector [findBySelector]. Takes a [SelectorBuilder] of the query.
/// Updates a document [findAndModify]. Takes [SelectorBuilder] of the query and [ModifierBuilder] of the modification.
/// Deletes a document [remove]. Takes a [SelectorBuilder] of the document query.
/// 
/// ---
/// 
/// ## Responses
/// 
/// Responses with a [Map<String, dynamic>].
/// The response [_response] contains an *status* of type [int] and a *body* of type [dynamic].
/// The response **status** is 0 for a successful operation and 1 if an error occured.
/// The response **body** contains the operation response but if there was an error it contains the error
/// 

class Model{
  Model({
    this.dbUrl,
    this.collectionName
  }){
    _db = Db(dbUrl);
    _dbCollection = _db.collection(collectionName);
  }

  final String dbUrl;
  final String collectionName;
  Db _db;
  DbCollection _dbCollection;

  Map<String, dynamic> document = {};

  // save
  Future<Map<String, dynamic>> save() async {
    await _db.open();
    try{
      final Map<String, dynamic> _res = await _dbCollection.save(document);
      await _db.close();
      return _response(true, _res);
    } catch (e) {
      await _db.close();
      return _response(false, e);
    }
    
  }

  // insert
  Future<Map<String, dynamic>> insert() async {
    await _db.open();
    try{
      final Map<String, dynamic> _res = await _dbCollection.insert(document);
      await _db.close();
      return _response(true, _res);
    } catch (e) {
      await _db.close();
      return _response(false, e);
    }
    
  }


  // Exist
  Future<bool> exists(SelectorBuilder selector)async{
    await _db.open();
    final int _count = await _dbCollection.count(selector);
    await _db.close();
    return _count > 0;
  }


  // find all
  Future<Map<String, dynamic>> find([SelectorBuilder selector]) async {
    await _db.open();
    try{
      final List<Map<String, dynamic>> _res = await _dbCollection.find(selector).toList();
      await _db.close();
      return _response(true, _res);
    } catch (e) {
      await _db.close();
      return _response(false, e);
    }
    
  }

  // find by id
  Future<Map<String, dynamic>> findById(String id, [List<String> exclude = const []]) async {
    await _db.open();
    try{
      final Map<String, dynamic> _res = await _dbCollection.findOne(where.id(ObjectId.parse(id)).excludeFields(exclude));
      await _db.close();
      return _response(true, _res);
    } catch (e) {
      await _db.close();
      return _response(false, e);
    }
    
  }

  // find by selector
  Future<Map<String, dynamic>> findBySelector(SelectorBuilder selector) async {
    await _db.open();
    try{
      final List<Map<String, dynamic>> _res = await _dbCollection.find(selector).toList();
      await _db.close();
      return _response(true, _res);
    } catch (e) {
      await _db.close();
      return _response(false, e);
    }
    
  }


  // find and modify
  Future<Map<String, dynamic>> findAndModify({SelectorBuilder selector, ModifierBuilder modifier}) async {
    await _db.open();
    try{
      final Map<String, dynamic> _res = await _dbCollection.findAndModify(query: selector, update: modifier, returnNew: true);
      await _db.close();
      return _response(true, _res);
    } catch (e) {
      await _db.close();
      return _response(false, e);
    }
    
  }

  // remove
  Future<Map<String, dynamic>> remove(SelectorBuilder selector) async {
    await _db.open();
    try{
      final Map<String, dynamic> _res = await _dbCollection.remove(selector);
      await _db.close();
      return _response(true, _res);
    } catch (e) {
      await _db.close();
      return _response(false, e);
    }
    
  }


  // Response body
  Map<String, dynamic> _response(bool success, dynamic body){
    return {
      "status": success ? 0 : 1,
      "body": body
    };
  }

  // void indexes()async{
  //   await _db.open();
  //   try{
  //     await _db.ensureIndex(accountsCollection, keys: {'phoneNo': 1}, unique: true, background: true, dropDups: false);
  //     await _db.ensureIndex(baseUserCollection, keys: {'email': 1}, unique: true, background: true, dropDups: false);
  //     await _db.ensureIndex(cooprateCollection, keys: {"name": 1}, unique: true, background: true, dropDups: false);
  //     await _db.ensureIndex(counterCollection, keys: {"label": 1}, unique: true, background: true, dropDups: false);
  //     await _db.ensureIndex(walletsCollection, keys: {"walletNo": 1}, unique: true, background: true, dropDups: false);
  //   } catch (e){
  //     print(e);
  //   }
  //   await _db.close();
  // }

}