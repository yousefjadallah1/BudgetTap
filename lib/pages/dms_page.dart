import 'package:flutter/material.dart';
import 'package:font_awesome_metadata/font_awesome_metadata.dart';

class DMsPage extends StatelessWidget {
  const DMsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: false,
        title: Text('_yousefjad') ,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(FontAwesomeIcons.message)),
        ],
      ),
      body: const Center(
        child: Text('This is the second page'),
      ),
    );
  }
}
