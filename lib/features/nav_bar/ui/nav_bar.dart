import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:innogeeks_app/features/attendance/ui/attendance_page.dart';
import 'package:innogeeks_app/features/home/ui/home_page.dart';
import 'package:innogeeks_app/features/nav_bar/bloc/nav_bar_bloc.dart';
import 'package:innogeeks_app/features/profile/ui/profile_page.dart';
import 'package:innogeeks_app/features/registration/ui/registration_page.dart';

import '../../../constants/dimensions.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {

  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> bottomNavigationBarItems = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.house,color: Colors.black38,),
          label: 'Home',
          activeIcon: Icon(FontAwesomeIcons.house,color: Colors.blue,)
      ),
      const BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.userClock,color: Colors.black38,),
          label: 'Attendance',
          activeIcon: Icon(FontAwesomeIcons.userClock,color: Colors.blue,)
      ),
      const BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.house,color: Colors.black38,),
          label: 'Not Home',
          activeIcon: Icon(FontAwesomeIcons.house,color: Colors.blue,)
      ),
      const BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.user,color: Colors.black38,),
          label: 'Profile',
          activeIcon: Icon(FontAwesomeIcons.solidUser,color: Colors.blue,)
      ),
    ];
    List<Widget> navigationBarScreen = <Widget>[
      const HomePage(),
      const AttendancePage(),
      const RegistrationPage(),
      const ProfilePage()
    ];
    return BlocConsumer<NavBarBloc,NavBarState>(
        listener: (context,state){},
        builder: (context,state){
          return Scaffold(
            extendBody: true,
            backgroundColor: Colors.white,
            body: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: (index) {
                context.read<NavBarBloc>().add(TabChangeEvent(tabIndex: index));
              },
              children: navigationBarScreen,
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color:const Color(0xffFCEFC7),
                border: Border.all(width: 0.2),
                boxShadow: const [BoxShadow(color: Color(0xffFCEFC7),blurRadius: 1,offset: Offset.zero,spreadRadius: 0.5)],
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: getScreenHeight(context) * 0.02),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BottomNavigationBar(
                  backgroundColor: Colors.white,
                  items: bottomNavigationBarItems,
                  currentIndex: state.tabIndex,
                  selectedItemColor: Colors.blue,
                  // unselectedItemColor: Colors.white,
                  elevation: 10,
                  selectedFontSize: 12,
                  unselectedFontSize: 10,
                  type: BottomNavigationBarType.fixed,
                  // selectedItemColor: blackColor,
                  unselectedItemColor: Colors.black38,
                  onTap: (index) {
                    _pageController.jumpToPage(index);
                    _onItemTapped(index);
                  },
                ),
              ),
            ),
          );
        });
  }
}
