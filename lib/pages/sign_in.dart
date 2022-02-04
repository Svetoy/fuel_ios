import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_flutter/pages/bottom_nav.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:todo_flutter/pages/reset_password_page.dart';
import 'package:todo_flutter/service/firebase_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignInPage extends StatefulWidget
{
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  AuthClass authClass = AuthClass();

  @override
  Widget build(BuildContext context) {
    var text = AppLocalizations.of(context);

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset('assets/icons/back.svg'),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 30),
          height: size.height,
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset('assets/images/reg_in_oil.png'),
              Text(
                'Automatic',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              Text(
                'CONTROL',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              textItem(text!.email, _emailController, false, TextInputType.text),
              SizedBox(
                height: 20,
              ),
              textItem(
                  text.password, _passwordController, true, TextInputType.text),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  if(_emailController.text.isNotEmpty | _passwordController.text.isNotEmpty){
                    try {
                      firebase_auth.UserCredential userCredential =
                      await firebaseAuth.signInWithEmailAndPassword(
                        email: _emailController.value.text.trim(),
                        password: _passwordController.value.text.trim(),
                      );
                      String uid = FirebaseAuth.instance.currentUser!.uid;
                      
                      DataSnapshot snapshot = await FirebaseDatabase.instance.reference().child('Users').child(uid).child('activated').once();
                      print(snapshot.value.toString());

                      if(snapshot.value.toString() == 'true'){
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (builder) => BottomNavBar()),
                                (route) => false);
                      }else{
                        final snackbar = SnackBar(content: Text('Your account not active'));
                        ScaffoldMessenger.of(context).showSnackBar(snackbar);
                      }


                    } catch (e) {
                      final snackbar = SnackBar(content: Text(e.toString()));
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    }
                  }else{
                    final snackbar = SnackBar(content: Text(text.fill));
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  }
                },
                child: Text(text.signIn),
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(size.width - 40, 55),
                  textStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  primary: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: size.width,
                child: Center(
                  child: Card(
                    elevation: 0,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResetPasswordPage()));
                      },
                      child: Text(text.forgotPassword),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textItem(String labelText, TextEditingController controller,
      bool obscureText, TextInputType textType) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width - 40,
      height: 60,
      child: TextFormField(
        keyboardType: textType,
        obscureText: obscureText,
        style: TextStyle(
          fontSize: 14,
          color: Colors.black,
        ),
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
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
    );
  }
}
