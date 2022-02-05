import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MoreStationsPage extends StatefulWidget {
  List<List<dynamic>> data;
  int count;
  int p;
  String azs;

  MoreStationsPage(this.data, this.count, this.p, this.azs);

  @override
  _MoreStationsPageState createState() =>
      _MoreStationsPageState(this.data, this.count, this.p, this.azs);
}

class _MoreStationsPageState extends State<MoreStationsPage> {
  List<List<dynamic>> data;
  int count;
  int p;
  String azs;

  _MoreStationsPageState(this.data, this.count, this.p, this.azs);

  String uid = FirebaseAuth.instance.currentUser!.uid;
  var photoUrl = '';

  @override
  Widget build(BuildContext context) {
    var text = AppLocalizations.of(context);
    Size size = MediaQuery.of(context).size;
    String img = 'assets/images/Astana-TOO_AZS.jpg';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          text!.more,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset('assets/icons/back.svg'),
        ),
        actions: [
          FutureBuilder(
              future: photoUrlMethod(),
              builder: (context, AsyncSnapshot<String> snaphot)
              {

                if(snaphot.hasData){
                  return Container(
                    height: 40,
                    width: 40,
                    clipBehavior: Clip.antiAlias,
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                      border: Border.all(
                          width: 1,
                          color: Colors.orange
                      ),
                    ),

                    child: FittedBox(
                        fit: BoxFit.cover,
                        child: Image.network(photoUrl)
                    ),
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
                    border: Border.all(
                        width: 1,
                        color: Colors.orange
                    ),
                  ),
                  // child: NetworkImage(photoUrl),
                );
              }
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color(0xfff1f1f1),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4, left: 20, bottom: 10),
                  child: Text(
                    azs,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                width: size.width - 40,
                height: 140,
                // margin: EdgeInsets.only(left: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: AssetImage(img),
                      fit: BoxFit.cover,
                    )),
              ),
              Container(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: count,
                    itemBuilder: (context, int index) {
                      return Container(
                        child: Column(
                          children: [
                            Align(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 16, left: 10, bottom: 10),
                                child: Text(
                                  data[0][index].toString() + ':',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              alignment: Alignment.topLeft,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                children: [
                                  Container(

                                      child: SvgPicture.asset(
                                    'assets/icons/fuelIcon.svg',
                                    height: 12,
                                    width: 12,
                                  ),
                                    height: 14,
                                    width: 14,
                                  ),
                                  Text(text.fuelQuantity),
                                  Text(
                                    data[1][index].toString(),
                                  ),
                                  Text(text.litr)
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                children: [
                                  Container(
                                    child: SvgPicture.asset(
                                      'assets/icons/pressuerIcon.svg',
                                      height: 10,
                                      width: 10,
                                    ),
                                    height: 14,
                                    width: 14,
                                  ),
                                  Text(text.fuelPressure),
                                  Text(data[2][index].toString()),
                                  Text(text.bar)
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                children: [
                                  Container(
                                    child: SvgPicture.asset(
                                      'assets/icons/rashodIcon.svg',
                                      height: 12,
                                      width: 12,
                                    ),
                                    height: 14,
                                    width: 14,
                                  ),
                                  Text(text.fuelConsumption),
                                  Text(data[5][index].toString()),
                                  Text(text.lmin)
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                children: [
                                  Container(
                                    child: SvgPicture.asset(
                                      'assets/icons/temperatureIcon.svg',
                                      height: 10,
                                      width: 10,
                                    ),
                                    height: 14,
                                    width: 14,
                                  ),
                                  Text('  ' + text.temperature),
                                  Text(data[6][index].toString()),
                                  Text('°C')
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                children: [
                                  Container(
                                    child: SvgPicture.asset(
                                      'assets/icons/fireIcon.svg',
                                      height: 12,
                                      width: 12,
                                    ),
                                    height: 14,
                                    width: 14,
                                  ),
                                  Text(text.flame),
                                  Text(text.stableState)
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 0),
                              child: Row(
                                children: [
                                  Container(
                                    child: SvgPicture.asset(
                                      'assets/icons/stateIcon.svg',
                                      height: 10,
                                      width: 10,
                                    ),
                                    height: 14,
                                    width: 14,
                                  ),
                                  Text('  ' + text.activity),
                                  Text(text.active)
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> photoUrlMethod () async{
    photoUrl = await FirebaseStorage.instance.ref('user`s photo/').child(uid + '.jpg').getDownloadURL();

    return photoUrl;
  }
}
