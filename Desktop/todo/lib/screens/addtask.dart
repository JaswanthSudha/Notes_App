import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo/routes/routes.dart';

import 'package:todo/screens/home.dart';

class AddTask extends StatefulWidget {
  final String username;
  const AddTask({super.key, required this.username});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  late final TextEditingController _title;
  late final TextEditingController _discription;

  void initState() {
    _title = TextEditingController();
    _discription = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _title.dispose();
    _discription.dispose();
    super.dispose();
  }

  // Fluttertoast.showToast(
  //       msg: "This is Center Short Toast",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.CENTER,
  //       timeInSecForIosWeb: 1,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //       fontSize: 16.0
  //   );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AddNewNote"),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              child: TextField(
                controller: _title,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(hintText: "Enter title"),
              ),
            ),
            Container(
              child: TextField(
                controller: _discription,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration:
                    const InputDecoration(hintText: "Enter Discription"),
              ),
            ),
            Container(
              child: ElevatedButton(
                  onPressed: () async {
                    FirebaseFirestore.instance.collection(widget.username).add({
                      "username": _title.text,
                      "password": _discription.text,
                      "time": DateTime.now()
                    });
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(homeRoute, (route) => false);
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const HomePage()));
                  },
                  child: const Text("Add")),
            )
          ],
        ),
      ),
    );
  }
}
