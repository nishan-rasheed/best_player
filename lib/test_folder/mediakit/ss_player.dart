import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:mx_p/constants/custom_log.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../services/video_player_services.dart';

class SinglePlayerSingleVideoScreen extends StatefulWidget {
  const SinglePlayerSingleVideoScreen({Key? key, required this.video}) : super(key: key);

  final String video;

  @override
  State<SinglePlayerSingleVideoScreen> createState() =>
      _SinglePlayerSingleVideoScreenState();
}

class _SinglePlayerSingleVideoScreenState
    extends State<SinglePlayerSingleVideoScreen> {
  late final Player player = Player();
  late final VideoController controller = VideoController(
    player,);

      final VideoPlayerServices _videoPlayerServices = VideoPlayerServices();



    bool initailized = false;

  @override
  void initState() {
    super.initState();
    player.open(Media(widget.video));
    player.stream.error.listen((error) => debugPrint(error));

  // player.stream.videoParams.listen((event) {
  //   if (event.dw!=null) {
  //     customLog('params ---$event');
  //   }
  // },);

    // player.stream.duration.listen((event) {
      
    //   if (event.inMilliseconds !=0) {
    //     //_videoPlayerServices.chooseOrientModeOnStart(player);
        
       
    //     setState(() {
    //       initailized = true;
    //     });
    //   }
    // },
    // onDone: () {
      
    // },);

    player.stream.width.listen((event) {
       
      //  customLog('og===${event}');
      if (event !=0 && event!=null) {
       // _videoPlayerServices.chooseOrientModeOnStart(player);
        customLog('player width===${player.state.videoParams}');
       
        setState(() {
          initailized = true;
        });
      }
    },);
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
      appBar: AppBar(
        title:  Text('package:media_kit--$initailized'),
      ),
      body:
       Video(
                    controller: controller,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * 9.0 / 16.0,
                    controls: null
                  )
                  
    );
  }
}
