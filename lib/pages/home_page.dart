import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_flutter/service/firebase_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_flutter/canceled/notification_api.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import 'more_stations_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthClass authClass = AuthClass();
  TextEditingController controller = TextEditingController();

  List<String> dataList = [];
  String uid = FirebaseAuth.instance.currentUser!.uid;

  String litrK = '';

  List<String> vid = [], active = [];

  List<int> amounts = [];
  List<int> pressures = [];
  List<int> fire = [];
  List<int> flow = [];
  List<int> tempM = [];

  List<List<dynamic>> data = [];

  List<int> lengths = [];
  List<String> allAzs = [];

  int p = 0;

  var photoUrl = '';
  var azsPhotoUrl = '';
  List<String> regNameForPhoto = [];

  @override
  void initState() {
    super.initState();

    var refData = FirebaseDatabase.instance
        .reference()
        .child('Users')
        .child(uid)
        .child('u_azs');

    refData.once().then((DataSnapshot snapshot) {
      dataList.clear();
      //var azsName = snapshot.value;
      snapshot.value.forEach((azsValue) {
        dataList.add(azsValue);

        setState(() {});
      });
    });

    var reg = FirebaseDatabase.instance.reference().child('regions');
    reg.once().then((DataSnapshot snapReg) {
      var regions = snapReg.value;
      regions.forEach((regKey, regValue) {
        var obl = FirebaseDatabase.instance
            .reference()
            .child('regions')
            .child(regKey);
        allAzs.clear();

        regNameForPhoto.clear();

        obl.once().then((DataSnapshot snapAzs) {
          var azss = snapAzs.value;

          azss.forEach((key, value) {
            ///Блок фильтра азс
            if (dataList.contains(key)) {

              allAzs.add(key);

              var fuel = FirebaseDatabase.instance
                  .reference()
                  .child('regions')
                  .child(regKey)
                  .child(key)
                  .child('fuel');
              fuel.once().then((DataSnapshot snapFuel) {
                var temp = snapFuel.value;
                lengths.add(temp.length);

                temp.forEach((fuelType, fuelValue) {
                  vid.add(fuelType.toString());
                  amounts.add(fuelValue['col']);
                  pressures.add(fuelValue['bar']);
                  active.add(fuelValue['active'].toString());
                  fire.add(fuelValue['fire']);
                  flow.add(fuelValue['flowM']);
                  tempM.add(fuelValue['temp']);

                  setState(() {});
                });
              });

              data.add(vid);
              data.add(amounts);
              data.add(pressures);
              data.add(active);
              data.add(fire);
              data.add(flow);
              data.add(tempM);

              // data.add(allAzs);
              // data.add(lengths);

              vid.clear();
              amounts.clear();
              pressures.clear();
              active.clear();
              fire.clear();
              flow.clear();
              tempM.clear();
            }

            ///Блок фильтра азс
          });
          setState(() {});
        });
        setState(() {});
      });
      setState(() {
        ///Блок фильтра азс
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    var text = AppLocalizations.of(context);
    p = 0;

    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/images/logo.png'),
        elevation: 0,
        title: Text(
          text!.stations,
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
                      image:  NetworkImage(photoUrl),
                    ),
                    border: Border.all(width: 1, color: Colors.orange),
                  ),
                  // child: NetworkImage(photoUrl),
                );
              }),
        ],
      ),
      body: data.isEmpty && lengths.isEmpty && lengths.length < 1
          ? Center(
              child: Text(text.dontHaveStation),
            )
          : SafeArea(
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: height,
                  maxWidth: width,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: ListView.builder(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          itemCount: allAzs.length,
                          itemBuilder: (BuildContext context, int index) {
                            int j = index;
                            String img = 'assets/images/Astana-TOO_AZS.jpg';


                            return dataList.length > 0
                                ? Container(
                                    padding: EdgeInsets.all(10),
                                    constraints: BoxConstraints(
                                        maxHeight: 300,
                                        minHeight: 50,
                                        maxWidth: width,
                                        minWidth: width),
                                    margin: EdgeInsets.only(
                                      top: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xfff1f1f1),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            height: 100,
                                            width: 100,
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                image: DecorationImage(
                                                  image: AssetImage(img),
                                                  fit: BoxFit.cover,
                                                )),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 7,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  dataList[index],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                                Container(
                                                  constraints: BoxConstraints(
                                                    minWidth: double.infinity,
                                                    minHeight: 50,
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 4),
                                                  child: ListView.custom(
                                                    shrinkWrap: true,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    childrenDelegate:
                                                        SliverChildBuilderDelegate(
                                                      (context, int i) {
                                                        p++;
                                                        if (data[1][index] >= 1000){
                                                          int v = data[1][p-1];
                                                          litrK = (v / 1000).toString() + text.k;
                                                        } else {
                                                          litrK = data[1][p -1].toString();
                                                        }

                                                        // if(data[2][p-1] > 10){
                                                        //   NotificationApi().showNotification(2, text.problemState, allAzs[index] + ' ' + data[2][p-1].toString() + text.bar, 1);
                                                        // }else if(data[5][index] > 100 || data[5][index] < 200){
                                                        //   NotificationApi().showNotification(5, text.problemState, text.fuelConsumption +data[5][index].toString(), 1);
                                                        // }else if(data[6][index] > 60.0 || data[6][index] < -40.0){
                                                        //   NotificationApi().showNotification(6, text.problemState, text.temperature +data[6][index].toString(), 1);
                                                        // }else if(data[1][index] > 100 || data[1][index] < 1000){
                                                        //   NotificationApi().showNotification(1, text.problemState, text.fuelQuantity +data[1][index].toString(), 1);
                                                        // }

                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 6),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  child: Row(
                                                                    children: [
                                                                      Container(
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Text(
                                                                              data[0][p - 1] + ':',
                                                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                                                            ),
                                                                            SvgPicture.asset(
                                                                              'assets/icons/fuelIcon.svg',
                                                                              height: 15,
                                                                              width: 15,
                                                                            ),
                                                                            Text(' ' +
                                                                                litrK +
                                                                                text.litr),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      Container(
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            SvgPicture.asset(
                                                                              'assets/icons/pressuerIcon.svg',
                                                                              height: 15,
                                                                              width: 15,
                                                                            ),
                                                                            Text(' ' +
                                                                                data[2][p - 1].toString() +
                                                                                text.bar),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                flex: 9,
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topRight,
                                                                    child: SvgPicture
                                                                        .asset(
                                                                      'assets/icons/stateIcon.svg',
                                                                      color: data[3][p - 1] ==
                                                                              0
                                                                          ? Color(0xffC8C8C8
                                                                              )
                                                                          : Color(
                                                                          0xff00FF47),
                                                                      height:
                                                                          15,
                                                                      width: 15,
                                                                    ),
                                                                  ),
                                                                ),
                                                                flex: 1,
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                      childCount: lengths[j],
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Container(
                                                    height: 32,
                                                    width: 160,
                                                    margin: EdgeInsets.only(
                                                      top: 0,
                                                    ),
                                                    child: ElevatedButton(
                                                      style: ButtonStyle(
                                                        shape: MaterialStateProperty
                                                            .all<
                                                                RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                          ),
                                                        ),
                                                        backgroundColor:
                                                            MaterialStateProperty.all<Color>(Colors.orange),
                                                      ),
                                                      child: Text(
                                                        text.more,
                                                        style: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  MoreStationsPage(
                                                                    data,
                                                                    lengths[j],
                                                                    p,
                                                                    dataList[index],
                                                                  )),
                                                        );

                                                        print(data[6][index]);
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container();
                          }),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<String> photoUrlMethod() async {
    photoUrl = await FirebaseStorage.instance.ref('user`s photo/').child(uid + '.jpg').getDownloadURL();
    return photoUrl;
  }
}
