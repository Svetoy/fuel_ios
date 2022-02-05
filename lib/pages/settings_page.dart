import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:todo_flutter/canceled/notification_api.dart';
import 'package:todo_flutter/pages/pipe_support_page.dart';
import 'package:todo_flutter/service/data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<Pipe> pipeList = [];

  List<String> pipName = [];
  List<int> temperature = [];
  List<int> pressure = [];
  List<int> flow = [];
  List<int> activity = [];

  String? email = FirebaseAuth.instance.currentUser!.email;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  var photoUrl = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tz.initializeTimeZones();

    var name = FirebaseDatabase.instance
        .reference()
        .child('Pipilenes')
        .child('Pavlodar-Karaganda');

    name.once().then((DataSnapshot snapshot) {
      pipName.clear();
      temperature.clear();
      flow.clear();
      pressure.clear();
      activity.clear();

      var otrezok = snapshot.value;

      otrezok.forEach((name, value) {
        pipName.add(name);

        var info = FirebaseDatabase.instance
            .reference()
            .child('Pipilenes')
            .child('Pavlodar-Karaganda')
            .child(name);
        info.once().then((DataSnapshot snap) {
          var infoList = snap.value;

          temperature.add(infoList['temperature']);
          pressure.add(infoList['press']);
          flow.add(infoList['flow']);
          activity.add(infoList['active']);

          setState(() {});
        });
      });

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var text = AppLocalizations.of(context);

    var red = 0xffff0000;
    var green = 0xff37eb0f;

    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/images/logo.png'),
        elevation: 0,
        title: Text(
          text!.pipelines,
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          FutureBuilder(
              future: photoUrlMethod(),
              builder: (context, AsyncSnapshot<String> snaphot) {
                if (snaphot.hasData) {
                  return Container(
                    height: 40,
                    width: 40,
                    clipBehavior: Clip.antiAlias,
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 1, color: Colors.orange),
                    ),
                    child: FittedBox(
                        fit: BoxFit.cover, child: Image.network(photoUrl)),
                  );
                }
                return Container(
                  height: 40,
                  width: 40,
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(photoUrl),
                    ),
                    border: Border.all(width: 1, color: Colors.orange),
                  ),
                  // child: NetworkImage(photoUrl),
                );
              }),
        ],
      ),
      body: SafeArea(
        child: pipName.isEmpty &&
                temperature.isEmpty &&
                pressure.isEmpty &&
                flow.isEmpty
            ? Center(child: Text(text.dontHavePipeline))
            : ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                itemCount: pipName.length,
                itemBuilder: (context, int index) {
                  var color = 0;
                  var img = 'assets/images/stableImg.png';

                  if (pressure[index] < 10 || pressure[index] > 30) {
                    color = red;
                    img = 'assets/images/warningImg.png';
                    NotificationApi().showNotification(
                        index,
                        text.problemState,
                        text.pipe +
                            pipName[index] +
                            ' ' +
                            pressure[index].toString() +
                            text.bar,
                        1);
                  } else if( temperature[index] > 60 || temperature[index] < -40){
                    color = red;
                    img = 'assets/images/warningImg.png';
                    NotificationApi().showNotification(
                        index,
                        text.problemState,
                        text.pipe +
                            pipName[index] +
                            ' ' +
                            temperature[index].toString() +
                            '°C',
                        1);
                  }else if(flow[index] < 100 || flow[index] > 200){
                    color = red;
                    img = 'assets/images/warningImg.png';
                    NotificationApi().showNotification(
                        index,
                        text.problemState,
                        text.pipe +
                            flow[index].toString() +
                            ' ' +
                            pressure[index].toString() +
                            text.lmin,
                        1);
                  }else {
                    color = green;
                    img = 'assets/images/stableImg.png';
                  }

                  return Container(
                    height: 190,
                    margin: EdgeInsets.only(
                      bottom: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xfff1f1f1),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Container(
                      margin: EdgeInsets.only(top: 10, left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  img,
                                  color: Color(color),
                                  height: 22,
                                  width: 22,
                                ),
                                Text(
                                  '' +
                                      (pressure[index] < 10 ||
                                              pressure[index] > 30 || temperature[index] > 60 || temperature[index] < -40 || flow[index] < 100 || flow[index] > 200
                                          ? text.problemState
                                          : text.stableState),
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(color)),
                                )
                              ],
                            ),
                          ),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'Pavlodar-Karaganda: ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                pipName[index].toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              )
                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                text.temperature,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                temperature[index].toString() + '°C',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                text.consumption,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                flow[index].toString() + text.lmin,
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                text.pressure,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                pressure[index].toString() + text.bar,
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                text.activity,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                activity[index].toString() == '1'
                                ?text.active
                                :text.notActive,
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),

                          Container(
                            height: 32,
                            width: 160,
                            margin: EdgeInsets.only(top: 10),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color(color)),
                              ),
                              child: Text(
                                text.notify,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PipeSupportPage(
                                            pipName[index].toString())));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
      ),
    );
  }

  Future<String> photoUrlMethod() async {
    photoUrl = await FirebaseStorage.instance
        .ref('user`s photo/')
        .child(uid + '.jpg')
        .getDownloadURL();

    return photoUrl;
  }
}
