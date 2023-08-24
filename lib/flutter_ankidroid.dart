import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:async/async.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:request_permission/request_permission.dart';

import 'util/future_result.dart';
export 'util/note_info.dart' show NoteInfo;

class Ankidroid {
  final FlutterIsolate _isolate;
  final SendPort _ankiPort;

  const Ankidroid._(this._isolate, this._ankiPort);

  /// If you hot restart your app, the isolate won't be killed, and vscode
  /// will show another isolate in your call stack. not that big of a deal.
  /// Btw, if anyone knows how to give the isolate a name please help
  static Future<Ankidroid> createAnkiIsolate() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    await askForPermission();

    final rPort = ReceivePort();
    final isolate = await FlutterIsolate.spawn(_isolateFunction, rPort.sendPort);
    final ankiPort = await rPort.first;

    return Ankidroid._(isolate, ankiPort);
  }

  static Future<void> askForPermission() async {
    final perms = RequestPermission.instace;
    if (!await perms.hasAndroidPermission('com.ichi2.anki.permission.READ_WRITE_DATABASE')) {
      await perms.requestAndroidPermission('com.ichi2.anki.permission.READ_WRITE_DATABASE');
    }
  }

  void killIsolate() => _isolate.kill();

  /// should return 'Test Successful!'
  Future<Result<String>> test() async {
    final rPort = ReceivePort();
    _ankiPort.send({'functionName': 'test', 'sendPort': rPort.sendPort});

    final ret = await rPort.first;
    return mapToResult(ret);
  } 

  /// returns note id
  /// 
  /// get modelId (sometimes called mid) and deckId (sometimes called did) using `modelList()` and `deckList()` 
  Future<Result<int>> addNote(int modelId, int deckId, List<String> fields, List<String> tags) async {
    final rPort = ReceivePort();
    _ankiPort.send({
      'functionName': 'addNote', 
      'sendPort': rPort.sendPort, 
      'modelId': modelId,
      'deckId': deckId,
      'fields': fields,
      'tags': tags
    });

    final ret = await rPort.first;
    return mapToResult(ret);
  }
  
  /// returns how many notes added
  Future<Result<int>> addNotes(int modelId, int deckId, List<List<String>> fieldsList, List<List<String>> tagsList) async {
    final rPort = ReceivePort();
    _ankiPort.send({
      'functionName': 'addNotes', 
      'sendPort': rPort.sendPort, 
      'modelId': modelId,
      'deckId': deckId,
      'fieldsList': fieldsList,
      'tagsList': tagsList
    });
    
    final ret = await rPort.first;
    return mapToResult(ret);
  }

  /// This is a wrapper over anki's addMediaFromUri. Function
  /// takes in either `file` or `data`. `preferredName` will be
  /// **part** of the file's name on android. `mimeType` could 
  /// be either 'audio' or 'image'. If successful, returns <img ...> 
  /// or [sound:...] with src name being '$preferredName_$randomNumber'
  Future<Result<String>> addMedia(Uint8List bytes, String preferredName, String mimeType) async {
    final rPort = ReceivePort();
    _ankiPort.send({
      'functionName': 'addNotes', 
      'sendPort': rPort.sendPort, 
      'bytes': bytes,
      'preferredName': preferredName, 
      'mimeType': mimeType, 
    });
    
    final ret = await rPort.first;
    return mapToResult(ret);
  }

  /// returns list of noteinfos. consider using util/note_info.dart
  ///
  /// key being value of the first field in a note.
  Future<Result<List<dynamic>>> findDuplicateNotesWithKey(int mid, String key) async {
    final rPort = ReceivePort();
    _ankiPort.send({
      'functionName': 'findDuplicateNotesWithKey', 
      'sendPort': rPort.sendPort, 
      'mid': mid,
      'key': key, 
    });
    
    final ret = await rPort.first;
    return mapToResult(ret);
  }

  /// returns list of lists of noteinfos. consider using util/note_info.dart
  /// 
  /// keys being values of the first fields in a note.
  Future<Result<List<dynamic>>> findDuplicateNotesWithKeys(int mid, List<String> keys) async {
    final rPort = ReceivePort();
    _ankiPort.send({
      'functionName': 'findDuplicateNotesWithKeys', 
      'sendPort': rPort.sendPort, 
      'mid': mid,
      'keys': keys, 
    });
    
    final ret = await rPort.first;
    return mapToResult(ret);
  }
  
  Future<Result<int>> getNoteCount(int mid) async {
    final rPort = ReceivePort();
    _ankiPort.send({'functionName': 'getNoteCount', 'sendPort': rPort.sendPort, 'mid': mid});
    
    final ret = await rPort.first;
    return mapToResult(ret);
  } 

  /// returns whether this worked or not
  Future<Result<bool>> updateNoteTags(int noteId, List<String> tags) async {
    final rPort = ReceivePort();
    _ankiPort.send({
      'functionName': 'updateNoteTags', 
      'sendPort': rPort.sendPort, 
      'noteId': noteId,
      'tags': tags, 
    });
    
    final ret = await rPort.first;
    return mapToResult(ret);
  }

  /// returns whether this worked or not
  Future<Result<bool>> updateNoteFields(int noteId, List<String> fields) async {
    final rPort = ReceivePort();
    _ankiPort.send({
      'functionName': 'updateNoteFields', 
      'sendPort': rPort.sendPort, 
      'noteId': noteId,
      'fields': fields, 
    });
    
    final ret = await rPort.first;
    return mapToResult(ret);
  }

  /// Use the helper NoteInfo class here. You could also directly use the map too  
  Future<Result<Map<dynamic, dynamic>>> getNote(int noteId) async {
    final rPort = ReceivePort();
    _ankiPort.send({
      'functionName': 'getNote', 
      'sendPort': rPort.sendPort, 
      'noteId': noteId, 
    });
    
    final ret = await rPort.first;
    return mapToResult(ret);
  }


  /// returns map of cards names and their impl for this note
  Future<Result<Map<dynamic, dynamic>>> previewNewNote(int mid, List<String> flds) async {
    final rPort = ReceivePort();
    _ankiPort.send({
      'functionName': 'previewNewNote', 
      'sendPort': rPort.sendPort, 
      'mid': mid,
      'flds': flds, 
    });
    
    final ret = await rPort.first;
    return mapToResult(ret);
  }

  /// returns model id
  Future<Result<int>> addNewBasicModel(String name) async {
    final rPort = ReceivePort();
    _ankiPort.send({
      'functionName': 'addNewBasicModel', 
      'sendPort': rPort.sendPort, 
      'name': name,
    });
    
    final ret = await rPort.first;
    return mapToResult(ret);
  }

  /// returns model id
  Future<Result<int>> addNewBasic2Model(String name) async {
    final rPort = ReceivePort();
    _ankiPort.send({
      'functionName': 'addNewBasic2Model', 
      'sendPort': rPort.sendPort, 
      'name': name,
    });
    
    final ret = await rPort.first;
    return mapToResult(ret);
  }

  /// returns model id
  /// 
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
  Future<Result<int>> addNewCustomModel(String name, List<String> fields, List<String> cards, List<String> qfmt, List<String> afmt, String css, int? did, int? sortf) async {
    final rPort = ReceivePort();
    _ankiPort.send({
      'functionName': 'addNewCustomModel', 
      'sendPort': rPort.sendPort, 
      'name': name,
      'fields': fields,
      'cards': cards,
      'qfmt': qfmt,
      'afmt': afmt,
      'css': css,
      'did': did,
      'sortf': sortf
    });
    
    final ret = await rPort.first;
    return mapToResult(ret);
  }

  Future<Result<int>> currentModelId() async {
    final rPort = ReceivePort();
    _ankiPort.send({'functionName': 'currentModelId', 'sendPort': rPort.sendPort});
    
    final ret = await rPort.first;
    return mapToResult(ret);
  } 
  
  /// returns list of strings. if asValue not null consider writing List<String>.from(fieldList)
  Future<Result<List<dynamic>>> getFieldList(int modelId) async {
    final rPort = ReceivePort();
    _ankiPort.send({'functionName': 'getFieldList', 'sendPort': rPort.sendPort, 'modelId': modelId});
    
    final ret = await rPort.first;
    return mapToResult(ret);
  } 

  Future<Result<Map<dynamic, dynamic>>> modelList() async {
    final rPort = ReceivePort();
    _ankiPort.send({'functionName': 'modelList', 'sendPort': rPort.sendPort});
    
    final ret = await rPort.first;
    return mapToResult(ret);
  } 

  /// all models with minNumFields. 0 would show all
  Future<Result<Map<dynamic, dynamic>>> getModelList(int minNumFields) async {
    final rPort = ReceivePort();
    _ankiPort.send({'functionName': 'getModelList', 'sendPort': rPort.sendPort, 'minNumFields': minNumFields});
    
    final ret = await rPort.first;
    return mapToResult(ret);
  } 

  Future<Result<String>> getModelName(int mid) async {
    final rPort = ReceivePort();
    _ankiPort.send({'functionName': 'getModelName', 'sendPort': rPort.sendPort, 'mid': mid});
    
    final ret = await rPort.first;
    return mapToResult(ret);
  } 

  /// returns deckid
  Future<Result<int>> addNewDeck(String deckName) async {
    final rPort = ReceivePort();
    _ankiPort.send({'functionName': 'addNewDeck', 'sendPort': rPort.sendPort, 'deckName': deckName});
    
    final ret = await rPort.first;
    return mapToResult(ret);
  } 

  Future<Result<String>> selectedDeckName() async {
    final rPort = ReceivePort();
    _ankiPort.send({'functionName': 'selectedDeckName', 'sendPort': rPort.sendPort});
    
    final ret = await rPort.first;
    return mapToResult(ret);
  } 

  Future<Result<Map<dynamic, dynamic>>> deckList() async {
    final rPort = ReceivePort();
    _ankiPort.send({'functionName': 'deckList', 'sendPort': rPort.sendPort});
    
    final ret = await rPort.first;
    return mapToResult(ret);
  } 

  Future<Result<String>> getDeckName(int did) async {
    final rPort = ReceivePort();
    _ankiPort.send({'functionName': 'getDeckName', 'sendPort': rPort.sendPort, 'did': did});
    
    final ret = await rPort.first;
    return mapToResult(ret);
  } 

  Future<Result<int>> apiHostSpecVersion() async {
    final rPort = ReceivePort();
    _ankiPort.send({'functionName': 'apiHostSpecVersion', 'sendPort': rPort.sendPort});
    
    final ret = await rPort.first;
    return mapToResult(ret);
  }


  @pragma('vm:entry-point')
  static Future<void> _isolateFunction(SendPort sendPort) async {
    
    final ankiPort = ReceivePort();
    sendPort.send(ankiPort.sendPort);

    const methodChannel = MethodChannel('flutter_ankidroid');

    await for (Map<String, dynamic> msg in ankiPort) {
      // this throws 'no activity'
      // final perms = RequestPermission.instace;
      // if (!await perms.hasAndroidPermission('com.ichi2.anki.permission.READ_WRITE_DATABASE')) {
      //   await perms.requestAndroidPermission('com.ichi2.anki.permission.READ_WRITE_DATABASE');
      // }

      msg['sendPort'].send(
        await futureToResultMap(() async => await methodChannel.invokeMethod(msg['functionName'], msg..remove('functionName')..remove('sendPort')))
      );

      // if (await perms.hasAndroidPermission('com.ichi2.anki.permission.READ_WRITE_DATABASE')) {
      //   msg['sendPort'].send(
      //     await futureToResultMap(() async => await methodChannel.invokeMethod(msg['functionName'], msg..remove('functionName')..remove('sendPort')))
      //   );
      // } else {
      //   msg['sendPort'].send({'e': 'Permission to use and modify AnkiDroid database not granted!'});
      // }
    }
  }
}
