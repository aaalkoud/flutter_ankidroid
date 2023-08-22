import 'dart:isolate';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_isolate/flutter_isolate.dart';

import 'src/future_result.dart';
export 'src/future_result.dart';
import 'src/ankidroid_platform_interface.dart';

class Ankidroid {
  final FlutterIsolate _isolate;
  final SendPort _ankiPort;

  const Ankidroid._(this._isolate, this._ankiPort);
  
  /// If you hot restart your app, the isolate won't be killed, and vscode
  /// will show another isolate in your call stack. not that big of a deal.
  /// Btw, if anyone knows how to give the isolate a name please help
  static Future<Ankidroid> createAnkiIsolate() async {
    WidgetsFlutterBinding.ensureInitialized();
    final rPort = ReceivePort();
    final isolate = await FlutterIsolate.spawn(_isolateFunction, rPort.sendPort);
    final ankiPort = await rPort.first;

    return Ankidroid._(isolate, ankiPort);
  }

  void killIsolate() => _isolate.kill();

  /// should return 'Test Successful!'
  FutureResult<String?> test() async {
    final rPort = ReceivePort();
    _ankiPort.send({'functionName': 'test', 'sendPort': rPort.sendPort});
    return await rPort.first;
  } 

  /// get modelId/mid and deckId/did using `modelList()` and `deckList()` 
  FutureResult<int?> addNote(int modelId, int deckId, List<String> fields, List<String> tags) async {
    final rPort = ReceivePort();
    _ankiPort.send({
      'functionName': 'addNote', 
      'sendPort': rPort.sendPort, 
      'modelId': modelId,
      'deckId': deckId,
      'fields': fields,
      'tags': tags
    });
    return await rPort.first;
  }
  
  FutureResult<int?> addNotes(int modelId, int deckId, List<List<String>> fieldsList, List<List<String>> tagsList) async {
    final rPort = ReceivePort();
    _ankiPort.send({
      'functionName': 'addNotes', 
      'sendPort': rPort.sendPort, 
      'modelId': modelId,
      'deckId': deckId,
      'fieldsList': fieldsList,
      'tagsList': tagsList
    });
    return await rPort.first;
  }

  /// This is a wrapper over anki's addMediaFromUri. Function
  /// takes in either `file` or `data`. `preferredName` will be
  /// **part** of the file's name on android. `mimeType` could 
  /// be either 'audio' or 'image'. If successful, returns <img ...> 
  /// or [sound:...] with src name being '$preferredName_$randomNumber'
  FutureResult<String?> addMedia(Uint8List bytes, String preferredName, String mimeType) async {
    final rPort = ReceivePort();
    _ankiPort.send({
      'functionName': 'addNotes', 
      'sendPort': rPort.sendPort, 
      'bytes': bytes,
      'preferredName': preferredName, 
      'mimeType': mimeType, 
    });
    return await rPort.first;
  }

  /// key being value of the first field in a note. (AFAIK)
  FutureResult<List<Map<Object?, Object?>>?> findDuplicateNotesWithKey(int mid, String key) async {
    final rPort = ReceivePort();
    _ankiPort.send({
      'functionName': 'findDuplicateNotesWithKey', 
      'sendPort': rPort.sendPort, 
      'mid': mid,
      'key': key, 
    });
    return await rPort.first;
  }

  /// keys being values of the first fields in a note. (AFAIK)
  FutureResult<List<List<Map<Object?, Object?>>>?> findDuplicateNotesWithKeys(int mid, List<String> keys) async {
    final rPort = ReceivePort();
    _ankiPort.send({
      'functionName': 'findDuplicateNotesWithKeys', 
      'sendPort': rPort.sendPort, 
      'mid': mid,
      'keys': keys, 
    });
    return await rPort.first;
  }
  
  FutureResult<int?> getNoteCount(int mid) async {
    final rPort = ReceivePort();
    _ankiPort.send({'functionName': 'getNoteCount', 'sendPort': rPort.sendPort, 'mid': mid});
    return await rPort.first;
  } 

  FutureResult<bool?> updateNoteTags(int noteId, List<String> tags) async {
    final rPort = ReceivePort();
    _ankiPort.send({
      'functionName': 'updateNoteTags', 
      'sendPort': rPort.sendPort, 
      'noteId': noteId,
      'tags': tags, 
    });
    return await rPort.first;
  }

  FutureResult<bool?> updateNoteFields(int noteId, List<String> fields) async {
    final rPort = ReceivePort();
    _ankiPort.send({
      'functionName': 'updateNoteFields', 
      'sendPort': rPort.sendPort, 
      'noteId': noteId,
      'fields': fields, 
    });
    return await rPort.first;
  }

  /// Use the helper NoteInfo class here. You could also directly use the map too  
  FutureResult<Map<String, Object>?> getNote(int noteId) async {
    final rPort = ReceivePort();
    _ankiPort.send({
      'functionName': 'getNote', 
      'sendPort': rPort.sendPort, 
      'noteId': noteId, 
    });
    return await rPort.first;
  }

  FutureResult<Map<String, Object>?> previewNewNote(int mid, List<String> flds) async {
    final rPort = ReceivePort();
    _ankiPort.send({
      'functionName': 'previewNewNote', 
      'sendPort': rPort.sendPort, 
      'mid': mid,
      'flds': flds, 
    });
    return await rPort.first;
  }

  FutureResult<int?> addNewBasicModel(String name) async {
    final rPort = ReceivePort();
    _ankiPort.send({
      'functionName': 'addNewBasicModel', 
      'sendPort': rPort.sendPort, 
      'name': name,
    });
    return await rPort.first;
  }

  FutureResult<int?> addNewBasic2Model(String name) async {
    final rPort = ReceivePort();
    _ankiPort.send({
      'functionName': 'addNewBasic2Model', 
      'sendPort': rPort.sendPort, 
      'name': name,
    });
    return await rPort.first;
  }

  /// Models are note types. Example values could look like this 
  /// (Some are from the java docs for the impl of addNewBasicModel):
  /// 
  /// `fields`: `["Front", "Back"]` or `["Word", "Definition", "Example"]`
  /// 
  /// `cards`: `["Card1", "Card2"]`
  /// 
  /// `QFMT`: `["{{Front}}", "<hr>{{Front}}<hr>"]` basically the question format for each card type 
  /// 
  /// `AFMT`: `["{{FrontSide}}\n\n<hr id=\"answer\">\n\n{{Back}}", "Card 2 AFMT"]` same as above
  /// 
  /// I am not really sure how `did` and `sortf` work, but they couldn't be that hard to understand
  /// 
  /// for more info you could check out the AnkidroidPlugin kotlin file and 
  /// search for addNewCustomModel function. click through that to read 
  /// the anki java library code
  FutureResult<int?> addNewCustomModel(String name, List<String> fields, List<String> cards, List<String> qfmt, List<String> afmt, String css, int? did, int? sortf) async {
    final rPort = ReceivePort();
    _ankiPort.send({
      'functionName': 'addNewCustomModel', 
      'sendPort': rPort.sendPort, 
      'name': name,
      'fields': fields,
      'cards': cards,
      'qfmt': qfmt,
      'afmt': afmt,
      'did': did,
      'sortf': sortf
    });
    return await rPort.first;
  }

  FutureResult<int?> currentModelId() async {
    final rPort = ReceivePort();
    _ankiPort.send({'functionName': 'currentModelId', 'sendPort': rPort.sendPort});
    return await rPort.first;
  } 
  
  FutureResult<List<String>?> getFieldList(int modelId) async {
    final rPort = ReceivePort();
    _ankiPort.send({'functionName': 'getFieldList', 'sendPort': rPort.sendPort, 'modelId': modelId});
    return await rPort.first;
  } 

  FutureResult<Map<int, String>?> modelList() async {
    final rPort = ReceivePort();
    _ankiPort.send({'functionName': 'modelList', 'sendPort': rPort.sendPort});
    return await rPort.first;
  } 

  /// all models with minNumFields. 0 would show all
  FutureResult<Map<int, String>?> getModelList(int minNumFields) async {
    final rPort = ReceivePort();
    _ankiPort.send({'functionName': 'addNewDeck', 'getModelList': rPort.sendPort, 'minNumFields': minNumFields});
    return await rPort.first;
  } 

  FutureResult<String?> getModelName(int mid) async {
    final rPort = ReceivePort();
    _ankiPort.send({'functionName': 'getModelName', 'sendPort': rPort.sendPort, 'mid': mid});
    return await rPort.first;
  } 

  FutureResult<int?> addNewDeck(String deckName) async {
    final rPort = ReceivePort();
    _ankiPort.send({'functionName': 'addNewDeck', 'sendPort': rPort.sendPort, 'deckName': deckName});
    return await rPort.first;
  } 

  FutureResult<String?> selectedDeckName() async {
    final rPort = ReceivePort();
    _ankiPort.send({'functionName': 'selectedDeckName', 'sendPort': rPort.sendPort});
    return await rPort.first;
  } 

  FutureResult<Map<int, String>?> deckList() async {
    final rPort = ReceivePort();
    _ankiPort.send({'functionName': 'deckList', 'sendPort': rPort.sendPort});
    return await rPort.first;
  } 

  FutureResult<String?> getDeckName(int did) async {
    final rPort = ReceivePort();
    _ankiPort.send({'functionName': 'getDeckName', 'sendPort': rPort.sendPort, 'did': did});
    return await rPort.first;
  } 

  FutureResult<int?> apiHostSpecVersion() async {
    final rPort = ReceivePort();
    _ankiPort.send({'functionName': 'apiHostSpecVersion', 'sendPort': rPort.sendPort});
    return await rPort.first;
  } 
}

@pragma('vm:entry-point')
_isolateFunction(SendPort sendPort) async {
  final ankiPort = ReceivePort();
  sendPort.send(ankiPort.sendPort);

  await for (Map<String, dynamic> msg in ankiPort) {
    msg['sendPort'].send(switch (msg['functionName']) {
      'test' => await AnkidroidPlatform.instance.test(),

      'addNote' => await AnkidroidPlatform.instance.addNote(msg['modelId'], msg['deckId'], msg['fields'], msg['tags']),

      'addNotes' => await AnkidroidPlatform.instance.addNotes(msg['modelId'], msg['deckId'], msg['fieldsList'], msg['tagsList']),

      'addMediaFromUri' => await AnkidroidPlatform.instance.addMedia(msg['bytes'], msg['preferredName'], msg['mimeType']),

      'findDuplicateNotesWithKey' => await AnkidroidPlatform.instance.findDuplicateNotesWithKey(msg['mid'], msg['key']),

      'findDuplicateNotesWithKeys' => await AnkidroidPlatform.instance.findDuplicateNotesWithKeys(msg['mid'], msg['keys']),

      'getNoteCount' => await AnkidroidPlatform.instance.getNoteCount(msg['mid']),

      'updateNoteTags' => await AnkidroidPlatform.instance.updateNoteTags(msg['noteId'], msg['tags']),

      'updateNoteFields' => await AnkidroidPlatform.instance.updateNoteFields(msg['noteId'], msg['fields']),

      'getNote' => await AnkidroidPlatform.instance.getNote(msg['noteId']),

      'previewNewNote' => await AnkidroidPlatform.instance.previewNewNote(msg['mid'], msg['flds']),

      'addNewBasicModel' => await AnkidroidPlatform.instance.addNewBasicModel(msg['name']),

      'addNewBasic2Model' => await AnkidroidPlatform.instance.addNewBasic2Model(msg['name']),

      'addNewCustomModel' => await AnkidroidPlatform.instance.addNewCustomModel(msg['name'], msg['fields'], msg['cards'], msg['qfmt'], msg['afmt'], msg['css'], msg['did'], msg['sortf']),

      'currentModelId' => await AnkidroidPlatform.instance.currentModelId(),

      'getFieldList' => await AnkidroidPlatform.instance.getFieldList(msg['modelId']),

      'modelList' => await AnkidroidPlatform.instance.modelList(),

      'getModelList' => await AnkidroidPlatform.instance.getModelList(msg['minNumFields']),

      'getModelName' => await AnkidroidPlatform.instance.getModelName(msg['mid']),

      'addNewDeck' => await AnkidroidPlatform.instance.addNewDeck(msg['deckName']),

      'selectedDeckName' => await AnkidroidPlatform.instance.selectedDeckName(),

      'deckList' => await AnkidroidPlatform.instance.deckList(),

      'getDeckName' => await AnkidroidPlatform.instance.getDeckName(msg['did']),

      'apiHostSpecVersion' => await AnkidroidPlatform.instance.apiHostSpecVersion(),

      Object() => Exception('Anki method ${msg['functionName']} not implemented'),

      null => Exception('No Anki method supplied in msg[\'functionName\']')
    });
  }
}
  
// FutureResult<String?> test() async => await AnkidroidPlatform.instance.test();

// FutureResult<int?> addNote(int modelId, int deckId, List<String> fields, List<String> tags) async => 
//   await AnkidroidPlatform.instance.addNote(modelId, deckId, fields, tags);

// FutureResult<int?> addNotes(int modelId, int deckId, List<List<String>> fieldsList, List<List<String>> tagsList) async => 
//   await AnkidroidPlatform.instance.addNotes(modelId, deckId, fieldsList, tagsList);

// /// This is a wrapper over anki's addMediaFromUri. Function
// /// takes in either `file` or `data`. `preferredName` will be
// /// **part** of the file's name on android. `mimeType` could 
// /// be either 'audio' or 'image'. If successful, returns <img ...> 
// /// or [sound:...] with src name being '$preferredName_$randomNumber'
// FutureResult<String?> addMedia({
//   required String preferredName, 
//   required String mimeType, 
//   File? file,
//   Uint8List? bytes,
// }) async => 
//   await AnkidroidPlatform.instance.addMedia(
//     preferredName: preferredName, 
//     mimeType: mimeType, 
//     file: file, 
//     bytes: bytes
//   );

// /// key being value of the first field in a note. (AFAIK)
// FutureResult<List<Map<Object?, Object?>>?> findDuplicateNotesWithKey(int mid, String key) async => 
//   await AnkidroidPlatform.instance.findDuplicateNotesWithKey(mid, key);

// /// keys being values of the first fields in a note. (AFAIK)
// FutureResult<List<List<Map<Object?, Object?>>>?> findDuplicateNotesWithKeys(int mid, List<String> keys) async => 
//   await AnkidroidPlatform.instance.findDuplicateNotesWithKeys(mid, keys);

// FutureResult<int?> getNoteCount(int mid) async => 
//   await AnkidroidPlatform.instance.getNoteCount(mid);

// FutureResult<bool?> updateNoteTags(int noteId, List<String> tags) async => 
//   await AnkidroidPlatform.instance.updateNoteTags(noteId, tags);

// FutureResult<bool?> updateNoteFields(int noteId, List<String> fields) async => 
//   await AnkidroidPlatform.instance.updateNoteFields(noteId, fields);

// /// Use the helper NoteInfo class here. You could also directly use the map too  
// FutureResult<Map<String, Object>?> getNote(int noteId) async => 
//   await AnkidroidPlatform.instance.getNote(noteId);

// FutureResult<Map<String, Object>?> previewNewNote(int mid, List<String> flds) async => 
//   await AnkidroidPlatform.instance.previewNewNote(mid, flds);

// FutureResult<int?> addNewBasicModel(String name) async => 
//   await AnkidroidPlatform.instance.addNewBasicModel(name);

// FutureResult<int?> addNewBasic2Model(String name) async => 
//   await AnkidroidPlatform.instance.addNewBasic2Model(name);

// /// Models are note types. Example values could look like this 
// /// (Some are from the java docs for the impl of addNewBasicModel):
// /// 
// /// `fields`: `["Front", "Back"]` or `["Word", "Definition", "Example"]`
// /// 
// /// `cards`: `["Card1", "Card2"]`
// /// 
// /// `QFMT`: `["{{Front}}", "<hr>{{Front}}<hr>"]` basically the question format for each card type 
// /// 
// /// `AFMT`: `["{{FrontSide}}\n\n<hr id=\"answer\">\n\n{{Back}}", "Card 2 AFMT"]` same as above
// /// 
// /// I am not really sure how `did` and `sortf` work, but they couldn't be that hard to understand
// /// 
// /// for more info you could check out the AnkidroidPlugin kotlin file and 
// /// search for addNewCustomModel function. click through that to read 
// /// the anki java library code
// FutureResult<int?> addNewCustomModel(String name, List<String> fields, List<String> cards, List<String> qfmt, List<String> afmt, String css, int? did, int? sortf) async => 
//   await AnkidroidPlatform.instance.addNewCustomModel(name, fields, cards, qfmt, afmt, css, did, sortf);

// FutureResult<int?> currentModelId() async => 
//   await AnkidroidPlatform.instance.currentModelId();

// FutureResult<List<String>?> getFieldList(int modelId) async => 
//   await AnkidroidPlatform.instance.getFieldList(modelId);

// FutureResult<Map<int, String>?> modelList() async => 
//   await AnkidroidPlatform.instance.modelList();

// /// all models with minNumFields. 0 would show all
// FutureResult<Map<int, String>?> getModelList(int minNumFields) async => 
//   await AnkidroidPlatform.instance.getModelList(minNumFields);

// FutureResult<String?> getModelName(int mid) async => 
//   await AnkidroidPlatform.instance.getModelName(mid);

// FutureResult<int?> addNewDeck(String deckName) async => 
//   await AnkidroidPlatform.instance.addNewDeck(deckName);

// FutureResult<String?> selectedDeckName() async => 
//   await AnkidroidPlatform.instance.selectedDeckName();

// FutureResult<Map<int, String>?> deckList() async => 
//   await AnkidroidPlatform.instance.deckList();

// FutureResult<String?> getDeckName(int did) async => 
//   await AnkidroidPlatform.instance.getDeckName(did);

// FutureResult<int?> apiHostSpecVersion() async => 
//   await AnkidroidPlatform.instance.apiHostSpecVersion();