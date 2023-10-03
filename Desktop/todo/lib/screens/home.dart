import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/auth/login_view.dart';
import 'package:todo/screens/addtask.dart';
import 'package:todo/screens/discription.dart';

enum MenuAction { logout }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;

  final _userStream = FirebaseFirestore.instance
      .collection("users")
      .snapshots(includeMetadataChanges: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddTask(
                        username: user!.uid,
                      )));
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        actions: [
          PopupMenuButton<MenuAction>(onSelected: (value) async {
            switch (value) {
              case MenuAction.logout:
                final isLogOut = await showLogOutDialog(context);
                if (isLogOut) {
                  FirebaseAuth.instance.signOut();
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                }
            }
          }, itemBuilder: (context) {
            return const [
              PopupMenuItem<MenuAction>(
                value: MenuAction.logout,
                child: Text("Logout"),
              )
            ];
          })
        ],
        title: const Text("AllNotes"),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(user!.uid)
              .snapshots(includeMetadataChanges: true),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const CircularProgressIndicator();
              default:
                return Container(
                  child: ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      var id = document.id;
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.elliptical(20, 10),
                                bottomLeft: Radius.elliptical(10, 20))),
                        child: ListTile(
                          trailing: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Discription(
                                                discription:
                                                    data['password'])));
                                  },
                                  icon: const Icon(Icons.open_in_new)),
                              IconButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection(user!.uid)
                                        .doc(id)
                                        .delete();
                                  },
                                  icon: const Icon(Icons.delete))
                            ],
                          ),
                          title: Text(data['username'].toString()),
                        ),
                      );
                    }).toList(),
                  ),
                );
            }
          }),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Log Out"),
          content: const Text("Are you sure you want to log out"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text("Cancel")),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text("Logout"))
          ],
        );
      }).then((value) => value ?? false);
}
