import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HistoryDetailPage extends StatefulWidget {
  String azs;
  String time;
  String status;
  String comment;
  String city;
  String ucomment2;
  String vid;
  int a;

  HistoryDetailPage(this.azs, this.time, this.status, this.comment, this.city,
      this.ucomment2, this.vid, this.a);

  @override
  _HistoryDetailPageState createState() => _HistoryDetailPageState(
      this.azs,
      this.time,
      this.status,
      this.comment,
      this.city,
      this.ucomment2,
      this.vid,
      this.a);
}

class _HistoryDetailPageState extends State<HistoryDetailPage> {
  String azs;
  String time;
  String status;
  String comment;
  String city;
  String ucomment2;
  String vid;
  int a;

  _HistoryDetailPageState(this.azs, this.time, this.status, this.comment,
      this.city, this.ucomment2, this.vid, this.a);

  String? email = FirebaseAuth.instance.currentUser!.email;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  TextEditingController textController = new TextEditingController();

  var photoUrl = '';

  @override
  Widget build(BuildContext context) {
    var text = AppLocalizations.of(context);

    Size size = MediaQuery.of(context).size;
    String state = 'assets/icons/unknownIcon.svg';
    if (status == 'success') {
      state = 'assets/icons/doneIcon.svg';
    } else if (status == 'fault') {
      state = 'assets/icons/notIcon.svg';
    }

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset(
              'assets/images/pop.png',
            )),
        title: Text(
          text!.more,
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
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
      body: Center(
        child: Container(
          margin: EdgeInsets.only(top: 20),
          width: size.width - 20,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10),
                  child: Row(
                    children: [
                      Text(
                        vid.replaceFirst('a', 'A') == text.application ?text.application :text.support,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Spacer(),
                      Container(
                        margin: EdgeInsets.only(right: 20),
                        child: Align(
                            alignment: Alignment.topRight,
                            child: SvgPicture.asset(state),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, left: 10),
                      child: Text(
                        text.station,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        azs,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        text.city,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: Text(
                        city,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,

                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [

                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        text.date,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: Text(
                        time,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: 150,
                margin: EdgeInsets.only(right: 10, left: 10, top: 20),
                child: TextFormField(
                  keyboardType: TextInputType.none,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  initialValue: comment,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: text.ucomment,
                    labelStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.orange,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        width: 2,
                        color: Colors.orange,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        width: 2,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ucom(),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 200,
                  margin: EdgeInsets.only(left: 10, top: 15),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.orange),
                    ),
                    child: Text(
                      text.reset,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    onPressed: () {
                      DateTime now = new DateTime.now();
                      final DateFormat formatter =
                          DateFormat('dd.MM.yyyy HH:mm:ss');
                      final String formatted = formatter.format(now);
                      String normDate = formatted.toString().trim();
                      normDate = normDate
                          .replaceFirst(' ', '--')
                          .replaceAll(':', '-')
                          .replaceAll('.', '-');

                      if (vid == text.application.toLowerCase()) {
                        var setData = FirebaseDatabase.instance
                            .reference()
                            .child('Orders')
                            .child('application')
                            .child(uid)
                            .child(normDate);
                        setData.set({
                          'azs': azs,
                          'city': city,
                          'comment': comment.toString(),
                          'email': email,
                          'status': 'inProgress',
                          'time': formatted,
                          'ucomment2': '',
                          'vid': text.application.toLowerCase()
                        });

                        final snackbar =
                            SnackBar(content: Text(text.applicationIsSent));
                        ScaffoldMessenger.of(context).showSnackBar(snackbar);
                      } else {
                        var setData = FirebaseDatabase.instance
                            .reference()
                            .child('Orders')
                            .child('support')
                            .child(uid)
                            .child(normDate);
                        setData.set({
                          'azs': azs,
                          'city': city,
                          'comment': comment,
                          'email': email,
                          'status': 'inProgress',
                          'time': formatted,
                          'ucomment2': '',
                          'vid': text.support.toLowerCase()
                        });

                        final snackbar =
                            SnackBar(content: Text(text.supportIsSent));
                        ScaffoldMessenger.of(context).showSnackBar(snackbar);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget ucom() {
    var text = AppLocalizations.of(context);

    return ucomment2.length < 1
        ? Container()
        : Container(
            height: 150,
            margin: EdgeInsets.only(right: 10, left: 10, top: 5),
            child: TextFormField(
              keyboardType: TextInputType.none,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              initialValue: ucomment2,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                labelText: text!.answer,
                labelStyle: TextStyle(
                  fontSize: 18,
                  color: Colors.orange,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    width: 2,
                    color: Colors.orange,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    width: 2,
                    color: Colors.orange,
                  ),
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
