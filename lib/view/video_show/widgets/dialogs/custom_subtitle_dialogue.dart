import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:media_kit/media_kit.dart';
import 'package:provider/provider.dart';

import '../../../../constants/app_colors.dart';
import '../../../../controller/video_player_controller.dart';
import '../../../common_widgets/custom_video_iconbutton.dart';

class CustomSubtitleDialogue extends StatelessWidget {
  const CustomSubtitleDialogue({
    super.key,
    required this.track,
    required this.player,
  });

  final List<SubtitleTrack> track;
  final Player player;


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CommonVideoIconButton(
                icon: Icons.arrow_back,
                onTap: () {
                  Scaffold.of(context).closeEndDrawer();
                }),
            Text(
              'Sutitle',
              style: TextStyle(
                  fontSize: 22, color: AppColor.contentForeGroundColor),
            ),
          ],
        ),
        Expanded(
            child: Column(
          children: [
            ListView.separated(
              shrinkWrap: true,
              itemCount: track.length,
              separatorBuilder: (BuildContext context, int index) {
                return 10.verticalSpace;
              },
              itemBuilder: (BuildContext context, int index) {
                var item = track[index];
                return Selector<VideoPlayerProvider, int>(
                  selector: (p0, p1) => p1.selectedSubtitleTrack,
                  builder: (context, selectedSubtitleTrack, child) =>
                      RadioListTile(
                          value: index,
                          groupValue: selectedSubtitleTrack,
                          title: Text(
                            item.language ?? 'Disable Subtitle',
                            style: TextStyle(
                                color: AppColor.contentForeGroundColor),
                          ),
                          onChanged: (v) async {
                            context
                                .read<VideoPlayerProvider>()
                                .updateSubtitleTrack(index);
                            await player.setSubtitleTrack(item);
                          }),
                );
              },
            ),
            Selector<VideoPlayerProvider,bool>(
              selector: (p0, p1) => p1.isSubtitleDisabled,
              builder: (context, isSubtitleDisabled, child) =>
              CheckboxListTile(
                  value: isSubtitleDisabled,
                  title: Text(
                    'Disable Subtitle',
                    style: TextStyle(color: AppColor.contentForeGroundColor),
                  ),
                  onChanged: (v) async {
                    player.setSubtitleTrack(SubtitleTrack.no());
                    context.read<VideoPlayerProvider>().disableSubtitle(v??false);
                  }),
            )
          ],
        )
        )
      ],
    );
  }
}
