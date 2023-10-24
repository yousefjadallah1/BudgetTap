import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

Future<Widget> content() async {
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('usernames');
  DatabaseEvent event = await ref.once();

  return Text(event.snapshot.value.toString());
}
 