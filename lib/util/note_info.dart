/// You can use this with functions that return Java NoteInfos or Lists of NoteInfos
class NoteInfo {
  final int id;
  final List<String> fields;
  final List<String> tags;

  const NoteInfo(this.id, this.fields, this.tags);
  
  NoteInfo.from(Map<dynamic, dynamic> map) : 
    id = map['id']! as int, fields = List<String>.from(map['fields']!), tags = List<String>.from(map['tags']!);
  
  static List<NoteInfo> fromList(List<Map<dynamic, dynamic>> list) {
    return list.map((e) => NoteInfo.from(e)).toList();
  }

  String get key => fields[0];
}
