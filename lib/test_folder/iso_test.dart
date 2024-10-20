import 'dart:io';
import 'dart:isolate';

t1(port) {
  print("t1 started");
  sleep(Duration(seconds: 3));
  port.send(["t1", 1]);
}

t2(port) {
  print("t2 started");
  sleep(Duration(seconds: 6));
  port.send(["t2", 2]);
}


Future<String> one()async{
print("one started");
var t = await Future.delayed(Duration(seconds: 3),() {
  return 'one completed';
},);

return t;

}

Future<String> two()async{
print("two started");
var t = await Future.delayed(Duration(seconds: 3),() {
  return 'two completed';
},);

return t;

}

main() async {
   final mainStartTime = DateTime.now();
  //  var a = await one();
  //  var b = await two();

  //  print('a==$a and b ==$b');

     var rsults = await Future.wait([one(),two()]);

   print('a==${rsults[0]} and b ==${rsults[1]}');

   final mainEndTime = DateTime.now();
  final mainElapsedTime = mainEndTime.difference(mainStartTime);
  print('duration ===${mainElapsedTime}');

 



  // var receivePort =  ReceivePort();

  // Isolate.spawn(t1, receivePort.sendPort);
  // Isolate.spawn(t2, receivePort.sendPort);

  // await for (var retMsg in receivePort) {
  //   print("res: $retMsg");

  //   if (retMsg[0] == "t2") {
  //     return;
  //   }
  // }
}