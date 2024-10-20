
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:media_kit/media_kit.dart';
import 'package:mx_p/constants/app_constants.dart';
import 'package:mx_p/constants/custom_log.dart';
import 'package:mx_p/view/video_show/widgets/custom_progress_indicator.dart';
import 'package:provider/provider.dart';
import '../../../constants/app_colors.dart';
import '../../../controller/video_player_controller.dart';
import '../../../services/video_player_services.dart';
import '../../../utils/time_utils.dart';
import '../../common_widgets/custom_video_iconbutton.dart';
import '../shared/timer_manager.dart';

class CustomBottomVideoControlls extends StatelessWidget {
  CustomBottomVideoControlls({
    super.key, 
    required this.player, 
    required this.onVolumeButtonClicked, required this.onFullscreenButtonClicked, required this.orientation,
  });
  
  final Player player;
  final Orientation orientation ;
  final Function() onVolumeButtonClicked;
  final Function() onFullscreenButtonClicked;
  

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
                          EdgeInsets.symmetric(vertical: 10.h, horizontal: 0.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if(orientation == Orientation.portrait)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              videoCurrentTime(),
                              Text('/'),
                              videoDuration(),
                            ],
                          ),
                          Selector<VideoPlayerProvider,Duration>(
                          selector: (p0, p1) => p1.videoPosition,
                          builder: (context, videoPosition, child) {
                            var value = (videoPosition.inMilliseconds/(player.state.duration.inMilliseconds));
                            // var position =  value.isNaN ?0.0:value;

                           // return CustomSlider();

                           return CustomProgressIndicator(
                            value: value,
                            onChangeStart: (value) {
                              TimerManager.timer?.cancel();
                              player.pause();
                            },
                            onChangeUpdate: (value)async{
                                var newVideoPositionInMilliSec = value*(player.state.duration.inMilliseconds);
                              context.read<VideoPlayerProvider>().getVideoDuration(
                                Duration(milliseconds: newVideoPositionInMilliSec.toInt()));
                            },
                            onChangeEnd: (value) async{
                              // TimerManager.timer = Timer.periodic(const Duration(seconds: 3), (_) {
                              //         customLog('listen---${TimerManager.timer?.isActive}');
                              //          VideoPlayerServices.toggleStatusbarAndNavbar(context);
                              //          TimerManager.timer?.cancel();
                              //       });
                            var finalVideoPositionInMilliSec = value*(player.state.duration.inMilliseconds);
                            await player.seek(Duration(milliseconds: finalVideoPositionInMilliSec.toInt())).then((value) {
                                customLog('restaer');
                                 player.play();
                              },);
                              
                            },
                           );
                          }),
                          Row(
                            children: [
                            Selector<VideoPlayerProvider,double>(
                                    selector: (p0, p1) => p1.videoVolume,
                                    builder: (context, videoVolume, child) =>
                                     CommonVideoIconButton(
                                        onTap: onVolumeButtonClicked,
                                        icon: videoVolume!=0?
                                                Icons.volume_up:
                                                Icons.volume_off,
                                      )
                                  ),
                                  CommonVideoIconButton(
                                        onTap: (){},
                                        icon: Icons.fit_screen_outlined,
                                      ),    
                              const Spacer(),

                              if(orientation == Orientation.landscape)videoCurrentTime(),

                               CommonVideoIconButton(
                                        onTap: (){},
                                        icon: Icons.skip_previous,
                                      ),

                              Selector<VideoPlayerProvider, bool?>(
                                selector: (p0, p1) => p1.isMKVideoPlaying,
                                builder: (context, isPlaying, child) => 
                                InkWell(
                                  onTap: () {
                                    player.playOrPause();
                                  },
                                  child: Container(
                                    padding:const EdgeInsets.all(5),
                                    // height: 5.h,width: 20.h,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: AppColor.contentForeGroundColor)
                                    ),
                                    child:Icon(
                                      isPlaying ?? false
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                            color: AppColor.contentForeGroundColor,
                                    ) ,
                                  ),
                                ),
                                // CommonVideoIconButton(
                                //         onTap: (){
                                //           player.playOrPause();
                                //         },
                                //         icon: isPlaying ?? false
                                //           ? Icons.pause
                                //           : Icons.play_arrow,
                                //       ),
                              ),
                              CommonVideoIconButton(
                                        onTap: (){},
                                        icon: Icons.skip_next_rounded,
                                      ),
                              if(orientation == Orientation.landscape)videoDuration(),       
                              const Spacer(),
                               Selector<VideoPlayerProvider,double>(
                                    selector: (p0, p1) => p1.videoVolume,
                                    builder: (context, videoVolume, child) =>
                                     CommonVideoIconButton(
                                        onTap: (){},
                                        icon: Icons.subtitles,
                                      ),
                                  ),

                                  CommonVideoIconButton(
                                        onTap: onFullscreenButtonClicked,
                                        icon: Icons.crop_rotate_rounded,
                                      ),
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

  Widget videoCurrentTime(){
    return Selector<VideoPlayerProvider, Duration>(
                                selector: (p0, p1) =>p1.videoPosition,
                                builder: (context, videoPosition, child) => Text(
                                  TimeUtils.formatMilliseconds(videoPosition.inMilliseconds),
                                 //videoPosition.inMilliseconds.toString(),
                                  style: TextStyle(
                                    color: AppColor.contentForeGroundColor,
                                  ),
                                ),
                              );

  }

  Widget videoDuration(){
    return Text(
                                TimeUtils.formatMilliseconds(player.state.duration.inMilliseconds),
                                style: TextStyle(
                                  color: AppColor.contentForeGroundColor,
                                ),
                              );

  }

}


