import 'package:flutter/material.dart';
import 'package:sharejet/Screens/home_screen.dart';

void main(){
  runApp(ShareJet());
}

class ShareJet extends StatelessWidget {
  const ShareJet({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(
      ),
    );
  }
}