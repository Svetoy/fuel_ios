import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:todo_flutter/pages/history_detail_page.dart';
import 'package:todo_flutter/service/data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String? email = FirebaseAuth.instance.currentUser!.email;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  List<History> historyList = [];
  List<String> azs = [];
  List<String> time = [];
  List<String> status = [];
  List<String> comment = [];
  List<String> city = [];
  List<String> ucomment2 = [];
  List<String> vid = [];
  List<String> photoListUrl = [];

  var photoUrl = '';

  @override
  void initState() {
    super.initState();
    var ordersSnap = FirebaseDatabase.instance.reference().child('Orders');
    ordersSnap.once().then((DataSnapshot ordersV) {
      var ordersValue = ordersV.value;
      ordersValue.forEach((type, typeValue) {
        var more =
            FirebaseDatabase.instance.reference().child('Orders').child(type);
        more.once().then((DataSnapshot dataSnapshot) {
          var a = dataSnapshot.value;
          a.forEach((userKey, emailValue) {
            if (userKey.toString() == uid.toString()) {
              var dateInfo = FirebaseDatabase.instance
                  .reference()
                  .child('Orders')
                  .child(type)
                  .child(userKey);
              dateInfo.once().then((DataSnapshot dateSnap) {
                var b = dateSnap.value;
                b.forEach((dateKey, dateValue) {
                  historyList.clear();

                  var orderInfo = FirebaseDatabase.instance
                      .reference()
                      .child('Orders')
                      .child(type)
                      .child(userKey)
                      .child(dateKey);
                  orderInfo.once().then((DataSnapshot orderSnap) {
                    historyList.clear();

                    var order = orderSnap.value;

                    //var url = FirebaseStorage.instance.ref().child('azs photo/').child(order['azs'].toString() + '.jpg').getDownloadURL();

                    History history = new History(
                        azs: order['azs'].toString(),
                        city: order['city'].toString(),
                        comment: order['comment'].toString(),
                        status: order['status'].toString(),
                        time: order['time'].toString(),
                        ucomment2: order['ucomment2'].toString(),
                        vid: order['vid'].toString());
                    historyList.add(history);

                    azs.add(historyList.first.azs.toString());
                    time.add(historyList.first.time.toString());
                    status.add(historyList.first.status.toString());
                    comment.add(historyList.first.comment.toString());
                    city.add(historyList.first.city.toString());
                    ucomment2.add(historyList.first.ucomment2.toString());
                    vid.add(historyList.first.vid.toString());



                    setState(() {});
                  });
                });
              });
            }
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    var text = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/images/logo.png'),
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.history,
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
      body: SafeArea(
        child: azs.isEmpty
            ? Center(
                child: Text(text!.dohtHaveHistory)
              )
            : ListView.builder(
                padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                itemCount: azs.length,
                itemBuilder: (_, int index) {


                  String state = 'assets/icons/unknownIcon.svg';
                  if (status[index] == 'success') {
                    state = 'assets/icons/doneIcon.svg';
                  } else if (status[index] == 'fault') {
                    state = 'assets/icons/notIcon.svg';
                  }
                  String img = 'assets/images/Astana-TOO_AZS.jpg';

                  return Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      constraints: BoxConstraints(
                        maxHeight: 153,
                          minHeight: 50,
                          maxWidth: width,
                          minWidth: width),
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Color(0xfff1f1f1),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              width: 100,
                              height: 100,
                              // margin: EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  image: DecorationImage(
                                    image: AssetImage(img),
                                    fit: BoxFit.cover,
                                  )),
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: Container(
                              // height: 141,
                              margin: EdgeInsets.only(bottom: 20, left: 10, top: 14),
                              constraints: BoxConstraints(
                                minHeight: 80,
                                minWidth: double.infinity,
                                maxHeight: 100
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 9,
                                          child: Container(

                                            child: Text(
                                              azs[index].toString(),
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),

                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                              alignment: Alignment.topRight,
                                              margin: EdgeInsets.only(top: 0),
                                              child: SvgPicture.asset(state)
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Container(
                                    margin: EdgeInsets.only(top: 14),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            child: SvgPicture.asset(
                                              'assets/icons/timeIcon.svg',
                                              height: 25,
                                              width: 25,
                                            ),
                                          ),
                                        ),

                                        Expanded(
                                          flex: 8,
                                          child: Container(
                                            child: Text(
                                              '  '+time[index],
                                              style:
                                                  TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                      height: 32,
                                      width: 180,
                                      margin: EdgeInsets.only(top: 10),
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                          ),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.orange),
                                        ),
                                        child: Text(
                                          AppLocalizations.of(context)!.more,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HistoryDetailPage(
                                                          azs[index],
                                                          time[index],
                                                          status[index],
                                                          comment[index],
                                                          city[index],
                                                          ucomment2[index],
                                                          vid[index],
                                                          0)
                                              )
                                          );
                                        },
                                      ),
                                    ),
                                ],
                              ),
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

  Future<String> photoUrlMethod () async{
    photoUrl = await FirebaseStorage.instance.ref('user`s photo/').child(uid + '.jpg').getDownloadURL();

    return photoUrl;
  }
}
