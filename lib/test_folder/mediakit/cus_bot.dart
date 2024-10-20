import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:media_kit/media_kit.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../controller/video_player_controller.dart';
import '../../services/video_player_services.dart';
import '../../services/volume_services.dart';
import '../../utils/time_utils.dart';

class CusBot extends StatelessWidget {
  CusBot({
    super.key, required this.videoDuration, required this.player, 
  });

  final String videoDuration;
  final Player player;
  
  final VolumeServices _volumeServices = VolumeServices();
  final VideoPlayerServices _videoPlayerServices = VideoPlayerServices();

  @override
  Widget build(BuildContext context) {
    return Selector<VideoPlayerProvider, bool>(
          selector: (p0, p1) => p1.isStatusBarShowing,
          builder: (context, isStatusBarShowing, child) => 
          AnimatedSwitcher(
          duration: Duration(milliseconds: AppConstants.customVideoControllsAnimatingSpeed),
          transitionBuilder: (Widget child, Animation<double> animation) {
            final offsetAnimation = Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: const Offset(0.0, 0.0),
            ).animate(animation);
        
            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
          child: isStatusBarShowing
              ? SafeArea(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.3),
                            Colors.black.withOpacity(0.6)
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0, 0.5, 0.9]),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Selector<VideoPlayerProvider, Duration>(
                                selector: (p0, p1) =>
                                    p1.videoPosition,
                                builder: (context, videoPosition, child) => Text(
                                  TimeUtils.formatVideoTime(videoPosition),
                                  // '00:02',
                                  style: TextStyle(
                                    color: AppColor.contentForeGroundColor,
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                child: Container(height: 10,color: Colors.blue,),
                                // child: VideoProgressIndicator(videoPlayerController,
                                //   allowScrubbing: true,
                                //   colors: const VideoProgressColors(
                                //       backgroundColor: Colors.grey,
                                //       playedColor: Colors.blue,
                                //       bufferedColor: Colors.white),
                                // ),
                              )),
                              Text(
                                videoDuration,
                               //TimeUtils.formatVideoTime(videoPlayerController.value.duration),
                                style: TextStyle(
                                  color: AppColor.contentForeGroundColor,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    var currentVolume = context.read<VideoPlayerProvider>().videoVolume;
                                    if (currentVolume!=0) {
                                      _volumeServices.muteVolume();
                                    }
                                    else{
                                      _volumeServices.setVolume(0.5);
                                    }
                                    
                                  },
                                  icon: Selector<VideoPlayerProvider,double>(
                                    selector: (p0, p1) => p1.videoVolume,
                                    builder: (context, videoVolume, child) =>
                                     Icon(
                                      videoVolume!=0?
                                      Icons.volume_up:
                                      Icons.volume_off,
                                      color: AppColor.contentForeGroundColor,
                                    ),
                                  )),
                              const Spacer(),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.skip_previous,
                                    color: AppColor.contentForeGroundColor,
                                  )),
                              Selector<VideoPlayerProvider, bool?>(
                                selector: (p0, p1) =>
                                    p1.isMKVideoPlaying,
                                builder: (context, isPlaying, child) => IconButton(
                                    onPressed: () {
                                     player.playOrPause();
                                    },
                                    icon: Icon(
                                      isPlaying ?? false
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      color: AppColor.contentForeGroundColor,
                                    )),
                              ),
                              IconButton(
                                  onPressed: () {
                                  },
                                  icon: Icon(Icons.skip_next_rounded,
                                      color: AppColor.contentForeGroundColor)),
                              const Spacer(),
                              IconButton(
                                  onPressed: () {
                                  },
                                  icon: Icon(
                                    Icons.crop_rotate_rounded,
                                    color: AppColor.contentForeGroundColor,
                                  ))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
    );
  }
}
