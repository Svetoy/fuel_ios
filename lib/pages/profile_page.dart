import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_flutter/pages/reset_password_page.dart';
import 'package:todo_flutter/pages/start_page.dart';
import 'package:todo_flutter/service/data.dart';
import 'package:todo_flutter/service/firebase_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isDone = false;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String? emailFire = FirebaseAuth.instance.currentUser!.email;
  AuthClass authClass = new AuthClass();

  String photoUrl = '';

  Future<UsersInfo> fetchUsers() async {
    DataSnapshot snapshot = await FirebaseDatabase.instance
        .reference()
        .child('Users')
        .child(uid)
        .once();
    var values = snapshot.value;

    photoUrl = await FirebaseStorage.instance.ref('user`s photo/').child(uid + '.jpg').getDownloadURL();

    if(photoUrl.isNotEmpty){

    }
    if (values != null) {
      return UsersInfo.fromJson(json: values);
    } else {
      return throw Exception('Please wait...');
    }
  }

  late Future<UsersInfo> futureUsers;

  @override
  Widget build(BuildContext context) {
    var text = AppLocalizations.of(context);
    futureUsers = fetchUsers();

    return Scaffold(
        appBar: AppBar(
          leading: Image.asset('assets/images/logo.png'),
          elevation: 0,
          title: Text(
            text!.profile,
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
        body: Center(
          child: FutureBuilder<UsersInfo>(
            future: futureUsers,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return getUser(
                    snapshot.data!.u_name.toString(),
                    snapshot.data!.surName.toString(),
                    snapshot.data!.middleName.toString(),
                    snapshot.data!.email.toString(),
                    snapshot.data!.date.toString(),
                    snapshot.data!.phoneNumber.toString());
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return CircularProgressIndicator(
                color: Colors.orange,
              );
            },
          ),
        ));
  }

  Widget getUser(String name, surname, patronymic, email, date, phone) {
    var text = AppLocalizations.of(context);
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: size.width - 40,
            height: 200,
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: Color(0xfff1f1f1),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  margin: EdgeInsets.only(left: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: NetworkImage(photoUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only( left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                              name + ' ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          Text(
                            surname,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        patronymic,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        text!.emaill,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          email,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Text(
                        text.dateOfBirth,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        date,
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                  ),

                      Text(
                        text.phoneNumber,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        phone,
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: 200,

              margin: EdgeInsets.only(left: 20, top: 15),
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xff686868)),
                ),
                child: Text(
                  text.resetPassword,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ResetPasswordPage()));
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: 200,
              margin: EdgeInsets.only(left: 20, top: 5),
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
                  text.logout,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                onPressed: () {
                  authClass.logout();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (builder) => StartPage()),
                      (route) => false);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String> photoUrlMethod () async{
    photoUrl = await FirebaseStorage.instance.ref('user`s photo/').child(uid + '.jpg').getDownloadURL();

    return photoUrl;
  }
}
