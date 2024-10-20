

import 'package:mx_p/constants/custom_log.dart';
import 'package:volume_controller/volume_controller.dart';

class VolumeServices {

 VolumeController volumeController = VolumeController();

 num? currentVolume;


  Future<double> getVolume()async{

  var volume = await volumeController.getVolume();

  return volume;

 }

  startVolumeListner(Function(double) onVolumeChanged){
    volumeController.showSystemUI = false;
    volumeController.listener((volume) {
      onVolumeChanged(volume);
    },);
  }

  // startVolumeListner(){
    
  //   volumeController.showSystemUI = false;
  //   volumeController.listener((volume) {
      
  //     currentVolume = volume;
  //     customLog('changed$currentVolume');
  //   },);
  // }

  showHideSystemVolumeUi(bool value){
    volumeController.showSystemUI = value;
    
  }


  setVolume(double updatedVolume){
    volumeController.setVolume(updatedVolume);
  }

  muteVolume(){
    volumeController.setVolume(0.0);
    // volumeController.muteVolume();
  }


}