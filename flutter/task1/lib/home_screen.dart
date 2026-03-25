import 'package:flutter/material.dart';
import 'package:task1/animated_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        title: Text("Animated Card"),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.black,
      ),
      body: const Center(
        child: AnimatedCard(
          title: "This is an animated card",
          subtitle: "Click here to see the animation",
          imageUrl:
              "https://docs.flutter.dev/assets/images/dash/dash-fainting.gif",
        ),
      ),
    );
  }
}
