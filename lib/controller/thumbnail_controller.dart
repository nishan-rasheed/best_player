import 'dart:developer';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:mx_p/constants/custom_log.dart';
import 'package:mx_p/model/video_meta_model.dart';
import 'package:mx_p/services/thumbnail_services.dart';
import 'package:mx_p/utils/debug_utils.dart';

class ThumbnailController extends ChangeNotifier{

  final ThumbnailServices _thumbnailServices = ThumbnailServices();
  List<VideoMetaModel?> videoMetaList = [];

  addThumbnailToTempList(List<String> videosList)async{
      try {
        final mainStartTime = DateTime.now();
  
      videoMetaList.clear();
      notifyListeners();
       for (var item in videosList) {

         var thumb =  await _thumbnailServices.generateThumbnailAndDurationUsingFfmmpeg(item);
        //var thumb =  await _thumbnailServices.generateThumbnailAndDurationUsingNative(item);
          videoMetaList.add(thumb);
          notifyListeners(); 
          }    

          final mainEndTime = DateTime.now();
      final mainElapsedTime = mainEndTime.difference(mainStartTime);
      customLog('time taken ===$mainElapsedTime');
     
    } catch (e) {
      log('load data error - ${e.toString()}');
    }
   


  
    
     
  }


///
///




}