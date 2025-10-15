import 'package:calm_connect/app_binding/app_binding.dart';
import 'package:calm_connect/routes/route_generator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CalmConnect',
      initialBinding: Appbinding(),
      initialRoute: FirebaseAuth.instance.currentUser != null ? '/' : '/auth',
      onGenerateRoute: RouteGenerator.onGenerateRoute,
    );
  }
}
