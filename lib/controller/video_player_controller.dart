import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mx_p/constants/custom_log.dart';
import 'package:mx_p/services/volume_services.dart';
import 'package:mx_p/utils/time_utils.dart';

class VideoPlayerProvider extends ChangeNotifier{

  ChewieController? chewieController;


///
///
///

bool isPlayerInitialized = false;

checkPlayerInitialized(bool value){
  isPlayerInitialized = value;
}


bool isMKVideoPlaying = false;

getVideoPlayingState(bool videoPlayState){
  customLog('currentState---$videoPlayState');
  isMKVideoPlaying = videoPlayState;
  notifyListeners();
}


Duration videoPosition = const Duration();

getVideoDuration(Duration position){
  videoPosition = position;
  notifyListeners();
}




//drawr content

WidgetBuilder drawerContent = (BuildContext context) =>const Center(child: Text('Default Drawer Content'));

upDateDrawerContent(WidgetBuilder child){
  drawerContent = child;
  notifyListeners();
}

//audio

int selectedAudioTrack = 0;
bool isAudioDisabled = false;

updateAudioTrack(int index){
 selectedAudioTrack = index;
 isAudioDisabled = false;
 notifyListeners();
}

disableAudio(bool value){
selectedAudioTrack = -1;
isAudioDisabled = value;
notifyListeners();
}


//subtitle

int selectedSubtitleTrack = 0;
bool isSubtitleDisabled = false;


updateSubtitleTrack(int index){
 selectedSubtitleTrack = index;
 notifyListeners();
}

disableSubtitle(bool value){
selectedSubtitleTrack = -1;
isSubtitleDisabled = value;
notifyListeners();
}


// seekMkVideo(Duration position){
//   videoPosition = position;
//   notifyListeners();
// }


////


 initialiseVideoPlayerController(ChewieController controller){
  chewieController = controller;
  notifyListeners();
 }

 Duration? currentDuration;
 addVideoListner(){
  chewieController?.videoPlayerController.addListener(() {
    currentDuration = chewieController?.videoPlayerController.value.position;
    notifyListeners();
  },);
 }


 bool isStatusBarShowing = true;

 swichStatusBarView(bool value){
 
   isStatusBarShowing = value;
   notifyListeners();
 }

 //video controlls 

 playPauseVideo(){
  chewieController?.isPlaying ?? false?
  chewieController?.pause():chewieController?.play();
  notifyListeners();
 }


 seekVideo(Duration seekedValue){
  chewieController?.seekTo(seekedValue);
 }


/// volume controlls  to update ui based on volume change
/// 

 double videoVolume = 0;

 updateVideoVolumeOnVerticalDrag(double value){
  videoVolume = value;
  notifyListeners();
 }

 bool showVolumeBar = false;

 showOrHideVolumeBar(bool value){
  showVolumeBar = value;
  notifyListeners();
 }


}