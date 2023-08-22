import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'future_result.dart';
import 'ankidroid_platform_interface.dart';

class MethodChannelAnkidroid extends AnkidroidPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('ankidroid');

  @override
  FutureResult<String> test() async => futureResult(
    methodChannel.invokeMethod('test')
  );

  @override
  FutureResult<int?> addNote(int modelId, int deckId, List<String> fields, List<String> tags) async => futureResult<int?>(
    methodChannel.invokeMethod('addNote', {
      'modelId': modelId, 
      'deckId': deckId, 
      'fields': fields,
      'tags': tags
    })
  );

  @override
  FutureResult<int?> addNotes(int modelId, int deckId, List<List<String>> fieldsList, List<List<String>> tagsList) async => futureResult(
    methodChannel.invokeMethod('addNotes', {
      'modelId': modelId, 
      'deckId': deckId, 
      'fieldsList': fieldsList, 
      'tagsList': tagsList
    })
  );

  @override
  FutureResult<String?> addMedia(Uint8List bytes, String preferredName, String mimeType) async {
    assert(mimeType == 'audio' || mimeType == 'image');

    return futureResult(
      methodChannel.invokeMethod('addMedia', {
        'bytes': bytes,
        'preferredName': preferredName, 
        'mimeType': mimeType
      })
    );
  }

  @override
  FutureResult<List<Map<Object?, Object?>>?> findDuplicateNotesWithKey(int mid, String key) async => futureResult(
    methodChannel.invokeListMethod('findDuplicateNotesWithKey', {
      'mid': mid,
      'key': key
    })
  );

  @override
  FutureResult<List<List<Map<Object?, Object?>>>?> findDuplicateNotesWithKeys(int mid, List<String> keys) async => futureResult(
    methodChannel.invokeListMethod('findDuplicateNotesWithKeys', {
      'mid': mid,
      'keys': keys
    })
  );

  @override
  FutureResult<int?> getNoteCount(int mid) async => futureResult(
    methodChannel.invokeMethod('getNoteCount', {
      'mid': mid
    })
  );

  @override
  FutureResult<bool?> updateNoteTags(int noteId, List<String> tags) async => futureResult(
    methodChannel.invokeMethod('updateNoteTags', {
      'noteId': noteId,
      'tags': tags
    })
  );

  @override
  FutureResult<bool?> updateNoteFields(int noteId, List<String> fields) async => futureResult(
    methodChannel.invokeMethod('updateNoteFields', {
      'noteId': noteId,
      'fields': fields
    })
  );

  @override
  FutureResult<Map<String, Object>?> getNote(int noteId) async => futureResult(
    methodChannel.invokeMapMethod('getNote', {
      'noteId': noteId
    })
  );

  @override
  FutureResult<Map<String, Object>?> previewNewNote(int mid, List<String> flds) async => futureResult(
    methodChannel.invokeMapMethod('previewNewNote', {
      'mid': mid,
      'flds': flds
    })
  );

  @override
  FutureResult<int?> addNewBasicModel(String name) async => futureResult(
    methodChannel.invokeMethod('addNewBasicModel', {
      'name': name
    })
  );

  @override
  FutureResult<int?> addNewBasic2Model(String name) async => futureResult(
    methodChannel.invokeMethod('addNewBasic2Model', {
      'name': name
    })
  );

  @override
  FutureResult<int?> addNewCustomModel(String name, List<String> fields, List<String> cards, List<String> qfmt, List<String> afmt, String css, int? did, int? sortf) async => futureResult(
    methodChannel.invokeMethod('addNewCustomModel', {
      'name': name, 
      'fields': fields, 
      'cards': cards, 
      'qfmt': qfmt, 
      'afmt': afmt, 
      'css': css, 
      'did': did,
      'sortf': sortf
    })
  );

  @override
  FutureResult<int?> currentModelId() async => futureResult(
    methodChannel.invokeMethod('currentModelId')
  );

  @override
  FutureResult<List<String>?> getFieldList(int modelId) async => futureResult(
    methodChannel.invokeListMethod('getFieldList', {
      'modelId': modelId
    })
  );

  @override
  FutureResult<Map<int, String>?> modelList() async => futureResult(
    methodChannel.invokeMapMethod('modelList')
  );

  /// all models with minNumFields. 0 would show all
  @override
  FutureResult<Map<int, String>?> getModelList(int minNumFields) async => futureResult(
    methodChannel.invokeMapMethod('getModelList', {
      'minNumFields': minNumFields
    })
  );

  @override
  FutureResult<String?> getModelName(int mid) async => futureResult(
    methodChannel.invokeMethod('getModelName', {
      'mid': mid
    })
  );

  @override
  FutureResult<int?> addNewDeck(String deckName) async => futureResult(
    methodChannel.invokeMethod('addNewDeck', {
      'deckName': deckName
    })
  );

  @override
  FutureResult<String?> selectedDeckName() async => futureResult(
    methodChannel.invokeMethod('selectedDeckName')
  );

  @override
  FutureResult<Map<int, String>?> deckList() async => futureResult(
    methodChannel.invokeMapMethod('deckList')
  );

  @override
  FutureResult<String?> getDeckName(int did) async => futureResult(
    methodChannel.invokeMethod('getDeckName', {
      'did': did
    })
  );

  @override
  FutureResult<int?> apiHostSpecVersion() async => futureResult(
    methodChannel.invokeMethod('apiHostSpecVersion')
  );
}
