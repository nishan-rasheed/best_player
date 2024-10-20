import 'dart:io';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:mx_p/constants/custom_log.dart';
import 'package:mx_p/method_channel/flutter_method_channels.dart';
import 'package:mx_p/services/thumbnail_services.dart';

class HashTestScreen extends StatefulWidget {
  const HashTestScreen({super.key});

  @override
  State<HashTestScreen> createState() => _HashTestScreenState();
}

class _HashTestScreenState extends State<HashTestScreen> {


  String fileNAme = "/storage/emulated/0/DCIM/Camera/final test.mp4";
  var low = '/storage/emulated/0/Download/Telegram/turbo.mkv';
  var high = '/storage/emulated/0/test/to s-409 6x1720-tiles.mkv';

 String? fileEncryp;

  getFileHash(String filePath) async {
  final bytes = await File(filePath).readAsBytes();
  var encryptedDaat = md5.convert(bytes).toString(); 
   setState(() {
     fileEncryp = encryptedDaat;
   });

   customLog("==$fileEncryp");
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(fileEncryp??fileNAme),

      ),
      floatingActionButton: FloatingActionButton(onPressed: ()async{
        await FlutterMethodChannels.getVideoMetadata(low);
        //await ThumbnailServices().generateThumbnailAndDurationUsingFfmmpeg(high);
        // getFileHash(fileNAme);
      }),
    );
  }
}