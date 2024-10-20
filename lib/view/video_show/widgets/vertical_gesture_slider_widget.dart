import 'package:flutter/material.dart';
import 'package:mx_p/constants/app_colors.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../../controller/video_player_controller.dart';


//Icon(Icons.brightness_6_rounded,color: contentForeGroundColor,),

class VerticalGestureSliderWidget extends StatelessWidget {
  const VerticalGestureSliderWidget({
    super.key, required this.showSlider,
  });

  final bool showSlider;

  final Duration iconsHideAnimationDuration = const Duration(milliseconds: 300);
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration:iconsHideAnimationDuration,
      child: 
      showSlider?
      Container(
        padding:const EdgeInsets.symmetric(vertical: 10,horizontal: 8),
        decoration: BoxDecoration(
          color: AppColor.iconBgColor,
          borderRadius: BorderRadius.circular(20)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 160,
              child: RotatedBox(
                quarterTurns: 3,
                child: Selector<VideoPlayerProvider,double>(
                  selector: (p0, p1) => p1.videoVolume,
                  builder: (context, initialvolume, child) => 
                  LinearPercentIndicator(
                    progressColor: Colors.blue,
                    leading: RotatedBox(
                      quarterTurns: 1,
                      child: Icon(Icons.volume_up_rounded,color: AppColor.contentForeGroundColor,)),
                    percent: initialvolume,
                    // animation: true,
                    // animateFromLastPercent: true,
                    // animationDuration: 150,
                  ),
                )),
            ),
            
          ],
        ),
      )
      :const SizedBox.shrink(),
    );
  }
}
