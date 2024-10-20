import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../controller/video_player_controller.dart';
import '../services/video_player_services.dart';


const sd = "https://drive.google.com/file/d/1KXwBUJaQKI_HAdE-UJh2JpmAWxXFxPmP/view?usp=drivesdk";
const hq = "https://drive.google.com/file/d/1KX4rjGUNamFd1W65KhtRSVnjr4TvNGBC/view?usp=drivesdk";

class NetworkVideoCheck extends StatefulWidget {
  const NetworkVideoCheck({super.key});

  @override
  State<NetworkVideoCheck> createState() => _NetworkVideoCheckState();
}



class _NetworkVideoCheckState extends State<NetworkVideoCheck> {

  

   final VideoPlayerServices _videoPlayerServices = VideoPlayerServices();
    

  @override
  void initState() {
    super.initState();
    _initialiserVideoCtr();
    
  }
  
  
  void _initialiserVideoCtr() {
    _videoPlayerServices.initializeVideoController(
      videoPath: sd,
      isFile: false).then((chewieController) {
        context
            .read<VideoPlayerProvider>()
            .initialiseVideoPlayerController(chewieController);
        context.read<VideoPlayerProvider>().addVideoListner();
      },
    );
  }

  @override
void dispose() {
  _videoPlayerServices.disposeVideoController();
  super.dispose();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Selector<VideoPlayerProvider, ChewieController?>(
          selector: (p0, p1) => p1.chewieController,
          builder: (context, chewieController, child) =>  SizedBox(
              height: 1.sh/2,
              child: chewieController!=null?
              Chewie(controller: chewieController):const CircularProgressIndicator(),
            ),
          )
        ],
      ),
    );
  }
}