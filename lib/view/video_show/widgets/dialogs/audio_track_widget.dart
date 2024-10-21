import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:media_kit/media_kit.dart';
import 'package:provider/provider.dart';

import '../../../../constants/app_colors.dart';
import '../../../../controller/video_player_controller.dart';
import '../../../common_widgets/custom_video_iconbutton.dart';

class AudioTrackWidget extends StatelessWidget {
  const AudioTrackWidget({
    super.key,
    required this.track,
    required this.player,
  });

  final List<AudioTrack>? track;
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
              'Audio Track',
              style: TextStyle(
                  fontSize: 22,
                  color: AppColor
                      .contentForeGroundColor),
            ),
          ],
        ),
        Expanded(
          child: Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: track?.length ?? 0,
                separatorBuilder:
                    (BuildContext context, int index) {
                  return 10.verticalSpace;
                },
                itemBuilder:
                    (BuildContext context, int index) {
                  var item = track?[index];
                  return Selector<VideoPlayerProvider,int>(
                     selector: (p0, p1) => p1.selectedAudioTrack,
                     builder: (context, selectedAudioTrack, child) => 
                      RadioListTile(
                      title:Text(item==AudioTrack.no()?'Disable Audio':item?.language ?? '',
                      style: TextStyle(
                        color: AppColor.contentForeGroundColor
                      ),
                      ),
                      value: index,
                      groupValue: selectedAudioTrack,
                      onChanged: (value) async{
                        context.read<VideoPlayerProvider>().updateAudioTrack(index);
                        await player.setAudioTrack(item!);
                      },
                    ),
                  );
                },
              ),
              Selector<VideoPlayerProvider,bool>(
                selector: (p0, p1) => p1.isAudioDisabled,
                builder: (context, isAudioDisabled, child) => 
                CheckboxListTile(
                  value: isAudioDisabled,
                  title: Text(
                    'Disable Audio',
                    style: TextStyle(color: AppColor.contentForeGroundColor),
                  ),
                  onChanged: (v) async {
                    context.read<VideoPlayerProvider>().disableAudio(v??false);
                    player.setAudioTrack(AudioTrack.no());
                    
                  }),
              )
            ],
          ),
        )
      ],
    );
  }
}
