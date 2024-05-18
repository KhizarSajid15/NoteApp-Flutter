// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, avoid_print, use_build_context_synchronously, duplicate_ignore

// ignore: unused_import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterp2/Pages/firebase_auth.dart';
import 'package:flutterp2/Pages/home.dart';
import 'package:flutterp2/Pages/signup_page.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _passwordVisible = false;

  final FirebaseAuthService _authService = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late String name, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 50),
          child: Column(
            children: [
              Center(
                child: CircleAvatar(
                  radius: 150,
                  backgroundImage: AssetImage("assets/Login.jpg"),
                ),
              ),
              Text(
                "Login",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: "Email",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
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
                    // ignore: duplicate_ignore
                    // ignore: sized_box_for_whitespace
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Container(
                          child: TextButton(
                              onPressed: () async {
                                await Future.delayed(Duration(seconds: 1));
                                sendPasswordResetEmail();
                              },
                              child: Text(
                                "Forget Password?",
                                style: TextStyle(color: Colors.blue),
                              )),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 48),
                          child: TextButton(
                              onPressed: () async {
                                await Future.delayed(Duration(seconds: 1));
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Signup()),
                                );
                              },
                              child: Text(
                                "Dont have account?",
                                style: TextStyle(color: Colors.blue),
                              )),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            width: 200,
                            height: 50,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.lightBlue,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0))),
                                onPressed: () {
                                  //dismiss they keyboard
                                  FocusScope.of(context).unfocus();

                                  name = _emailController.text;
                                  password = _passwordController.text;

                                  _signInWithEmailAndPassword(context);
                                },
                                child: Text(
                                  "Login",
                                  style: TextStyle(color: Colors.white),
                                ))),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    final email = _emailController.text;
    final password = _passwordController.text;

    // Check if the email is not registered

    final user = await _authService.signInWithEmailAndPassword(email, password);

    if (user != null) {
      // Navigate to the next screen upon successful login
      // Example:

      print("Login Successfull");
      print(email);
      print(password);
      _emailController.clear();
      _passwordController.clear();

      // ignore: duplicate_ignore

      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: CupertinoActivityIndicator(),
          );
        },
      );
      // ignore: use_build_context_synchronously

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Login Successfully'),
          backgroundColor: Colors.blueAccent,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2)));

      // Delay for 2 to 3 seconds
      await Future.delayed(Duration(seconds: 2));

      //after login:
      Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
      // Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Show error message to the user
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Email and Password not valid'),
          backgroundColor: Colors.blueAccent,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2)));
    }
  }

  void sendPasswordResetEmail() {
    String email = _emailController.text.trim();

    if (email.isNotEmpty) {
      // Reset password functionality
      _authService.sendPasswordResetEmail(email);
      // Display a message to the user
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Password reset email sent. Check your inbox.'),
          backgroundColor: Colors.blueAccent,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2)));
      print('Password reset email sent. Check your inbox.');
    } else {
      // Display an error message if email is empty

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please enter your email.'),
          backgroundColor: Colors.blueAccent,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2)));
      print('Please enter your email.');
    }
  }
}
