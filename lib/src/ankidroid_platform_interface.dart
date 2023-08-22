import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'future_result.dart';
import 'ankidroid_method_channel.dart';

abstract class AnkidroidPlatform extends PlatformInterface {
  AnkidroidPlatform() : super(token: _token);

  static final Object _token = Object();

  static AnkidroidPlatform _instance = MethodChannelAnkidroid();

  static AnkidroidPlatform get instance => _instance;

  static set instance(AnkidroidPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }
  
  FutureResult<String?> test() => throw UnimplementedError('Function not implemented on platform');

  FutureResult<int?> addNote(int modelId, int deckId, List<String> fields, List<String> tags) =>
    throw UnimplementedError('Function not implemented on platform');

  FutureResult<int?> addNotes(int modelId, int deckId, List<List<String>> fieldsList, List<List<String>> tagsList) =>
    throw UnimplementedError('Function not implemented on platform');

  FutureResult<String?> addMedia(Uint8List bytes, String preferredName, String mimeType) => throw UnimplementedError('Function not implemented on platform');

  FutureResult<List<Map<Object?, Object?>>?> findDuplicateNotesWithKey(int mid, String key)  =>
    throw UnimplementedError('Function not implemented on platform');

  FutureResult<List<List<Map<Object?, Object?>>>?> findDuplicateNotesWithKeys(int mid, List<String> keys) =>
    throw UnimplementedError('Function not implemented on platform');
  
  FutureResult<int?> getNoteCount(int mid) =>
    throw UnimplementedError('Function not implemented on platform');
  
  FutureResult<bool?> updateNoteTags(int noteId, List<String> tags) =>
    throw UnimplementedError('Function not implemented on platform');
  
  FutureResult<bool?> updateNoteFields(int noteId, List<String> fields) =>
    throw UnimplementedError('Function not implemented on platform');
  
  FutureResult<Map<String, Object>?> getNote(int noteId) =>
    throw UnimplementedError('Function not implemented on platform');
  
  FutureResult<Map<String, Object>?> previewNewNote(int mid, List<String> flds) =>
    throw UnimplementedError('Function not implemented on platform');
  
  FutureResult<int?> addNewBasicModel(String name) =>
    throw UnimplementedError('Function not implemented on platform');
  
  FutureResult<int?> addNewBasic2Model(String name) =>
    throw UnimplementedError('Function not implemented on platform');

  FutureResult<int?> addNewCustomModel(String name, List<String> fields, List<String> cards, List<String> qfmt, List<String> afmt, String css, int? did, int? sortf) =>
    throw UnimplementedError('Function not implemented on platform');
  
  FutureResult<int?> currentModelId() =>
    throw UnimplementedError('Function not implemented on platform');
  
  FutureResult<List<String>?> getFieldList(int modelId) =>
    throw UnimplementedError('Function not implemented on platform');
  
  FutureResult<Map<int, String>?> modelList() =>
    throw UnimplementedError('Function not implemented on platform');
  
  FutureResult<Map<int, String>?> getModelList(int minNumFields) =>
    throw UnimplementedError('Function not implemented on platform');
  
  FutureResult<String?> getModelName(int mid) =>
    throw UnimplementedError('Function not implemented on platform');
  
  FutureResult<int?> addNewDeck(String deckName) =>
    throw UnimplementedError('Function not implemented on platform');
  
  FutureResult<String?> selectedDeckName() =>
    throw UnimplementedError('Function not implemented on platform');
  
  FutureResult<Map<int, String>?> deckList() =>
    throw UnimplementedError('Function not implemented on platform');
  
  FutureResult<String?> getDeckName(int did) =>
    throw UnimplementedError('Function not implemented on platform');
  
  FutureResult<int?> apiHostSpecVersion() =>
    throw UnimplementedError('Function not implemented on platform');
}
