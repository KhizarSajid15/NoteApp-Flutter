// ignore_for_file: camel_case_types, unnecessary_import, non_constant_identifier_names, prefer_typing_uninitialized_variables, avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterp2/Pages/encryptionService.dart';

class editnote extends StatefulWidget {
  final Map<String, dynamic> argument;

  const editnote({super.key, required this.argument});

  @override
  State<editnote> createState() => _editnoteState();
}

class _editnoteState extends State<editnote> {
  TextEditingController update_title = TextEditingController();
  TextEditingController update_note = TextEditingController();

  var docId;

  // get argument data
  @override
  void initState() {
    super.initState();
    // Initialize text controllers with argument data
    update_title.text = widget.argument['Title'];
    update_note.text = widget.argument['Note'];
    docId = widget.argument['DocId'];
  }
  // final String docId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        actions: [
          IconButton(
              onPressed: () async {
                // encrypted
                const String encryptionKey =
                    "mySecretKey123"; // Your encryption key
                final EncryptionService encryptionService =
                    EncryptionService(encryptionKey: encryptionKey);
                final String encryptedTitle =
                    encryptionService.encrypt(update_title.text.trim());
                final String encryptedNote =
                    encryptionService.encrypt(update_note.text.trim());
                await FirebaseFirestore.instance
                    .collection("Notes")
                    .doc(docId)
                    .update({
                  'Note': encryptedNote,
                  'Title': encryptedTitle,
                  'CreateDate': DateTime.now(),
                });
                // Dismiss the keyboard
                FocusScope.of(context).unfocus();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.check_circle))
        ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Container(
              child: TextFormField(
                controller: update_title,
                decoration: const InputDecoration(
                    hintText: "Write Title",
                    hintStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    border: InputBorder.none),
              ),
            ),
            Container(
              child: TextFormField(
                controller: update_note,
                maxLines: null,
                decoration: const InputDecoration(
                    hintText: "Note down Something", border: InputBorder.none),
              ),
            )
          ],
        ),
      ),
    );
  }
}
