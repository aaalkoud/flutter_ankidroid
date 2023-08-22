# flutter_ankidroid

This plugin is a flutter wrapper over the [java ankidroid api](https://github.com/ankidroid/Anki-Android/wiki/AnkiDroid-API). 

# Before Starting

## 1. Edit your project's `android/app/build.gradle`

Add `repositories { maven { url "https://jitpack.io" } }` to the end of the file.

## 2. Edit your project's `android/app/src/main/AndroidManifest.xml`

In the opening <Application...> tag, remove the line `android:label="..."`

# Usage

Create an Ankidroid instance with its own isolate by running this:

```final anki = await Ankidroid.createAnkiIsolate();```

Go ahead and use any of the following methods. These methods all return a `Future<Map<String, dynamic>>` that I typedef'ed as `FutureResult<T>`. Each 
map has 2 keys 'v' and 'e', v for the value that the method should return
when no errors occur, and e for any error that occurs. Either v or e is set.
I created an extension that's automatically imported when you import 
`flutter_ankidroid.dart` that adds the methods asError and asValue on 
FutureResult. The `<T>` on FutureResult is just there for me to annotate the
type of value that could be returned. This will all be very clear if you check
out main.dart in the example folder.  

```
anki.addNote(modelId, deckId, fields, tags)
anki.addNotes(modelId, deckId, fieldsList, tagsList)
anki.addMediaFromUri(fileUri, preferredName, mimeType)
anki.findDuplicateNotesWithKey(mid, key)
anki.findDuplicateNotesWithKeys(mid, keys)
anki.getNoteCount(mid)
anki.updateNoteTags(noteId, tags)
anki.updateNoteFields(noteId, fields)
anki.getNote(noteId)
anki.previewNewNote(mid, flds)
anki.addNewBasicModel(name)
anki.addNewBasic2Model(name)
anki.addNewCustomModel(name, fields, cards, qfmt, afmt, css, did, sortf)
anki.currentModelId()
anki.getFieldList(modelId)
anki.modelList()
anki.getModelList(minNumFields)
anki.getModelName(mid)
anki.addNewDeck(deckName)
anki.selectedDeckName()
anki.deckList()
anki.getDeckName(did)
anki.apiHostSpecVersion()
```

# Rant

no but like fr, coding this (which should have taken 0 mental effort; i was just linking kotlin functions to dart functions) was a fcking nightmare. easily the shittiest coding experience i had to do so far. like, i never used kotlin/java before, or coded on android natively, but it still shouldn't have been that bad. idk where to start. i bashed my head on the keyboard alot just to figure out #1. like i get adding this to the library, but like also to every project using the library??????? i kept getting error: fuck is ankidroid.v1.1.0... telling me they don't know where to find it. except using the same code when coding this as an app (not a plugin) worked fine... also i still have no idea what the consequences of #2 are but like ok i guess? the compiler kept telling me to replace it by something to do with android tool or whatever, but also like in greek. i just removed it. then also, why the fuuuuuuck do i have to write 3 files? ankidroid && ankidroid_method... && ankidroid_platform... flutter documentation seriously sucks ass here. also android studio kept going insane and not working correctly. turns out i can't open the library directly; rather, i have to open the example android folder, import my library class, and then ctrl click on that to open the library proj on the side, but sometimes not... then also so much other nasty shit i forgot. this took 4 times the time i think it needed to be coded. :/ i am so burnt out of this shit rn, but like, i think (fingers crossed) i won't have to touch the android folder again. 
