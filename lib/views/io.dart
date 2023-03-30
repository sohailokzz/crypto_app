import 'package:flutter/material.dart';

class IO extends StatefulWidget {
  const IO({super.key});

  @override
  State<IO> createState() => _IOState();
}

class _IOState extends State<IO> {
  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffFBC700),
        body: SizedBox(
          height: myHeight,
          width: myWidth,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: myHeight * 0.5),
          ),
        ),
      ),
    );
  }
}
