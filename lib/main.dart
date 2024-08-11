import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:scheduler_app_sms/features/auth/view/login_page.dart';
import 'package:scheduler_app_sms/features/home/views/home_page.dart';
import 'features/auth/provider/user_provider.dart';
import 'firebase_options.dart';
import 'utils/app_colors.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.watch(userFutureProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        canvasColor: CustomColors.greyBackground,
        fontFamily: 'rubik',
        colorScheme: const ColorScheme.light(
          primary: CustomColors.blueDark,
          secondary: CustomColors.blueDark,
        ),
        
      ),
       builder: FlutterSmartDialog.init(),
      home: user.when(
        data: (user) {
          if (user == null) {
            return const LoginPage();
          } else {
            return const HomePage();
          }
        },
        loading: () => const SafeArea(
          child: Scaffold(
            
            body: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          ),
        ),
        error: (error, stackTrace) => Scaffold(
          body: SafeArea(
            child: Scaffold(
              
              body: Center(child: Text('Error: $error')),
            ),
          ),
        ),
      ),
    );
  }
}
