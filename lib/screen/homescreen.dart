import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// List todos = List();
String input = "";

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  createTodos() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('MyToDos').doc(input);
    Map<String, String> todos = {
      "todoTitle": input,
    };

    documentReference.set(todos).whenComplete(() => print("$input created"));
  }

  deleteTodos() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('MyToDos').doc(input);

    documentReference.delete().whenComplete(() => print("$input deleted"));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "To-Do",
            style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.w800,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
              padding: EdgeInsets.all(3.2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
              ),
              child: CircleAvatar(
                backgroundImage: AssetImage("assets/pic1.png"),
                radius: 20,
              ),
            )
          ],
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Center(
              child: Container(
                child: Image.asset(
                  "assets/pic2.png",
                  colorBlendMode: BlendMode.lighten,
                  color: Colors.white70,
                ),
              ),
            ),
            StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('MyToDos').snapshots(),
              builder: (context, snapshots) {
                if (snapshots.data == null) return CircularProgressIndicator();
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshots.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot documentSnapshot =
                        snapshots.data.documents[index];
                    return Dismissible(
                      onDismissed: (direction) {
                        deleteTodos();
                      },
                      key: Key(index.toString()),
                      child: Card(
                        elevation: 4,
                        margin: EdgeInsets.only(top: 15, left: 10, right: 10),
                        color: Colors.purple[50],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: ListTile(
                          title: Text(documentSnapshot["todoTitle"]),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete_forever_rounded,
                              color: Colors.red,
                              size: 30,
                            ),
                            onPressed: () {
                              deleteTodos();
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            size: 35.0,
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    title: Text("Add ToDo"),
                    content: TextField(
                      onChanged: (String value) {
                        input = value;
                      },
                    ),
                    actions: [
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "BACK",
                          style: TextStyle(
                            color: Colors.purple,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          createTodos();
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "ADD",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  );
                });
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          color: Colors.green,
          child: Container(
            height: 50,
            // color: Colors.green,
          ),
          elevation: 4,
          shape: CircularNotchedRectangle(),
        ),
      ),
    );
  }
}
