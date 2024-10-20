package com.example.mx_p

import android.graphics.Bitmap
import android.media.MediaMetadataRetriever
import android.media.ThumbnailUtils
import android.os.Build
import android.util.Log
import android.util.Size
import android.widget.Toast
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.io.File
import java.io.FileInputStream
import java.security.MessageDigest


const val TAG = "FlutterLog"

class MainActivity: FlutterActivity() {
    private val channel = "deviceInfoChannel";

    override fun configureFlutterEngine( flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val method = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
        method.setMethodCallHandler { call, result ->
            when (call.method) {
                "getDeviceSdk" -> {
                    println("device sdk fetching")
                    result.success(android.os.Build.VERSION.SDK_INT)
                }
                "logData" -> {
                    val message = call.argument<String>("message")
                    Log.d(TAG, "your log $message")
                    Toast.makeText(this, message, Toast.LENGTH_SHORT).show()
                    result.success(message)

                }
                "getVideoMetadata" -> {
                    val filePath = call.argument<String>("filePath")
                    if (filePath != null) {
                        val metadata = getVideoMetadata(filePath)
                        result.success(metadata)
                    } else {
                        result.error("INVALID_ARGUMENT", "File path is null", null)
                    }
                }
                "hashVideoFile" -> {
                    val filePath = call.argument<String>("filePath")
                    if (filePath != null) {
                        val hash = hashFile(filePath)
                        result.success(hash)
                    }
                    else {
                        result.error("INVALID_ARGUMENT", "File path is null", null)
                    }
                }
                "getVideoThumbnail" -> {

                    val filePath = call.argument<String>("videoPath")
                    Log.d(TAG, "your log $filePath")
                    if (filePath != null) {
                        val thumbnail = getVideoThumbnail(filePath)
                        result.success(thumbnail)
                    } else {
                        result.error("INVALID_ARGUMENT", "File path is null", null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }

        }
    }

    private fun getVideoMetadata(filePath: String): Map<String, String> {
        val retriever = MediaMetadataRetriever()
        retriever.setDataSource(filePath)

        val metadata = mutableMapOf<String, String>()
        metadata["duration"] = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION) ?: "N/A"
//        metadata["mimeType"] = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_MIMETYPE) ?: "N/A"
//        //metadata["codec"] = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_CODEC) ?: "N/A"
//        metadata["width"] = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_WIDTH) ?: "N/A"
//        metadata["height"] = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_HEIGHT) ?: "N/A"

        retriever.release()
        return metadata
    }




    // Extract video thumbnail as byte array
    private fun getVideoThumbnail(filePath: String): ByteArray? {


        val retriever = MediaMetadataRetriever()
        retriever.setDataSource(filePath)

        // Get the frame at the 1st second (you can modify the time in microseconds)
        val bitmap = retriever.getFrameAtTime(100000, MediaMetadataRetriever.OPTION_CLOSEST_SYNC)
        retriever.release()

        // Reduce the bitmap resolution
        val scaledBitmap = bitmap?.let {
            Bitmap.createScaledBitmap(it, 350, 350, true)  // Scale down to 100x100 pixels or another smaller resolution
        }

        // Convert the Bitmap to ByteArray
        return scaledBitmap?.let {
            val stream = ByteArrayOutputStream()
            it.compress(Bitmap.CompressFormat.JPEG, 20, stream)
            stream.toByteArray()
        }
    }


    ///hash video file
    private fun hashFile(filePath: String): String {

        Log.d(TAG, "your log for file $filePath")
        val md = MessageDigest.getInstance("MD5")
        val fis = FileInputStream(filePath)
        val buffer = ByteArray(8192) // Read 8KB chunks
        var bytesRead: Int

        while (fis.read(buffer).also { bytesRead = it } != -1) {
            md.update(buffer, 0, bytesRead)
        }
        fis.close()

        // Convert the byte array into a hexadecimal string
        return md.digest().joinToString("") { byte ->
            String.format("%02x", byte)
        }
    }





}

