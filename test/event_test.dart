import 'package:grouping_project/service/auth_service.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/pages/auth/cover.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:grouping_project/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AuthService().emailLogIn('test@mail.com', 'password');
  EventModel testUploadData = EventModel(
      title: 'test event',
      startTime: DateTime.now(),
      contributorIds: ['test user id 1', 'test user id 2'],
      notifications: [DateTime(2023), DateTime(2024)]);

  print('test data uploading...\n');
  await DataController().upload(uploadData: testUploadData);
  print('test data finish upload\n');
  print('test data downloading...\n');
  var testDownloadData =
      await DataController().downloadAll(dataTypeToGet: EventModel());
  print('${testDownloadData[0].title}\n'
      '${testDownloadData[0].startTime}\n'
      '${(testDownloadData[0].contributorIds)?[1]}\n'
      '${(testDownloadData[0].notifications)?[1]}\n');
  print('test over');
}
