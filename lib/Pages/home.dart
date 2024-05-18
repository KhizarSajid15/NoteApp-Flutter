// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, non_constant_identifier_names

// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterp2/Pages/about_page.dart';
import 'package:flutterp2/Pages/add_note.dart';
import 'package:flutterp2/Pages/editnote_screen.dart';
import 'package:flutterp2/Pages/encryptionService.dart';
// ignore: unused_import
import 'package:flutterp2/Pages/login_page.dart';
import 'package:intl/intl.dart';
import 'package:xor_encryption/xor_encryption.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _homeState();
}

// ignore: camel_case_types
class _homeState extends State<Home> {
  // ignore: duplicate_ignore
  // ignore: non_constant_identifier_names
  User? UserId = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("NoteApp"),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
        ),
        drawer: Drawer(
          // Drawer content here
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                  decoration: BoxDecoration(color: Colors.white30),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_outline_rounded,
                          color: Colors.blue,
                          size: 100,
                        ),
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("Users")
                                .doc(UserId?.uid)
                                .snapshots(),
                            builder: (context, userSnapshot) {
                              if (userSnapshot.hasData) {
                                var username = userSnapshot.data!["Username"];
                                return Text(
                                  username,
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ); // Show username
                              }
                              return Container();
                            }),
                      ],
                    ),
                  )),
              ListTile(
                title: Text('About'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => About()));
                  // Handle item 1 tap
                },
                leading: Icon(
                  Icons.info,
                  color: Colors.lightBlue,
                ),
              ),
              ListTile(
                title: Text('Logout'),
                onTap: () {
                  _showExitConfirmationDialog(context);
                },
                leading: Icon(
                  Icons.logout,
                  color: Colors.lightBlue,
                ),
              ),
            ],
          ),
        ),
        body: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Notes")
                    .where("UserId", isEqualTo: UserId?.uid)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text("Something went wrong");
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CupertinoActivityIndicator(
                        animating: true,
                      ),
                    );
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text("Data not found"),
                    );
                  }

                  // ignore: unnecessary_null_comparison
                  if (snapshot != null && snapshot.data != null) {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DateTime createDate = (snapshot.data!.docs[index]
                                  ["CreateDate"] as Timestamp)
                              .toDate();
                          var Id = snapshot.data!.docs[index].id;
                          var Title = snapshot.data!.docs[index]["Title"];
                          var Note = snapshot.data!.docs[index]["Note"];

                          // Decrypt title and note
                          // Use the same encryption key that was used for encryption
                          const String encryptionKey =
                              "mySecretKey123"; // Your encryption key

                          final DecryptionService decryptionService =
                              DecryptionService(encryptionKey: encryptionKey);
                          String decryptedTitle =
                              decryptionService.decrypt(Title);
                          String decryptedNote =
                              decryptionService.decrypt(Note);

                          // Format DateTime as needed (e.g., to display date/time)
                          String formattedCreateDate = DateFormat(
                                  'dd-MM-yyyy \t\t\t\t\t\t\t\t\t\t\t\t\t\t hh:mm a')
                              .format(
                                  createDate); // Modify this line to format as needed
                          return Card(
                            child: InkWell(
                              onTap: () async {
                                await Future.delayed(Duration(seconds: 1));
                                Navigator.push(
                                    // ignore: use_build_context_synchronously
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => editnote(
                                              argument: {
                                                'Note': decryptedNote,
                                                'Title': decryptedTitle,
                                                'DocId': Id
                                              },
                                            )));
                                print("tape");
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      title: Text(
                                        decryptedTitle,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        decryptedNote, // Adjust the
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ), // Use ellipses (...) for overflow),
                                      // leading: Text(formattedCreateDate),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: 20,
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              await FirebaseFirestore.instance
                                                  .collection("Notes")
                                                  .doc(Id)
                                                  .delete();

                                              // ignore: avoid_print
                                              print("delet");
                                            },
                                            child: Icon(Icons.delete_sharp),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 500,
                                      padding: EdgeInsets.only(left: 15),
                                      child: Text(
                                        formattedCreateDate,
                                        style: TextStyle(fontSize: 9),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  }

                  return Container();
                })),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => add_note()),
            );
          },
          label: Icon(Icons.add),
        ));
  }

  // used for to show only needed word are show in the card

  String _truncateString(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return text.substring(0, maxLength);
    }
  }

  void _showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout Confirmation'),
          content: Text('Are you sure you want to Logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () async {
                // Before signing out

                showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext context) {
                    return Center(
                      child: CupertinoActivityIndicator(),
                    );
                  },
                );

                await FirebaseAuth.instance.signOut();
                print("Sign out");

                await Future.delayed(Duration(seconds: 2));

                //after signout going to login screen
                Navigator.of(context).pushAndRemoveUntil(
                    new MaterialPageRoute(builder: (context) => new Login()),
                    (route) => false);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
