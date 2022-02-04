import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:todo_flutter/service/data.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddOrderPage extends StatefulWidget {

  @override
  _AddOrderPageState createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage> {


  TextEditingController textController = new TextEditingController();
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String? email = FirebaseAuth.instance.currentUser!.email;




  List<String> myItems = ['Application', 'Support'];
  Object? initialItem = 'Application';

  List<String> azsN = [];
  List<String> azsA = ['Azs1', 'Azs2'];
  Object? initialAzs = '';


  List<String> cityN = [];
  List<String> cityA = ['City1', 'City2'];
  Object? initialCity = '';

  List<Data> dataList = [];

  var photoUrl = '';




  @override
  void initState() {
    super.initState();
    var refData = FirebaseDatabase.instance
        .reference()
        .child('Users')
        .child(uid)
        .child('u_azs');

    refData.once().then((DataSnapshot snapshot) {
      var azsName = snapshot.value;

      azsName.forEach((azsValue) {

        azsN.add(azsValue);

        if(azsN.isEmpty){
          initialAzs = azsA.first.toString();
        }else{
          initialAzs = azsN.first.toString();
        }
        setState(() {});
      });
    });

    var reg = FirebaseDatabase.instance.reference().child('regions');
    reg.once().then((DataSnapshot snapshot){
      var name = snapshot.value;
      name.forEach((key, value){
        cityN.add(key);

      });

      if(cityN.isEmpty){
        initialCity = cityA.first.toString();
      }else{
        initialCity = cityN.first.toString();
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var text = AppLocalizations.of(context);


    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          leading: Image.asset('assets/images/logo.png'),
          elevation: 0,
          title: Text(
            text!.application,
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
          child: azsN.isEmpty | cityN.isEmpty ? Center(child: CircularProgressIndicator(color: Colors.orange,),)
          :SingleChildScrollView(
            child: Container(
              height: size.height,
              width: size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        text.sendApplication,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 20),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        text.chooseCity + ':',
                        style: TextStyle(
                            fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold,),
                      ),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 5),
                    width: size.width -40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(width: 2, color: Colors.orange),
                    ),
                    child: DropdownButtonHideUnderline(

                      child: DropdownButton2(
                        dropdownPadding: EdgeInsets.only(top: 5),
                        buttonDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        dropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        dropdownElevation: 2,
                        buttonElevation: 0,
                        iconEnabledColor: Colors.orange,

                        onChanged: (e){
                          setState(() {
                            initialCity = e;
                          });
                        },
                        value: initialCity,

                        alignment: Alignment.topLeft,
                        // hint: Text('Azs'),
                        items: cityN.map((items) {

                          return DropdownMenuItem(child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(items),
                          ), value: items, alignment: Alignment.center,);
                        }).toList(),

                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 15),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(.0),
                        child: Text(
                          text.selectStation + ':',
                          style: TextStyle(
                              fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold,),
                        ),
                      ),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 5),
                    width: size.width -40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(width: 2, color: Colors.orange),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        dropdownPadding: EdgeInsets.only(top: 5),
                        buttonDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        dropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        dropdownElevation: 2,
                        buttonElevation: 0,
                        iconEnabledColor: Colors.orange,

                        onChanged: (e){
                          setState(() {
                            initialAzs = e;
                          });
                        },
                        value: initialAzs,
                        alignment: Alignment.topLeft,
                        // hint: Text('Azs'),
                        items: azsN.map((items) {
                          return DropdownMenuItem(child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(items),
                          ), value: items, alignment: Alignment.center,);
                        }).toList(),

                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 15),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        text.type + ':',
                        style: TextStyle(
                            fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold,),
                      ),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 5),
                    width: size.width - 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(width: 2, color: Colors.orange),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        dropdownPadding: EdgeInsets.only(top: 5),
                        buttonDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        dropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        dropdownElevation: 2,
                        buttonElevation: 0,
                        iconEnabledColor: Colors.orange,

                        
                        alignment: Alignment.topLeft,
                        value: initialItem,
                        items: myItems.map((String names) {
                          return DropdownMenuItem<String>(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(names),
                            ),
                            value: names,
                            alignment: Alignment.center,
                          );
                        }).toList(),
                        onChanged: (e) {
                          initialItem = e;
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 15),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        text.lableComment + ':',
                        style: TextStyle(
                            fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold,),
                      ),
                    ),
                  ),

                  textField(textController),

                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 20),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: ElevatedButton(
                        onPressed: () {
                          DateTime now = new DateTime.now();
                          final DateFormat formatter = DateFormat('dd.MM.yyyy HH:mm:ss');
                          final String formatted = formatter.format(now);
                          String normDate = formatted.toString().trim();
                          normDate = normDate.replaceFirst(' ', '--').replaceAll(':', '-').replaceAll('.', '-');

                          if(textController.text.isNotEmpty){
                            if(initialItem == text.application) {
                              var setData = FirebaseDatabase.instance.reference().child('Orders').child('application').child(uid).child(normDate);
                              setData.set({
                                'azs': initialAzs,
                                'city': initialCity,
                                'comment': textController.text.trim(),
                                'email': email,
                                'status': 'inProgress',
                                'time': formatted,
                                'ucomment2': '',
                                'vid': text.application.toLowerCase()
                              });

                              textController.clear();

                              final snackbar = SnackBar(content: Text(text.applicationIsSent));
                              ScaffoldMessenger.of(context).showSnackBar(snackbar);


                            }else{
                              var setData = FirebaseDatabase.instance.reference().child('Orders').child('support').child(uid).child(normDate);
                              setData.set({
                                'azs': initialAzs,
                                'city': initialCity,
                                'comment': textController.text.trim(),
                                'email': email,
                                'status': 'inProgress',
                                'time': formatted,
                                'ucomment2': '',
                                'vid': text.support.toLowerCase()
                              });
                              textController.clear();

                              final snackbar = SnackBar(content: Text(text.supportIsSent));
                              ScaffoldMessenger.of(context).showSnackBar(snackbar);
                            }
                          }else{
                            final snackbar = SnackBar(content: Text(text.writeComment));
                            ScaffoldMessenger.of(context).showSnackBar(snackbar);
                          }
                        },
                        child: Text(text.sendApplication),
                        style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          primary: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }

  Widget textField(TextEditingController controller) {

    return Container(
      height: 200,
      margin: EdgeInsets.only(right: 20, left: 20, top:5),
      child: TextFormField(
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        style: TextStyle(
          fontSize: 14,
          color: Colors.black,
        ),
        controller: controller,
        decoration: InputDecoration(
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
