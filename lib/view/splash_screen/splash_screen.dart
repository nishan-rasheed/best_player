import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mx_p/constants/custom_log.dart';
import 'package:mx_p/controller/thumbnail_controller.dart';
import 'package:mx_p/method_channel/flutter_method_channels.dart';
import 'package:mx_p/services/thumbnail_services.dart';
import 'package:mx_p/view/directory_list/list_screen.dart';
import 'package:mx_p/test_folder/test_sc.dart';
import 'package:provider/provider.dart';
import 'package:convert/convert.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState() {
    FlutterMethodChannels.getSdkVersion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ListDirectoryScreen()));
      }),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () async{
                var low = '/storage/emulated/0/test/tos-4096x1720-tiles.mkv';
                var high = '/storage/emulated/0/Download/Telegram/turbo.mkv';
                String md5Hash = await calculateMD5HashForPath(low);
                // calculateMD5HashForPath(low);

             //ThumbnailServices().generateThumbnailUsingNative('/storage/emulated/0/Download/Telegram/turbo.mkv');
              // FlutterMethodChannels.logData();
              //  FlutterMethodChannels.getVideoThumbNails('/storage/emulated/0/Movies/Camect/ree.mp4');

              },
              child: const Text('print'),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // log('this is log message');
              },
              child: const Text('log'),
            ),
          ),
        ],
      ),
    );
  }

  Future<String> calculateMD5HashForPath(String videoPath) async {
    // Run the heavy MD5 calculation in an isolate
    return await compute(_calculateMD5, videoPath);
  }

  Future<String> _calculateMD5(String videoPath) async {

    final file = File(videoPath);
    final chunkSize = 1024 * 1024; // 1 MB chunks
    final hashSink = AccumulatorSink<Digest>();
    final md5Sink = md5.startChunkedConversion(hashSink);

    // Open the file as a stream to process it in chunks
    final stream = file.openRead();
    await for (final chunk in stream) {
      md5Sink.add(chunk);
    }

    // Close the sinks to complete the hash calculation
    md5Sink.close();
    final digest = hashSink.events.single;

    return digest.toString();
  }





}
