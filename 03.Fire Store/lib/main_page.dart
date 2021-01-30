import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_store_app/item_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection("users");
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red[900],
          title: Text('Firestore App'),
          // Single Retrive
          // StreamBuilder<DocumentSnapshot>(
          //   stream: users.doc("3lxbHfUvIov4RB0MoWFS").snapshots(),
          //   builder: (context, snapshot) {
          //     return Text(snapshot.data['age'].toString());
          //   }
          // )
        ),
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            ListView(
              children: [
                // One Time Retrieve
                // FutureBuilder<QuerySnapshot>(
                //     future: users.get(),
                //     builder: (_, snapshot) {
                //       if (snapshot.hasData) {
                //         return Column(
                //           children: snapshot.data.docs
                //               .map((e) =>
                //                   ItemCard(e.data()['name'], e.data()['age']))
                //               .toList(),
                //         );
                //       } else {
                //         return Text("Loading...");
                //       }
                //     }),

                //Sync Retrieve
                StreamBuilder<QuerySnapshot>(
                    stream:
                        //Ordering
                        users.orderBy("age", descending: false).snapshots(),
                    //Filtering
                    //users.where("age",isGreaterThan: 23).snapshots(),
                    builder: (_, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: snapshot.data.docs
                              .map((e) => ItemCard(
                                    e.data()['name'],
                                    e.data()['age'],
                                    onUpdate: () {
                                      users.doc(e.id).update({'age':  e.data()['age']+1});
                                    },
                                    onDelete: () {
                                      users.doc(e.id).delete();
                                    }
                                  ))
                              .toList(),
                        );
                      } else {
                        return Text("Loading...");
                      }
                    }),
                SizedBox(
                  height: 150,
                )
              ],
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        offset: Offset(-5, 0),
                        blurRadius: 15,
                        spreadRadius: 3)
                  ]),
                  width: double.infinity,
                  height: 130,
                  child: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 160,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextField(
                              style: GoogleFonts.poppins(),
                              controller: nameController,
                              decoration: InputDecoration(hintText: "Name"),
                            ),
                            TextField(
                              style: GoogleFonts.poppins(),
                              controller: ageController,
                              decoration: InputDecoration(hintText: "Age"),
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 130,
                        width: 130,
                        padding: const EdgeInsets.fromLTRB(15, 15, 0, 15),
                        child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            color: Colors.red[900],
                            child: Text(
                              'Add Data',
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              users.add({
                                'name': nameController.text,
                                'age': int.tryParse(ageController.text) ?? 0
                              });
                              nameController.text = '';
                              ageController.text = '';
                            }),
                      )
                    ],
                  ),
                )),
          ],
        ));
  }
}
