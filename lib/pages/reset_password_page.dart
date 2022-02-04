import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_flutter/pages/sign_in.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  TextEditingController _resetEmail = new TextEditingController();
  var auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    var text = AppLocalizations.of(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          text!.resetPassword,
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
          Image.asset(
            'assets/images/userPng.png',
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, top: 30),
                  child: Text(
                    text.resetPassword,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              SizedBox(
                height: 15,
              ),

              Container(
                width: size.width - 40,
                height: 60,
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  controller: _resetEmail,
                  decoration: InputDecoration(
                    labelText: text.email,
                    labelStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.orange,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        width: 1.5,
                        color: Colors.orange,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        width: 1,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 10,
              ),

              ElevatedButton(
                onPressed: () {
                  auth.sendPasswordResetEmail(email: _resetEmail.text.trim());
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (builder) => SignInPage()),
                      (route) => false);
                },
                child: Text(text.resetPassword),
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(size.width - 40, 40),
                  textStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  primary: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
