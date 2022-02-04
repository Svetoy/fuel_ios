import 'package:flutter/material.dart';
import 'package:todo_flutter/canceled/notification_api.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  void initState() {
    super.initState();

    tz.initializeTimeZones();
  }


  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    int a = 1;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 2,
        title: Text('Test Page'),
        centerTitle: true,
      ),
      body: Container(
        width: width,
        height: height,
        child: Center(
          child: ElevatedButton(
            child: Text('asset'),

            onPressed: (){
              NotificationApi().showNotification(a, 'title', 'body', 1);

              a++;
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        backgroundColor: Colors.orange,
        child: Icon(Icons.ac_unit),
      ),
    );
  }
}
