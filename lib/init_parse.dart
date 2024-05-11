import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

Future<void> initParse() async {
  await Parse().initialize(
    'hlXPNNpe17bVif1ViKBKh3rQ9CXLYdmcvtKIoVK8',
    'https://parseapi.back4app.com/',
    clientKey: 'zzPRdQJPMLTql0l8mtSj1TTkt8MKFYhMBfcVOGXQ',
    autoSendSessionId: true,
    debug: true
  );
}
