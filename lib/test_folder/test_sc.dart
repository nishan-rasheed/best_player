

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mx_p/constants/app_constants.dart';


String fileChangeChannel = 'file_change_channel';


class TestScreen extends StatefulWidget {
   TestScreen(
      {super.key,});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  Stream<FileSystemEvent>? directoryWatcherStream;
  
   




  @override
  void initState() {
    super.initState();

    startMonitoringFiles(AppConstants.rootDirectory.path);

    MethodChannel(fileChangeChannel).setMethodCallHandler((result) async {

      log('nishan  result----${result}');
        // if (call.method == 'onFileChanged') {
        //     final path = call.arguments as String;
        //     // Update UI based on the changed file path
        //     print('File changed: $path');
        // }
        // return null;
    });


  //   List<FileSystemEntity> entries = AppConstants.rootDirectory.listSync(recursive: false).toList();
    
  //   // directoryWatcherStream =  AppConstants.rootDirectory.watch(recursive: true);

 
  //  for (var item in entries) {
  //   directoryWatcherStream =  item.watch(recursive: true);
  //  }
 
 
  //  directoryWatcherStream?.listen((event) {
  //    log('event is ${event.type}--path-${event.path}---isD-${event.isDirectory}--${event}');
  //   if (FileSystemEvent.create == event.type) {
  //     // print('New file: ${event.entity.path}');
  //     // Add logic to display a notification about the new file
  //   } else if (FileSystemEvent.delete == event.type) {
  //     print('Deleted file: ');
  //     // Add logic to display a notification about the deleted file
  //   }
  // });

  //  log('event function called${directoryWatcherStream}');
    
  }


static Future<void> startMonitoringFiles(String directoryPath) async {
    final platform = MethodChannel(fileChangeChannel);
    try {
        await platform.invokeMethod('startMonitoring', directoryPath);
    } on PlatformException catch (e) {
        // Handle exceptions (e.g., communication error)
        log('nishan${e.message}');
    }
}


  // Future<void> loadDirectories() async {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ddd'),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        // monitorDirectory();
          },
          child: const Text('add'),
          ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          
           StreamBuilder<FileSystemEvent>(
           stream: directoryWatcherStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Center(child: Text('datta-${snapshot.data?.path}'));
              }
              else{
                 return Center(child: Text('no data'));
              }
              
            }
          )
        ],
      )
    );
  }
}

class ClassListModel {
  final String name;
  final String className;

  ClassListModel({required this.name, required this.className});
}

class TestModel {
  final String name;
  final String number;
  final int age;

  TestModel({required this.name, required this.number, required this.age});
}
