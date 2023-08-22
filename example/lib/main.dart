import 'package:flutter/material.dart';
import 'package:flutter_ankidroid/flutter_ankidroid.dart';


void main() async {
  final anki = await Ankidroid.createAnkiIsolate();
  
  runApp(MainApp(anki));
}

class MainApp extends StatefulWidget {
  const MainApp(this.anki, {super.key});
  final Ankidroid anki;

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  String text = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      
                      final result1 = await widget.anki.test().asValue();
                      final result2 = await widget.anki.deckList().asValue();
                      final result3 = await widget.anki.selectedDeckName().asValue();
                      final result4 = await widget.anki.currentModelId().asValue();
                      final result5 = await widget.anki.apiHostSpecVersion().asValue();
                      
                      /// if you get nulls, comment out above and write this
                      // final result1 = await widget.anki.test().asError();
                      // final result2 = await widget.anki.deckList().asError();
                      // final result3 = await widget.anki.selectedDeckName().asError();
                      // final result4 = await widget.anki.currentModelId().asError();
                      // final result5 = await widget.anki.apiHostSpecVersion().asError();
                      
                      final results = [result1, result2, result3, result3, result4, result5];
                      
                      setState(() => text = results.join('\n'));
                      

                      /// those are all the methods in the Anki AddContentApi.
                      /// they sometimes used the words `mid` and `did`, and at other times used `modelId`
                      /// `deckId` for argument names. This is also the case for some other
                      /// argments too. I reimpled stuff with mostly the same names anki api
                      /// uses. Some methods that you'd expect to return lists actually return 
                      /// maps and not lists, like `deckList()`. 
                      /// 
                      /// anki.addNote(modelId, deckId, fields, tags)
                      /// anki.addNotes(modelId, deckId, fieldsList, tagsList)
                      /// anki.addMediaFromUri(fileUri, preferredName, mimeType) # for this i created the addMedia() method
                      /// anki.findDuplicateNotesWithKey(mid, key) # in the original api those 2 were called findDuplicateNotes
                      /// anki.findDuplicateNotesWithKeys(mid, keys) # but dart has to have different names for them so I added With..
                      /// anki.getNoteCount(mid)
                      /// anki.updateNoteTags(noteId, tags)
                      /// anki.updateNoteFields(noteId, fields)
                      /// anki.getNote(noteId)
                      /// anki.previewNewNote(mid, flds)
                      /// anki.addNewBasicModel(name)
                      /// anki.addNewBasic2Model(name)
                      /// anki.addNewCustomModel(name, fields, cards, qfmt, afmt, css, did, sortf)
                      /// anki.currentModelId()
                      /// anki.getFieldList(modelId)
                      /// anki.modelList()
                      /// anki.getModelList(minNumFields)
                      /// anki.getModelName(mid)
                      /// anki.addNewDeck(deckName)
                      /// anki.selectedDeckName()
                      /// anki.deckList()
                      /// anki.getDeckName(did)
                      /// anki.apiHostSpecVersion()
                    }, 
                    child: const Text('call anki'),
                  ),
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 30),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    /// not really necessary here because app soon terminates, but if you only had a 
    /// part of your app that deals with anki, you could create Ankidroid() and pass
    /// it there and then kill the isolate on leaving that part of the app, but tbh
    /// idk if that's the way we're supposed to deal with isolates. maybe creating
    /// the isolate in main and never killing it is better? idk 
    widget.anki.killIsolate(); 
  }
}

