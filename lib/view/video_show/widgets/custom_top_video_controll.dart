import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:media_kit/media_kit.dart';
import 'package:mx_p/constants/app_constants.dart';
import 'package:mx_p/services/video_player_services.dart';
import 'package:mx_p/view/common_widgets/custom_video_iconbutton.dart';
import 'package:mx_p/view/video_show/widgets/dialogs/audio_track_widget.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/custom_log.dart';
import '../../../controller/video_player_controller.dart';
import '../shared/timer_manager.dart';

class CustomTopVideoControll extends StatelessWidget {
  const CustomTopVideoControll({
    super.key,
    this.track,
    required this.orientation, required this.player,
  });
  
  final Player player;
  final List<AudioTrack>? track;
  final Orientation orientation;

  _openDrawerAndPassChild(
      {required BuildContext context, required WidgetBuilder builder}) {
     VideoPlayerServices.hideStatusBar();   
    Scaffold.of(context).openEndDrawer();
    context.read<VideoPlayerProvider>().upDateDrawerContent(builder);
  }

  @override
  Widget build(BuildContext context) {
    return Selector<VideoPlayerProvider, bool>(
      selector: (p0, p1) => p1.isStatusBarShowing,
      builder: (context, isStatusBarShowing, child) => SafeArea(
        child: AnimatedSwitcher(
          duration: Duration(
              milliseconds: AppConstants.customVideoControllsAnimatingSpeed),
          transitionBuilder: (Widget child, Animation<double> animation) {
            final offsetAnimation = Tween<Offset>(
              begin: const Offset(0.0, -1.0),
              end: const Offset(0.0, 0.0),
            ).animate(animation);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
          child: isStatusBarShowing
              ? Row(
                  children: [
                    CommonVideoIconButton(icon: Icons.arrow_back, onTap: () {}),
                    Text('Boys S03E93'),
                    Spacer(),
                    CommonVideoIconButton(
                        icon: Icons.audiotrack_rounded,
                        onTap: () {
                          if (orientation == Orientation.portrait) {
                            // showModalBottomSheet(
                            //     barrierColor: Colors.transparent,
                            //     context: context,
                            //     backgroundColor: Colors.transparent,
                            //     builder: (context) => Column(
                            //           children: [
                            //             Text("Audio Tracks"),
                            //             ListView.separated(
                            //               shrinkWrap: true,
                            //               itemCount: track?.length ?? 0,
                            //               separatorBuilder:
                            //                   (BuildContext context,
                            //                       int index) {
                            //                 return 10.verticalSpace;
                            //               },
                            //               itemBuilder: (BuildContext context,
                            //                   int index) {
                            //                 var item = track?[index];
                            //                 return Row(
                            //                   children: [
                            //                     Radio(
                            //                         value: true,
                            //                         groupValue: true,
                            //                         onChanged: (v) {}),
                            //                     Text(
                            //                       item?.language ?? '',
                            //                       style:const TextStyle(
                            //                           color: Colors.white),
                            //                     )
                            //                   ],
                            //                 );
                            //               },
                            //             ),
                            //           ],
                            //         ));
                          } else {
                            _openDrawerAndPassChild(
                              context: context,
                              builder: (context) => AudioTrackWidget(track: track, player: player),
                            );
                          }
                        }),
                    CommonVideoIconButton(icon: Icons.hd_rounded, onTap: () {}),
                    CommonVideoIconButton(
                        icon: Icons.more_vert_sharp, onTap: () {})
                  ],
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}

