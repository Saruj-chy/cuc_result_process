import 'package:cuc_result_processing/components/admin_components/dashboard_admin.dart';
import 'package:cuc_result_processing/components/login_page.dart';
import 'package:cuc_result_processing/components/reg_page.dart';
import 'package:cuc_result_processing/components/splash_page.dart';
import 'package:cuc_result_processing/components/teacher_components/dashboard_teacher.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CUC Result Process',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        RegistrationPage.id: (context) => const RegistrationPage(),
        LoginPage.id: (context) => const LoginPage(),
        DashboardTeacher.id: (context) => const DashboardTeacher(),
        DashboardAdmin.id: (context) => const DashboardAdmin(),

      },
        home: const SplashPage(),
      );
  }
}
