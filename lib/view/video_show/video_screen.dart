// import 'dart:async';

// import 'package:chewie/chewie.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:mx_p/controller/video_player_controller.dart';
// import 'package:mx_p/services/video_player_services.dart';
// import 'package:mx_p/services/volume_services.dart';
// import 'package:mx_p/view/video_show/widgets/custom_bottom_video_controlls.dart';
// import 'package:provider/provider.dart';
// import 'package:video_player/video_player.dart';
// import 'widgets/custom_top_video_controll.dart';
// import 'widgets/vertical_gesture_slider_widget.dart';

// class VideoScreen extends StatefulWidget {
//   const VideoScreen({super.key, required this.videoPath});
//   final String videoPath;
//   @override
//   _VideoScreenState createState() => _VideoScreenState();
// }

// class _VideoScreenState extends State<VideoScreen> {
//   final VideoPlayerServices _videoPlayerServices = VideoPlayerServices();

//   final VolumeServices _volumeServices = VolumeServices();
//   int _autoHideStatusBarDuration = 3;
  
//   Timer? _timer;
//   Duration _iconsHideAnimationDuration = const Duration(milliseconds: 300);

//   late double _currentVolumeLevel;

//   bool _isStatusBarShowing = false;

//   @override
//   void initState() {
//     super.initState();
//     _initialiserVideoCtr();
//     _stopTimerAfterToggleStatusBar();

//     _volumeServices.volumeController.listener(
//       (volume) {
//         setSystemVolumeToVideoVolume(volume);
//         context.read<VideoPlayerProvider>().updateVideoVolumeOnVerticalDrag(volume);
//       },
//     );

//     _volumeServices.showHideSystemVolumeUi(false);

//     SystemChrome.setSystemUIChangeCallback((systemOverlaysAreVisible) async {
//       _isStatusBarShowing = systemOverlaysAreVisible;
//       context
//           .read<VideoPlayerProvider>()
//           .swichStatusBarView(systemOverlaysAreVisible);

//       if (systemOverlaysAreVisible) {
//         _timer =
//             Timer.periodic(Duration(seconds: _autoHideStatusBarDuration), (_) {
//           _stopTimerAfterToggleStatusBar();
//         });
//       }
//     });
//   }

//   setSystemVolumeToVideoVolume(double currentVolume) {
//     _currentVolumeLevel = currentVolume;
//   }

//   void _initialiserVideoCtr() {
//     _videoPlayerServices.initializeVideoController(videoPath:widget.videoPath).then(
//       (chewieController) {
//         context
//             .read<VideoPlayerProvider>()
//             .initialiseVideoPlayerController(chewieController);
//         context.read<VideoPlayerProvider>().addVideoListner();
//        // _videoPlayerServices.chooseOrientModeOnStart();
//       },
//     );
//   }

//   _stopTimerAfterToggleStatusBar() {
//     _videoPlayerServices.toggleStatusbarAndNavbar(context);
//     _timer?.cancel();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       onPopInvoked: (didPop) {
//         _videoPlayerServices.enterPortraitMode();
//       },
//       child: AnnotatedRegion(
//         value: SystemUiOverlayStyle.dark.copyWith(
//           statusBarColor: Colors.black,
//           statusBarIconBrightness: Brightness.light,
//         ),
//         child: Selector<VideoPlayerProvider, ChewieController?>(
//           selector: (p0, p1) => p1.chewieController,
//           builder: (context, chewieController, child) => Scaffold(
//               backgroundColor: Colors.black,
//               body: chewieController == null
//                   ? const Center(child: CircularProgressIndicator())
//                   : Stack(
//                       children: [
//                         GestureDetector(
//                             onVerticalDragUpdate: (details) {
//                               context
//                                   .read<VideoPlayerProvider>()
//                                   .showOrHideVolumeBar(true);

//                               _currentVolumeLevel -= details.delta.dy /
//                                   MediaQuery.of(context).size.height;
//                               _currentVolumeLevel =
//                                   _currentVolumeLevel.clamp(0.0, 1.0);
//                               _volumeServices.setVolume(_currentVolumeLevel);
//                             },
//                             onVerticalDragEnd: (details) {
//                               Future.delayed(
//                                 _iconsHideAnimationDuration,
//                                 () {
//                                   context
//                                       .read<VideoPlayerProvider>()
//                                       .showOrHideVolumeBar(false);
//                                 },
//                               );
//                             },
//                             onTap: () {
//                               _stopTimerAfterToggleStatusBar();
//                             },
//                             onDoubleTap: () {
//                               context.read<VideoPlayerProvider>().playPauseVideo();
//                             },
//                             onHorizontalDragUpdate: (details) {
//                               _timer?.cancel();

//                               Duration currentPosition = chewieController
//                                   .videoPlayerController.value.position;
//                               currentPosition += chewieController
//                                           .videoPlayerController
//                                           .value
//                                           .duration
//                                           .inSeconds >
//                                       15
//                                   ? Duration(seconds: details.delta.dx.toInt())
//                                   : Duration(
//                                       seconds: (details.delta.dx / 3).toInt());

//                               context.read<VideoPlayerProvider>()
//                                   .seekVideo(currentPosition);
//                             },
//                             onHorizontalDragEnd: (details) {
//                               if (_isStatusBarShowing &&
//                                   !(_timer?.isActive ?? false)) {
//                                 _timer = Timer.periodic(
//                                     Duration(
//                                         seconds: _autoHideStatusBarDuration),
//                                     (_) {
//                                   _stopTimerAfterToggleStatusBar();
//                                 });
//                               }
//                             },
//                             child: Chewie(controller: chewieController)),
//                         const CustomTopVideoControll(),
//                         Selector<VideoPlayerProvider, bool>(
//                           selector: (p0, p1) => p1.showVolumeBar,
//                           builder: (context, showVolumeBar, child) => Align(
//                             alignment: Alignment.center,
//                             child: Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 30.w),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   VerticalGestureSliderWidget(
//                                     showSlider: showVolumeBar,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),

//                       // VideoProgressIndicator(controller, allowScrubbing: allowScrubbing)


//                         // Align(
//                         //     alignment: Alignment.bottomCenter,
//                         //     child: CustomBottomVideoControlls(
//                         //       videoPlayerController:
//                         //           _videoPlayerServices.videoPlayerController,
//                         //     ))
//                       ],
//                     )),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _videoPlayerServices.disposeVideoController();
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
//         overlays: SystemUiOverlay.values);
//     super.dispose();
//   }
// }
