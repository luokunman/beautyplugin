package com.jxtech.beautyplugin.beautyplugin

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.util.Base64
import android.util.Log

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import com.idphoto.Beauty
import com.idphoto.FairLevel

import java.io.ByteArrayOutputStream
import java.io.File

/** BeautypluginPlugin */
class BeautypluginPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context: Context

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "beautyplugin")
    context = flutterPluginBinding.applicationContext
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "version") {
      // result.success("Android ${android.os.Build.VERSION.RELEASE}")
      result.success(Beauty.BeautyVersion())
    } else if (call.method == "beauty") {
      Log.d(TAG, "onMethodCall: fairLevel ${call.argument<Map<String, Int>>("fairLevel")}")
      try {
        val bytes = beauty(
          call.argument<ByteArray>("image"),
          call.argument<String>("faceInfo"),
          call.argument<Map<String, Int>>("fairLevel")
        )
        if (bytes == null) {
          result.error("", "bytes == null", "")
          return
        }
        result.success(bytes)
      } catch (e: Exception) {
        e.printStackTrace()
        result.error("", e.message, e.toString())
      }
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun beauty(image: ByteArray?, faceInfo: String?, fairLevel: Map<String, Int>?): ByteArray? {
      if (image == null || faceInfo == null || fairLevel == null) {
          return null
      }
      val bitmap = Beauty.beauty(fairLevel.toFairLevel(), faceInfo.base64(), image.decodeBitmap())
      return bitmap?.toByteArray()
  }

  
  private fun String.base64(): ByteArray {
    return Base64.decode(this, Base64.DEFAULT)
  }
  
  private fun ByteArray.decodeBitmap(): Bitmap {
    val file = File(context.cacheDir, "beauty_temp_image.png")
    if (file.exists()) {
        file.delete()
    }
    file.writeBytes(this)
    return BitmapFactory.decodeFile(file.path)
  }
    
  private fun Bitmap.toByteArray(): ByteArray {
    val byteArrayOutputStream = ByteArrayOutputStream()
    compress(Bitmap.CompressFormat.PNG, 100, byteArrayOutputStream)
    return byteArrayOutputStream.toByteArray()
  }
  
  private fun Map<String, Int>.toFairLevel(): FairLevel {
    val fairLevel = FairLevel()
    fairLevel.coseye = get("coseye")?.toDouble() ?: 0.0
    fairLevel.facelift = get("facelift")?.toDouble() ?: 0.0
    fairLevel.leyelarge = get("leyelarge")?.toDouble() ?: 0.0
    fairLevel.reyelarge = get("reyelarge")?.toDouble() ?: 0.0
    fairLevel.skinsoft = get("skinsoft")?.toDouble() ?: 0.0
    fairLevel.skinwhite = get("skinwhite")?.toDouble() ?: 0.0
    return fairLevel
  }

  companion object {
    private const val TAG = "FlutterBeautyPlugin"
  }
}
