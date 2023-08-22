# flutter_ankidroid

This plugin is a flutter wrapper over the [java AnkiDroid API](https://github.com/ankidroid/Anki-Android/wiki/AnkiDroid-API). 

# Before Starting

## 1. Edit your project's `android/app/build.gradle`

Add `repositories { maven { url "https://jitpack.io" } }` to the end of the file.

## 2. Edit your project's `android/app/src/main/AndroidManifest.xml`

In the opening `<Application...>` tag, remove the line `android:label="..."`

# Usage

Create an Ankidroid instance with its own isolate by running this:

```dart
final anki = await Ankidroid.createAnkiIsolate();
```

Then you could do:

```dart 
final decks = await widget.anki.deckList().asValue();
if (decks != null) {
    print(decks);
} else {
    print(await widget.anki.deckList().asError());
}
```

Or you can go ahead and use any of the following methods.

```dart
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
