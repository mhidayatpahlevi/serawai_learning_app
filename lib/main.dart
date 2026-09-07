import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/bindings/initial_binding.dart';
import 'app/routes/app_pages.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const SerawaiApp());
}

class SerawaiApp extends StatelessWidget {
  const SerawaiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Belajar Bahasa Serawai',
      debugShowCheckedModeBanner: false,

      initialBinding: InitialBinding(),

      initialRoute: AppPages.initial,

      getPages: AppPages.routes,

      theme: ThemeData(
        useMaterial3: true,
      ),
    );
  }
}