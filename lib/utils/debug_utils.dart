

Future<Duration> checkOperationTime(Function() operation)async{
  final mainStartTime = DateTime.now();
  operation;
  final mainEndTime = DateTime.now();
  final mainElapsedTime = mainEndTime.difference(mainStartTime);
  return mainElapsedTime;

}