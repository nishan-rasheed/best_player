import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mx_p/constants/custom_log.dart';
import 'package:mx_p/controller/thumbnail_controller.dart';
import 'package:mx_p/controller/video_player_controller.dart';
import 'package:mx_p/model/video_meta_model.dart';
import 'package:mx_p/test_folder/mediakit/media_test.dart';
import 'package:mx_p/view/video_show/video_screen.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

import '../../test_folder/mediakit/ss_player.dart';

class ListDetailScreen extends StatefulWidget {
  const ListDetailScreen({super.key, required this.videos});

  final List<String> videos;

  @override
  State<ListDetailScreen> createState() => _ListDetailScreenState();
}

class _ListDetailScreenState extends State<ListDetailScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ThumbnailController>().addThumbnailToTempList(widget.videos);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white
      ),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(onPressed: (){
            }, icon: const Icon(Icons.info_outline))
          ],
        ),
        body: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          itemCount: widget.videos.length,
          separatorBuilder: (BuildContext context, int index) =>16.verticalSpace,
          itemBuilder: (BuildContext context, int index) {
            return Selector<ThumbnailController, VideoMetaModel?>(
              selector: (p0, p1) => p1.videoMetaList.length <= index
                  ? null
                  : p1.videoMetaList[index],
              builder: (context, videoMetaData, child) => 
              InkWell(
                onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ChangeNotifierProvider(
                          create: (context) => VideoPlayerProvider(),
                       //child: SinglePlayerSingleVideoScreen(video: widget.videos[index],),
                      child: MediaDemoTest(filePath: widget.videos[index],),
                          //child: VideoScreen(videoPath: widget.videos[index])
                          )),
              ),
                child: Row(
                  children: [
                   Container(
                    padding: const EdgeInsets.all(2),
                    alignment: Alignment.bottomRight,
                    height: 60.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 4,
                              spreadRadius: 2)
                        ],
                        borderRadius: BorderRadius.circular(5),
                        color: videoMetaData == null
                            ? Colors.grey.shade600
                            : Colors.white,
                        image: videoMetaData == null
                            ? null
                            : DecorationImage(
                                image: MemoryImage(
                                    videoMetaData.thumbImage ?? Uint8List(0)),
                                fit: BoxFit.cover)),
                    child: videoMetaData == null
                        ? null
                        : Container(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(4)),
                            child: Text(
                              '${videoMetaData.videoDuration}',
                              style:  TextStyle(
                                  color: Colors.white, fontSize: 10.sp),
                            )),
                                     ),
                  5.horizontalSpace,
                  Expanded(child: Text(path.basename(widget.videos[index]))),
                            
                  5.horizontalSpace,
                            
                  InkWell(onTap: (){
                    customLog(widget.videos[index]);
                  }, child: const Icon(Icons.more_vert_outlined))
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
