import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:instalite/main/home.dart';
import 'package:instalite/main/reel_post.dart';

import 'data/database.dart';
import 'login/login_page.dart';
import 'main/add_post.dart';
import 'main/my_post.dart';
import 'model/user_detail.dart';

UserDetail userDetailData = const UserDetail(
    email: '',
    fullName: '',
    mobileNumber: '',
    userName: '',
    profilePicture: '');

class NavigationHomeScreen extends StatefulWidget {
  const NavigationHomeScreen({super.key});

  @override
  State<NavigationHomeScreen> createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    fetchEventDatabase();
    super.initState();
  }

  fetchEventDatabase() async {
    dynamic resultant = await DataBaseEvent().getUserData();
    if (resultant == null) {
      // ignore: avoid_print
      print("unable to retrive");
    } else {
      setState(() {
        userDetailData = resultant;
      });
    }
  }

  // Define your pages/screens here
  final List<Widget> _pages = [
    const Home(),
    Search(),
    AddPost(),
    ReelPost(),
    MyPost()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedFontSize: 0.0,
        unselectedFontSize: 0.0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        unselectedItemColor: const Color.fromARGB(255, 82, 82, 82),
        // selectedItemColor: Colors.black,

        type: BottomNavigationBarType.fixed,
        selectedIconTheme: const IconThemeData(
          color: Colors.black, // Set the color of the selected icon
          size: 30.0, // Set the size of the selected icon
        ),
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          const BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 30,
              ),
              label: "home"),
          const BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                size: 30,
              ),
              label: "search"),
          const BottomNavigationBarItem(
              icon: Icon(
                Icons.add_box_outlined,
                size: 30,
              ),
              label: "addpost"),
          const BottomNavigationBarItem(
              icon: Icon(
                Icons.movie_creation_outlined,
                size: 30,
              ),
              label: "reel"),
          BottomNavigationBarItem(
              icon: CircleAvatar(
                radius: 18.0,
                backgroundImage: NetworkImage(
                  userDetailData.profilePicture,
                ),
              ),
              label: "mypost"),
        ],
      ),
    );
  }
}

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Settings Page'),
    );
  }
}

// class AddPost extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: const Drawer(),
//       appBar: AppBar(),
//       body: const Center(
//         child: Text('Settings Page'),
//       ),
//     );
//   }
// }

// class Reel extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Text('Settings Page'),
//     );
//   }
// }
