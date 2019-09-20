import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class DevFest {
  String name;
  DevFest(this.name);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GDG MAD',
      debugShowCheckedModeBanner: false,
      home: MyHome(),
    );
  }
}

class MyHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GDG MAD'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('devfest').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemBuilder: (context, index) {
                return buildListTile(snapshot.data.documents[index]);
              },
              itemCount: snapshot.data.documents.length,
            );
          }
        },
      ),
    );
  }

  Widget buildListTile(DocumentSnapshot documentSnapshot) {
    return ListTile(
      onTap: () {Firestore.instance.runTransaction((transaction) async {
          DocumentSnapshot latestSnapshot =
          await transaction.get(documentSnapshot.reference);
          await transaction.update(latestSnapshot.reference, {
            'members': latestSnapshot['members'] + 1,
          });
        });
      },
      title: Text(documentSnapshot['name']),
      trailing: Text(documentSnapshot['members'].toString()),
    );
  }
}
