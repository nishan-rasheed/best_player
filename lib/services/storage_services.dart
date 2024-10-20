
import 'package:mx_p/constants/app_constants.dart';
import 'package:mx_p/constants/global_variables.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;

class StorageServices{
  
  Future<bool> getStoragePermissions() async {

    var sdkVer = appSdkVersion;
    // DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    // AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
    if (sdkVer<33) {
     var status = await Permission.storage.request();
     return status.isGranted;
    }
    else{
     var status = await Permission.manageExternalStorage.request();
     return status.isGranted;
    }
   
  }


  // check file is video file or not 

  bool checkFileisvideo(String filePath){
    
   var isVideo = AppConstants.supportedVideoFormat.any((element) => filePath.endsWith(element),);

   if (isVideo) {
     var isDeleted = path.basename(filePath).startsWith('.');
    var isVideoAndNotDeleted = isVideo&&!isDeleted;
    return isVideoAndNotDeleted;
   }
   else{
    return false;
   }
  }
}