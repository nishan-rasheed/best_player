import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mx_p/constants/app_constants.dart';
import 'package:mx_p/constants/custom_log.dart';
import 'package:mx_p/services/storage_services.dart';


class DirectoryProvider with ChangeNotifier {

  final StorageServices _storageServices = StorageServices();
  Map<String, List<String>> contentFilesByFolder = {};
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  

  Future<void> loadDirectories() async {
    log('loading started');
    _isLoading = true;
    contentFilesByFolder = {};
    notifyListeners();

    try {
      if (await _storageServices.getStoragePermissions()) {
        
        List<FileSystemEntity> entries = AppConstants.rootDirectory.listSync(recursive: false).toList();
        entries.removeWhere((element) => element.path == "/storage/emulated/0/Android");

        for (FileSystemEntity entity in entries) {
          if (entity is Directory) {
            
            Directory newDir = Directory(entity.path);

            await for (FileSystemEntity newEntity in newDir.list(recursive: true, followLinks: false)) {
              if (_storageServices.checkFileisvideo(newEntity.path)) {
                // if (newEntity.path.contains('trash')) {
                //   customLog('trash success = ${newEntity.path}');
                // }
                String parentDir = newEntity.parent.path;
                if (!contentFilesByFolder.containsKey(parentDir)) {
                  contentFilesByFolder[parentDir] = [];
                }
                contentFilesByFolder[parentDir]!.add(newEntity.path);
              }
            }
           
          } 
          else if(_storageServices.checkFileisvideo(entity.path)){
            contentFilesByFolder['Internal Storage'] = [];
            contentFilesByFolder['Internal Storage']?.add(entity.path);
          }
          else {
            log("Skipped non-directory and non .mp4 entity: ${entity.path}");
          }
        }

      }

      //  log("system files${contentFilesByFolder}");
    } catch (e) {
      log(e.toString());
      throw Exception('Error: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
     
    }
  }

 

 Uint8List? sampleThumb;
 loadSampleThumb(Uint8List? data){
 sampleThumb = data;
 notifyListeners();
 }

}