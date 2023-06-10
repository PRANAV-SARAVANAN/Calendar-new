import 'package:flutter/material.dart';

class Event extends StatelessWidget {
  final String title, description;
  const Event({Key? key,required this.title,required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Description')),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: Text(
                title,
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Text(
                description,

              ),
            ),
            // Container(
            //   margin: EdgeInsets.all(10),
            //   child: Text(
            //     time,
            //
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
