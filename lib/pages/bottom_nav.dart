import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:todo_flutter/pages/add_order.dart';
import 'package:todo_flutter/pages/home_page.dart';
import 'package:todo_flutter/pages/profile_page.dart';
import 'package:todo_flutter/pages/settings_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'history_page.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int selectedIndex = 2;
  Widget _homePage = HomePage();
  Widget _profilePage = ProfilePage();
  Widget _historyPage = HistoryPage();
  Widget _addOrderPage = AddOrderPage();
  Widget _settingsPage = SettingsPage();



  @override
  Widget build(BuildContext context) {
    var text = AppLocalizations.of(context);

    return Scaffold(
      body:  this.getBody(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: this.selectedIndex,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/fuelTrace.svg', height: 25, width: 25, color: selectedIndex == 0 ?Colors.orange :Color(0xffd6dbde),),
            title: Text(text!.stations, style: TextStyle(color: selectedIndex == 0 ?Colors.orange :Color(0xffd6dbde),),),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/trace.svg', height: 25, width: 25, color: selectedIndex == 1 ?Colors.orange :Color(0xffd6dbde),),

            title: Text(text.pipelines, style: TextStyle(color: selectedIndex == 1 ?Colors.orange :Color(0xffd6dbde),),),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/userIcon.svg', height: 25, width: 25, color: selectedIndex == 2 ?Colors.orange :Color(0xffd6dbde),),
            title: Text(text.profile, style: TextStyle(color: selectedIndex == 2 ?Colors.orange :Color(0xffd6dbde),),),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/addOrderIcon.svg', height: 25, width: 25, color: selectedIndex == 3 ?Colors.orange :Color(0xffd6dbde),),
            title: Text(text.application, style: TextStyle(color: selectedIndex == 3 ?Colors.orange :Color(0xffd6dbde),),),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/historyIcon.svg', height: 25, width: 25, color: selectedIndex == 4 ?Colors.orange :Color(0xffd6dbde),),
            title: Text(text.history, style: TextStyle(color: selectedIndex == 4 ?Colors.orange :Color(0xffd6dbde),),),
          )
        ],
        onTap: (int index) {
          this.onTapHandler(index);
        },
      ),
    );
  }
  Widget getBody( )  {
    if(this.selectedIndex == 0) {
      return this._homePage;
    } else if(this.selectedIndex==1) {
      return this._settingsPage;
    }
    else if(this.selectedIndex==2) {
      return this._profilePage;
    }
    else if(this.selectedIndex==3) {
      return this._addOrderPage;
    }else {
      return this._historyPage;
    }
  }

  void onTapHandler(int index)  {
    this.setState(() {
      this.selectedIndex = index;
    });
  }
}
