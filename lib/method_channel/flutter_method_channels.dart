import 'package:flutter/services.dart';
import 'package:mx_p/constants/custom_log.dart';
import 'package:mx_p/constants/global_variables.dart';
import 'package:mx_p/utils/time_utils.dart';

class FlutterMethodChannels{

static const platform = MethodChannel('deviceInfoChannel');

static  getSdkVersion() async {
  
  try {
    final int version = await platform.invokeMethod('getDeviceSdk');
    appSdkVersion = version;
  } on PlatformException catch (e) {
    throw Exception(e);
  }
}

static  logData() async {
  
  try {
     await platform.invokeMethod('logData',{'message':'Hello nishan'});
  } on PlatformException catch (e) {
    throw Exception(e);
  }
}


static Future<String> hashFile(String filePath) async {
  try {
    final String result = await platform.invokeMethod('hashVideoFile', {'filePath': filePath});
    customLog('result is ==$result');
    return result;
  } on PlatformException catch (e) {
    return "Failed to hash file: '${e.message}'.";
  }
}


static Future<Uint8List?> getVideoThumbNails(String filePath)async{
 try {
  //await platform.invokeMethod('getVideoThumbnail',{'videoPath':filePath});

   final Uint8List? thumbnail =  await platform.invokeMethod('getVideoThumbnail',{'videoPath':filePath});
    return thumbnail;
 } catch (e) {
   customLog("Failed to get video thumbnail: '${e.toString()}'.");
   throw Exception(e);
 }
}


static Future<num> getVideoMetadata(String filePath)async{
 try {
   final videoDuration =  await platform.invokeMethod('getVideoMetadata',{'filePath':filePath});

    var durationInMillisec= num.parse(videoDuration['duration']);
    return durationInMillisec;
 } catch (e) {
   customLog("Failed to get video thumbnail: '${e.toString()}'.");
   throw Exception(e);
 }
}

}