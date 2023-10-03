import 'package:flutter/material.dart';

class Discription extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final discription;
  const Discription({super.key, required this.discription});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MyNotes"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(),
        child: Text(discription.toString()),
      ),
    );
  }
}
