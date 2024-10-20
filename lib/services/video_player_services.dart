import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:mx_p/constants/custom_log.dart';
import 'package:mx_p/constants/global_variables.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../controller/video_player_controller.dart';

class VideoPlayerServices {
  late VideoPlayerController videoPlayerController;
  // int sdkVersion = 0;

  Future<ChewieController> initializeVideoController({required String videoPath,bool? isFile}) async {
  
    if (isFile??true) {
      videoPlayerController = VideoPlayerController.file(File(videoPath));
    } else {
      videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(videoPath));
    }


    await videoPlayerController.initialize();
    return ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: videoPlayerController.value.aspectRatio,
      autoPlay: true,
      looping: true,
      showControls: false,
    );
  }

  disposeVideoController() {
    videoPlayerController.dispose();
  }

 static toggleStatusbarAndNavbar(BuildContext context) {

    if (appSdkVersion < 29) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    } else {
      
     var isShowing = context.read<VideoPlayerProvider>().isStatusBarShowing;
      if (isShowing) {
        hideStatusBar();
      } else {
        showStatusBar();
      }
    }
  }

 static hideStatusBar(){
     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

 static showStatusBar(){
     SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  //change orientation mode

 static chooseOrientModeOnStart(Player player) {
    num videoWidth = player.state.width??0;
    //videoPlayerController.value.size.width;
    num videoHeight = player.state.height??0;
    //videoPlayerController.value.size.height;

    final isLandscapeVideo = videoWidth > videoHeight;
    final isPortraitVideo = videoWidth < videoHeight;

    if (isLandscapeVideo) {
      enterLandscapeMode();
    } else if (isPortraitVideo) {
      enterPortraitMode();
    }

    /// Otherwise if h == w (square video)
    else {
      SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    }
  }

 static enterLandscapeMode() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

 static enterPortraitMode() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }


}
