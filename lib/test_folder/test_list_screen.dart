import 'package:flutter/material.dart';
import 'package:mx_p/controller/video_player_controller.dart';
import 'package:mx_p/test_folder/hash_test_screen.dart';
import 'package:mx_p/test_folder/network_video_check.dart';
import 'package:mx_p/test_folder/overlay_demo.dart';
import 'package:mx_p/test_folder/test_sc.dart';
import 'package:mx_p/test_folder/test_watch_screen.dart';
import 'package:mx_p/view/video_show/widgets/custom_progress_indicator.dart';
import 'package:provider/provider.dart';

class TestListScreen extends StatelessWidget {
  const TestListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [

          ElevatedButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => OverLayDemoScreen(),));
            }, 
            child: Text('OverLay Demo Screen')),  

          // ElevatedButton(
          //   onPressed: (){
          //     Navigator.push(context, MaterialPageRoute(builder: (context) => CustomSlider(),));
          //   }, 
          //   child: Text('Custom slider')),  

          ElevatedButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => TestScreen(),));
            }, 
            child: Text('Test Screen')),  

          ElevatedButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => TestWatchScreen(),));
            }, 
            child: Text('Test Watch Screen')),    


          ElevatedButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => 
              ChangeNotifierProvider(
                          create: (context) => VideoPlayerProvider(),
                          child: NetworkVideoCheck()
                          )));
            }, 
            child: Text('network Watch Screen')),      


            ElevatedButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => 
              HashTestScreen()
                          ) );
            }, 
            child: Text('HAsh Test Screen')), 



        ],
      ),
    );
  }
}