import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:yonetici_paneli/pages/Login/login.dart';
import 'package:yonetici_paneli/service/auth_service.dart';
import 'package:yonetici_paneli/service/task_service.dart';
import 'package:yonetici_paneli/service/user_service.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        
        Provider<FlutterFireAuthService>(
            create: (_) => FlutterFireAuthService(FirebaseAuth.instance)),
        StreamProvider(
            create: (context) =>
                context.read<FlutterFireAuthService>().authStateChanges,
            initialData: null),
        ChangeNotifierProvider(create: (_) => UserProvider()), 


        Provider(create: (_) => TaskService()),
      ],
      child: const MaterialApp(
          debugShowCheckedModeBanner: false, home: LoginPage()),
    );
  }
}
