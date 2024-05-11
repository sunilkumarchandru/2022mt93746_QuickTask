import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

Future<void> initParse() async {
  await Parse().initialize(
    'hlXPNNpe17bVif1ViKBKh3rQ9CXLYdmcvtKIoVK8', // Replace with your actual Application ID from Back4App
    'https://parseapi.back4app.com/',
    clientKey: 'zzPRdQJPMLTql0l8mtSj1TTkt8MKFYhMBfcVOGXQ', // Replace with your actual Client Key from Back4App
    autoSendSessionId: true,
    debug: true // Set to false before deploying the app for production
  );
}
