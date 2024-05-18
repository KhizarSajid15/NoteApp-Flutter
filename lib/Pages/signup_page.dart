// ignore: unused_import
// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, use_build_context_synchronously, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterp2/Pages/firebase_auth.dart';
import 'package:flutterp2/Pages/login_page.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool _passwordVisible = false;

  final FirebaseAuthService _authService = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phonenoController = TextEditingController();

  // User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 50),
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 150,
                  backgroundImage: AssetImage("assets/Signup.jpg"),
                ),
              ),
              Container(
                child: Text(
                  "Signup",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: "Username",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: TextField(
                  controller: _phonenoController,
                  decoration: InputDecoration(
                    hintText: "Phone No",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: "Email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: TextField(
                  controller: _passwordController,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    hintText: "Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: TextButton(
                        onPressed: () async {
                          await Future.delayed(Duration(seconds: 1));
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                          );
                        },
                        child: Text(
                          "Already have account?",
                          style: TextStyle(color: Colors.blue),
                        )),
                  )
                ],
              ),
              Container(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0))),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        signUpWithEmailAndPassword();
                      },
                      child: Text(
                        "Signup",
                        style: TextStyle(color: Colors.white),
                      ))),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }

  void signUpWithEmailAndPassword() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String username = _usernameController.text.trim();
    String phoneno = _phonenoController.text.trim();

    if (email.isNotEmpty &&
        password.isNotEmpty &&
        username.isNotEmpty &&
        phoneno.isNotEmpty) {
      User? user =
          await _authService.signUpWithEmailAndPassword(email, password);
      if (user != null) {
        // Signup successful
        // You can navigate to another page or show a success message

        print('Signup successful');

        FirebaseFirestore.instance.collection("Users").doc(user.uid).set({
          'UserID': user.uid,
          'Username': username,
          'PhoneNo': phoneno,
          'Email': email,
          'CreateDate': DateTime.now(),
        });

        print("data added");

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Signup successful'),
        ));
      }
      _emailController.clear();
      _passwordController.clear();
      _usernameController.clear();
      _phonenoController.clear();

      // Delay for 2 to 3 seconds
      await Future.delayed(Duration(seconds: 2));

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill in all fields'),
        backgroundColor: Colors.blueAccent,
        behavior: SnackBarBehavior.floating,
      ));
      // Fields are empty
      // You can show a message to the user indicating that all fields are required
      // ignore: duplicate_ignore
      // ignore: avoid_print
      print('Please fill in all fields');
    }
  }

  // for forget password
}
