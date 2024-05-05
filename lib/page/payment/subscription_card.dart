import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class SubscriptionCard extends StatelessWidget {
  final String title;
  final String description;
  final List<Widget> widgets;

  SubscriptionCard({
    required this.title,
    required this.description,
    required this.widgets,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.7;
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: height,
      width: width,
      child: Card(
        elevation: 5,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            children: <Widget>[
              // Use the AnimatedTextKit here to create an animated title
              AnimatedTextKit(
                animatedTexts: [
                  ColorizeAnimatedText(
                    title,
                    textStyle:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    speed: const Duration(milliseconds: 150),
                    colors: [Colors.orange, Colors.amber, Colors.white],
                  ),
                ],
              ),
              Text(
                description,
                style: TextStyle(fontSize: 20),
              ),
              // Display the list of widgets using a Column
              Column(
                children: widgets,
              ),
            ],
          ),
        ),
      ),
    );
  }
}