import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterp2/Pages/encryptionService.dart';
import 'package:intl/intl.dart';
import 'package:xor_encryption/xor_encryption.dart';

// ignore: camel_case_types
class add_note extends StatefulWidget {
  const add_note({super.key});

  @override
  State<add_note> createState() => _add_noteState();
}

// ignore: camel_case_types
class _add_noteState extends State<add_note> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteContnroller = TextEditingController();

  User? userId = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add Note"),
          actions: [
            IconButton(
              icon: const Icon(Icons.check), // You can use any icon you want
              onPressed: () async {
                // ignore: non_constant_identifier_names
                var title_note = _titleController.text.trim();
                // ignore: non_constant_identifier_names
                var info_note = _noteContnroller.text.trim();

                if (title_note != "" && info_note == "") {
                  // ignore: avoid_print
                  print("title empty");
                }
                if (title_note == "" && info_note != "") {
                  // ignore: avoid_print
                  print("note empty");
                }

                if (title_note != "" && info_note != "") {
                  try {
                    // Encrypt the title and note before saving
                    const String encryptionKey =
                        "mySecretKey123"; // Your encryption key
                    final EncryptionService encryptionService =
                        EncryptionService(encryptionKey: encryptionKey);
                    final String encryptedTitle =
                        encryptionService.encrypt(title_note);
                    final String encryptedNote =
                        encryptionService.encrypt(info_note);

                    await FirebaseFirestore.instance
                        .collection("Notes")
                        .doc()
                        .set({
                      'Title': encryptedTitle,
                      'Note': encryptedNote,
                      'CreateDate': DateTime.now(),
                      'UserId': userId?.uid
                    });

                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  } catch (e) {
                    // ignore: avoid_print
                    print("Error: $e");
                  }
                } else {
                  // ignore: avoid_print
                  print("fill the form");
                }

                // Add your onPressed callback here
              },
            ),
          ],
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              // ignore: avoid_unnecessary_containers
              Container(
                child: Text(
                    DateFormat('dd-MM-yyyy \t hh:mm a').format(DateTime.now())),
              ),
              // ignore: avoid_unnecessary_containers
              Container(
                child: TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                      hintText: "Write Title",
                      hintStyle:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      border: InputBorder.none),
                ),
              ),
              // ignore: avoid_unnecessary_containers
              Container(
                child: TextFormField(
                  controller: _noteContnroller,
                  maxLines: null,
                  decoration: const InputDecoration(
                      hintText: "Note down Something",
                      border: InputBorder.none),
                ),
              )
            ],
          ),
        ));
  }
}
