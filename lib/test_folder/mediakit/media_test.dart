import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:mx_p/constants/app_constants.dart';
import 'package:mx_p/constants/custom_log.dart';
import 'package:mx_p/services/volume_services.dart';
import 'package:mx_p/view/video_show/shared/timer_manager.dart';
import 'package:mx_p/view/video_show/widgets/custom_bottom_video_controlls.dart';
import 'package:provider/provider.dart';
import '../../controller/video_player_controller.dart';
import '../../services/video_player_services.dart';
import '../../view/video_show/widgets/custom_top_video_controll.dart';
import '../../view/video_show/widgets/vertical_gesture_slider_widget.dart';

class MediaDemoTest extends StatefulWidget {
  const MediaDemoTest({
    super.key,
    required this.filePath,
  });

  final String filePath;

  @override
  State<MediaDemoTest> createState() => _MediaDemoTestState();
}

class _MediaDemoTestState extends State<MediaDemoTest> {
  // final VideoPlayerServices _videoPlayerServices = VideoPlayerServices();
  final _volumeServices = VolumeServices();

  Player player = Player();
  VideoController? controller;

  //ui
  // Timer? _timer;
  
  late double _currentVolumeLevel;

  
  //local data 

  List<AudioTrack>? audioTracks;



  late final GlobalKey<VideoState> key = GlobalKey<VideoState>();


  @override
  void initState() {
    super.initState();

      _stopTimerAfterToggleStatusBar();
     initialiseVideo();

    SystemChrome.setSystemUIChangeCallback((systemOverlaysAreVisible) async {
      customLog(systemOverlaysAreVisible);
      context
          .read<VideoPlayerProvider>()
          .swichStatusBarView(systemOverlaysAreVisible);
      if (systemOverlaysAreVisible) {
        TimerManager.timer = Timer.periodic(Duration(milliseconds: AppConstants.autoHideStatusBarDuration), (_) {
          _stopTimerAfterToggleStatusBar();
        });
      }
    });
  }

  Future initialiseVideo() async {
      await player.open(Media(widget.filePath),);
       controller = VideoController(player,);
    //add listner
    listenVideoStateAndPosition();
    listenVolumeChanges();
  }

  listenVolumeChanges() {
    if (mounted) {
      _volumeServices.startVolumeListner(
      (volume) {

        setSystemVolumeToVideoVolume(volume);
        context.read<VideoPlayerProvider>().updateVideoVolumeOnVerticalDrag(volume);    
      },
    );
    }
    
  }

  listenVideoStateAndPosition() {
    if (mounted) {
      
      //listen playing state
      player.stream.playing.listen(
      (bool playing) {
        context.read<VideoPlayerProvider>().getVideoPlayingState(playing);
      },
    );

    //listen position
    player.stream.position.listen(
      (Duration position) {
        context.read<VideoPlayerProvider>().getVideoDuration(position);
      },
    );
   
    //listen width
     player.stream.width.listen((event) {
      if (event !=0 && event!=null) {
        audioTracks = player.state.tracks.audio;
        // VideoPlayerServices.chooseOrientModeOnStart(player);
        chooseOrientation();
         context.read<VideoPlayerProvider>().checkPlayerInitialized(true);
        
      }
    },);


    }
    
  }



  chooseOrientation(){
  VideoPlayerServices.chooseOrientModeOnStart(player);
  
 }

  setSystemVolumeToVideoVolume(double currentVolume) {
    _currentVolumeLevel = currentVolume;
  }

  _stopTimerAfterToggleStatusBar() {
    VideoPlayerServices.toggleStatusbarAndNavbar(context);
    TimerManager.timer?.cancel();
  }

  var dd = Duration.zero;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context,orientation) {
        return AnnotatedRegion(
          value: SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.black,
            statusBarIconBrightness: Brightness.light,
          ),
          child: PopScope(
            onPopInvoked: (didPop) {
              if (orientation != Orientation.portrait) {
                VideoPlayerServices.enterPortraitMode();
              }
              
            },
            child: Scaffold(
              drawerScrimColor: Colors.transparent,
              onEndDrawerChanged: (isOpened) {
                if (isOpened) {
                  _stopTimerAfterToggleStatusBar();
                }
              },
              
              endDrawer: Drawer(
                backgroundColor: Colors.black87.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.r)
                ),
                child: Selector<VideoPlayerProvider,WidgetBuilder>(
                  selector: (p0, p1) => p1.drawerContent,                  
                  builder: (context, drawerContent, child) => 
                  Builder(builder: drawerContent)),
              ),
              body:
              // controller!=null? 
                  Selector<VideoPlayerProvider,bool>(
                    selector: (p0, p1) => p1.isPlayerInitialized,
                    builder: (context, isPlayerInitialized, child) => 
                    isPlayerInitialized?
                    Stack(
                        children: [
                          GestureDetector(
                              onVerticalDragUpdate: (details) {
                                context
                                    .read<VideoPlayerProvider>()
                                    .showOrHideVolumeBar(true);
                                
                                _currentVolumeLevel -= details.delta.dy /
                                    MediaQuery.of(context).size.height;
                                _currentVolumeLevel =
                                    _currentVolumeLevel.clamp(0.0, 1.0);
                                _volumeServices.setVolume(_currentVolumeLevel);
                              },
                              onVerticalDragEnd: (details) {
                                Future.delayed(
                                  Duration(milliseconds: AppConstants.customVideoControllsAnimatingSpeed),
                                  () {
                                    context.read<VideoPlayerProvider>().showOrHideVolumeBar(false);
                                  },
                                );
                              },
                              onTap: () {
                                _stopTimerAfterToggleStatusBar();
                              },
                              onDoubleTap: () {},
                              onHorizontalDragStart: (details) {
                                player.pause();
                                dd = player.state.position;
                              },
                              onHorizontalDragUpdate: (details) {
                                
                                      final newPosition = dd + Duration(milliseconds: (details.delta.dx * 100).toInt());
                                      if (newPosition > Duration.zero && newPosition < player.state.duration) {
                                         context.read<VideoPlayerProvider>().getVideoDuration(dd);
                                         dd = newPosition;
                                      }
                              },
                              onHorizontalDragEnd: (details) {
                                player.seek(dd);
                                player.play();
                              },
                              child: Video(
                                key: key,
                                controller: controller!,
                                 controls: null,
                              )),
                           CustomTopVideoControll(
                            player: player,
                            track: audioTracks,
                            orientation: orientation,
                          ),
                          Selector<VideoPlayerProvider, bool>(
                            selector: (p0, p1) => p1.showVolumeBar,
                            builder: (context, showVolumeBar, child) => Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    VerticalGestureSliderWidget(
                                      showSlider: showVolumeBar,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Align(
                              alignment: Alignment.bottomCenter,
                              child: CustomBottomVideoControlls(
                                player: player,
                                orientation: orientation,
                                onVolumeButtonClicked: () {
                                  var currentVolume =
                                      context.read<VideoPlayerProvider>().videoVolume;
                                  if (currentVolume != 0.0) {
                                    _volumeServices.setVolume(0.0);
                                  } else {
                                    _volumeServices.setVolume(0.5);
                                  }
                                },
                                onFullscreenButtonClicked: (){
                                  if (orientation == Orientation.portrait) {
                                        VideoPlayerServices.enterLandscapeMode();
                                     }
                                     else{
                                      VideoPlayerServices.enterPortraitMode();
                                     }
                                },
                              ))
                        ],
                      )
                      : const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                  
                  ),
          ),
        );
      }
    );
  }

  disposePlayer() async {
    await player.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    TimerManager.timer?.cancel();
  }

  @override
  void dispose() {
    disposePlayer();
    super.dispose();
  }
}
