import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:instalite/main/home/home.dart';
import 'package:instalite/main/reel_post.dart';
import 'package:shimmer/shimmer.dart';

import 'data/database.dart';
import 'login/login_page.dart';
import 'main/add_post.dart';
import 'main/my_post.dart';
import 'model/user_detail.dart';

bool showProfilePicture = false;
UserDetail userDetailData = const UserDetail(
    email: '',
    fullName: '',
    mobileNumber: '',
    userName: '',
    profilePicture: '');

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
        showProfilePicture = true;
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
              icon: Container(
                clipBehavior: Clip.antiAlias,
                width: 40.0,
                height: 40.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: showProfilePicture
                    ? CachedNetworkImage(
                        imageUrl: userDetailData.profilePicture,
                        placeholder: (context, url) => Container(
                          color: const Color.fromARGB(255, 239, 239, 239),
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/images/user.png',
                          color: Colors.white.withOpacity(0.2),
                        ),
                      )
                    : Container(
                        color: const Color.fromARGB(255, 239, 239, 239),
                      ),
                // Image.network(userDetailData.profilePicture),
              ),
              // CircleAvatar(
              //   radius: 18.0,
              //   // backgroundImage:
              //   //  NetworkImage(
              //   //   userDetailData.profilePicture,
              //   // ),
              //   child: Image.network(userDetailData.profilePicture),
              // ),
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
