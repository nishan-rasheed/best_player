import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mx_p/constants/app_constants.dart';

class TestWatchScreen extends StatelessWidget {
  const TestWatchScreen({super.key});

  wathe(){
    String path = AppConstants.rootDirectory.path;
    Directory dir = Directory(path);    
    var stream = dir.watch(events: FileSystemEvent.all);
    stream.listen((data){
      print(data.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}