import 'package:contacts/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreenDelayPage extends StatefulWidget {
  const SplashScreenDelayPage({super.key});

  @override
  State<SplashScreenDelayPage> createState() => _SplashScreenDelayPageState();
}

class _SplashScreenDelayPageState extends State<SplashScreenDelayPage> {
  openHome() {
    Future.delayed(const Duration(milliseconds: 4300), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    openHome();
    return Scaffold(
        body: Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: Lottie.asset('assets/lotties/loader.json'),
      ),
    ));
  }
}
