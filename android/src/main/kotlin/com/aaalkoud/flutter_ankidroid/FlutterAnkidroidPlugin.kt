package com.aaalkoud.flutter_ankidroid

import android.content.Intent
import android.content.Context
import android.content.pm.PackageManager
import androidx.core.content.ContextCompat
import androidx.core.content.FileProvider
import java.io.File

import com.ichi2.anki.api.AddContentApi

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlutterAnkidroidPlugin */
class FlutterAnkidroidPlugin: FlutterPlugin, MethodCallHandler {
  
  private lateinit var channel : MethodChannel
  private lateinit var context: Context
  private lateinit var api : AddContentApi

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_ankidroid")
    context = flutterPluginBinding.applicationContext
    api = AddContentApi(context)
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    val permission = ContextCompat.checkSelfPermission(context, "com.ichi2.anki.permission.READ_WRITE_DATABASE")
    if (permission != PackageManager.PERMISSION_GRANTED) {
      result.error("Permission to use and modify AnkiDroid database not granted!", "Permission to use and modify AnkiDroid database not granted!", null)
    }

    when (call.method) {
      "test" -> { result.success("Test Successful!") }

      "addNote" -> {
        val modelId = call.argument<Long>("modelId")!!
        val deckId = call.argument<Long>("deckId")!!
        val fields = call.argument<List<String>>("fields")!!.toTypedArray()
        val tags = call.argument<List<String>>("tags")!!.toSet()

        result.success(api.addNote(modelId, deckId, fields, tags))
      }

      "addNotes" -> {
        val modelId = call.argument<Long>("modelId")!!
        val deckId = call.argument<Long>("deckId")!!
        val fieldsList = call.argument<List<List<String>>>("fieldsList")!!.map { it.toTypedArray() }
        val tagsList = call.argument<List<List<String>>>("tagsList")!!.map { it.toSet() }

        result.success(api.addNotes(modelId, deckId, fieldsList, tagsList))
      }

      "addMedia" -> {
        val bytes = call.argument<ByteArray>("bytes")!!
        val preferredName = call.argument<String>("preferredName")!!.replace(' ', '_')
        val mimeType = call.argument<String>("mimeType")!!

        val tempfile = File(context.filesDir, preferredName)
        tempfile.writeBytes(bytes)

        val uri = FileProvider.getUriForFile(context,context.packageName + ".fileprovider", tempfile)
        context.grantUriPermission("com.ichi2.anki", uri, Intent.FLAG_GRANT_READ_URI_PERMISSION)

        val name = api.addMediaFromUri(uri, preferredName, mimeType)
        if (name == null) {
          result.error("Adding media failed", "Adding media failed", null)
        } else {
          result.success(name)
        }

        tempfile.deleteOnExit()
      }

      "findDuplicateNotesWithKey" -> {
        val mid = call.argument<Long>("mid")!!
        val key = call.argument<String>("key")!!
        val dupes = api.findDuplicateNotes(mid, key).map {hashMapOf(
          "id" to it.id,
          "fields" to it.fields.toList(),
          "tags" to it.tags.toList()
        )}

        result.success(dupes)
      }

      "findDuplicateNotesWithKeys" -> {
        val mid = call.argument<Long>("mid")!!
        val keys = call.argument<List<String>>("keys")!!
        val dupes = api.findDuplicateNotes(mid, keys)

        val list = mutableListOf<List<Map<String, Any>>>()
        for (i in 0 until dupes.size()) {
          val innerList = dupes.valueAt(i)

          if (innerList != null) {

            list.add(innerList.map {hashMapOf(
              "id" to it.id,
              "fields" to it.fields.toList(),
              "tags" to it.tags.toList()
            )})

          } else {
            list.add(listOf())
          }
        }

        result.success(list)
      }

      "getNoteCount" -> {
        val mid = call.argument<Long>("mid")!!

        result.success(api.getNoteCount(mid))
      }

      "updateNoteTags" -> {
        val noteId = call.argument<Long>("noteId")!!
        val tags = call.argument<List<String>>("tags")!!

        result.success(api.updateNoteTags(noteId, tags.toSet()))
      }

      "updateNoteFields" -> {
        val noteId = call.argument<Long>("noteId")!!
        val fields = call.argument<List<String>>("fields")!!

        result.success(api.updateNoteFields(noteId, fields.toTypedArray()))
      }

      "getNote" -> {
        val noteId = call.argument<Long>("noteId")!!
        val note = api.getNote(noteId)

        result.success(hashMapOf(
          "id" to note.id,
          "fields" to note.fields.toList(),
          "tags" to note.tags.toList()
        ))
      }

      "previewNewNote" -> {
        val mid = call.argument<Long>("mid")!!
        val flds = call.argument<List<String>>("flds")!!

        result.success(api.previewNewNote(mid, flds.toTypedArray()))
      }

      "addNewBasicModel" -> {
        val name = call.argument<String>("name")!!

        result.success(api.addNewBasicModel(name))
      }

      "addNewBasic2Model" -> {
        val name = call.argument<String>("name")!!

        result.success(api.addNewBasic2Model(name))
      }

      "addNewCustomModel" -> {
        val name = call.argument<String>("name")!!
        val fields = call.argument<List<String>>("fields")!!
        val cards = call.argument<List<String>>("cards")!!
        val qfmt = call.argument<List<String>>("qfmt")!!
        val afmt = call.argument<List<String>>("afmt")!!
        val css = call.argument<String>("css")!!
        val did = call.argument<Int?>("did")?.toLong() // <Long?> doesn't work here, idk y.
        val sortf = call.argument<Int?>("sortf")

        result.success(api.addNewCustomModel(name, fields.toTypedArray(), cards.toTypedArray(), qfmt.toTypedArray(), afmt.toTypedArray(), css, did, sortf))
      }

      "currentModelId" -> result.success(api.currentModelId)

      "getFieldList" -> {
        val modelId = call.argument<Long>("modelId")!!

        result.success(api.getFieldList(modelId).toList())
      }

      "modelList" -> result.success(api.modelList)

      "getModelList" -> {
        val minNumFields = call.argument<Int>("minNumFields")!!

        result.success(api.getModelList(minNumFields))
      }

      "getModelName" -> {
        val mid = call.argument<Long>("mid")!!

        result.success(api.getModelName(mid))
      }

      "addNewDeck" -> {
        val deckName = call.argument<String>("deckName")!!

        result.success(api.addNewDeck(deckName))
      }

      "selectedDeckName" -> result.success(api.selectedDeckName)

      "deckList" -> result.success(api.deckList)

      "getDeckName" -> {
        val did = call.argument<Long>("did")!!

        result.success(api.getDeckName(did))
      }

      "apiHostSpecVersion" -> result.success(api.apiHostSpecVersion)

      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
