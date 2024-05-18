import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("About"),
        ),
        body: Container(
          padding: EdgeInsets.only(top: 50),
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
              "Thank you for choosing NoteApp as your go-to note-taking app. If you encounter any issues or have feedback,\n\nplease don't hesitate to reach out to us at khizarsajid15@gmail.com. \n\nHappy note-taking!"),
        ));
  }
}
