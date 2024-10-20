import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'package:crypto/crypto.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/foundation.dart';
import 'package:mx_p/constants/custom_log.dart';
import 'package:mx_p/method_channel/flutter_method_channels.dart';
import 'package:mx_p/model/video_meta_model.dart';
import 'package:mx_p/utils/debug_utils.dart';
import 'package:mx_p/utils/time_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ThumbnailServices {
  //  var box = Hive.box('videoMetaDuration');
  //  List<VideoDurationModel>? videoDurationList ;

  Future<VideoMetaModel?> generateThumbnailAndDurationUsingFfmmpeg(
      String videoPath) async {
    try {
      var tempDir = await getTemporaryDirectory();
      var thumbNailFolder = Directory('${tempDir.path}/thumbnails');

      if (!(await thumbNailFolder.exists())) {
        thumbNailFolder.create();
      } else {
      }

      // final bytes = await File(videoPath).readAsBytes();
      // var hashCodedPath = md5.convert(bytes).toString();

      // List<String> parts = videoPath.split("/");
      // String filename = parts.last;
      // int dotIndex = filename.lastIndexOf(".");
      // if (dotIndex != -1) {
      //   filename = filename.substring(0, dotIndex);
      // }

      var filenameWithoutExtension = path.basenameWithoutExtension(videoPath);

      final thumbnailPath = '${thumbNailFolder.path}/$filenameWithoutExtension.png';



      Future<String> getDurationFuture = _getDuration(videoPath);
      Future<Uint8List> getThumbnailFuture = _getThumbnail(videoPath, thumbnailPath);
      

      final (thumbnail, duration) = await (getThumbnailFuture, getDurationFuture).wait;

      return VideoMetaModel(
            thumbImage: thumbnail,
            videoDuration: duration
          );

      //  final getDuration= await _getDuration(videoPath);
      // final getThumbnail =await _getThumbnail(videoPath, thumbnailPath);
      


      // return VideoMetaModel(
      //       thumbImage: getThumbnail,
      //       videoDuration: getDuration
      //     );
      
    } catch (e) {
      if (kDebugMode) {
        print('Error generating thumbnail: $e');
      }
      return VideoMetaModel();
    }
  }

  Future<VideoMetaModel?> generateThumbnailAndDurationUsingNative(String videoPath) async {
    try {
      customLog("started-----------");

      var tempDir = await getTemporaryDirectory();
      var thumbNailFolder = Directory('${tempDir.path}/thumbnails');

      if (!(await thumbNailFolder.exists())) {
        thumbNailFolder.create();
      } else {}

      customLog("folder created-----------");
      // final bytes = await File(videoPath).readAsBytes();
      // var hashCodedPath = md5.convert(bytes).toString();

      var hashCodedPath = path.basenameWithoutExtension(videoPath);
      // var hashCodedPath = await calculateMD5HashForPath(videoPath);
       //await FlutterMethodChannels.hashFile(videoPath);

      customLog("hash coded-----------$hashCodedPath this");

      final thumbnailPath = '${thumbNailFolder.path}/$hashCodedPath.png';

      final videoDuration = '';
      //await _getDuration(videoPath);

      customLog('thumb path ---$thumbnailPath');

      if (await File(thumbnailPath).exists()) {
        customLog(' thumbnail exists -------------');
        var thumbImg = await File(thumbnailPath).readAsBytes();
        return VideoMetaModel(
            thumbImage: thumbImg, videoDuration: videoDuration);
      } else {
        customLog('getting thumbnail');
        Uint8List? dd =
            await FlutterMethodChannels.getVideoThumbNails(videoPath);

        if (dd != null) {
          // Write the generated thumbnail to the thumbnail folder
          await File(thumbnailPath).writeAsBytes(dd);

          customLog('thubmbnail writed-----------');

          // var thumbImg = await File(thumbnailPath).readAsBytes();
          return VideoMetaModel(thumbImage: dd, videoDuration: videoDuration);
        } else {
          return VideoMetaModel();
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error generating thumbnail: $e');
      }
      return VideoMetaModel();
    }
  }

  static Future<String> _getDuration(String videoPath) async {
    // final data = await FFprobeKit.getMediaInformation(videoPath);
    // final media = data.getMediaInformation();
    // final secondsStr = media?.getDuration();

    // var videotimeFormatted =  TimeUtils.convertStringToDuration(secondsStr ?? '');
    // return videotimeFormatted;

    final data  = await FlutterMethodChannels.getVideoMetadata(videoPath);
   var videotimeFormat = TimeUtils.formatMilliseconds(data);
   return videotimeFormat;
  }


  static Future<Uint8List> _getThumbnail(String videoPath,String thumbnailSavingPath)async{

     if (await File(thumbnailSavingPath).exists()) {
       var thumbImg = await File(thumbnailSavingPath).readAsBytes();
       return thumbImg;
     } else {
        var session = await FFmpegKit.execute(
            '-ss 0 -i "$videoPath" -vf scale=40:40:force_original_aspect_ratio=decrease -vframes 1 \"${thumbnailSavingPath}\"' // Consider removing '-frames:v 1'
          // '-ss 0 -i "$videoPath" -vf scale=40:40:force_original_aspect_ratio=decrease -vframes 1 $thumbnailPath' // Consider removing '-frames:v 1'
            );

        // var session = await FFmpegKit.execute('-i "$videoPath" -vf scale=40:40:force_original_aspect_ratio=decrease ''-vframes 1 "$thumbnailPath"');

        final returnCode = await session.getReturnCode();

        if (ReturnCode.isSuccess(returnCode)) {
          var thumbImg = await File(thumbnailSavingPath).readAsBytes();
          return thumbImg;
        } else {
          if (kDebugMode) {
            print('FFmpeg command failed with return code $returnCode.');
          }
          throw Exception();
        }
       
     }
  }



  Future<String> calculateMD5HashForPath(String videoPath) async {
    final bytes = await File(videoPath).readAsBytes();
    final hashCodedPath = md5.convert(bytes).toString();
    return hashCodedPath;
  }
}
