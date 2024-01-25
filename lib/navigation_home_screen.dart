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
// import 'package:flutter/material.dart';

// class NavigationHomeScreen extends StatefulWidget {
//   @override
//   _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
// }

// class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
//   double xPosition = 50.0;
//   double yPosition = 50.0;
//   bool isTextFieldVisible = false;
//   final TextEditingController _textEditingController = TextEditingController();
//   final GlobalKey _textKey = GlobalKey();
//   final GlobalKey _deleteIconKey = GlobalKey();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Movable Text'),
//       ),
//       body: Stack(
//         children: [
// isTextFieldVisible
//     ?
//           Positioned(
//             left: xPosition,
//             top: yPosition,
//             child: GestureDetector(
//               onPanUpdate: (details) {
//                 setState(() {
//                   xPosition += details.delta.dx;
//                   yPosition += details.delta.dy;

//                   // Check if the text is over the delete icon
//                   if (_isOverDeleteIcon()) {
//                     // You can add additional logic here
//                     // For example, show some indication that the text is over the delete icon
//                   }
//                 });
//               },
//               onPanEnd: (details) {
//                 // Check if the text is over the delete icon when the dragging ends
//                 if (_isOverDeleteIcon()) {
//                   // Delete the text
//                   setState(() {
//                     isTextFieldVisible = false;
//                     _textEditingController.clear();
//                   });
//                 }
//               },
//               child: Align(
//                 alignment: Alignment.center,
//                 child: Container(
//                   key: _textKey,
//                   width: 200,
//                   child: TextFormField(
//                     autofocus: true,
//                     controller: _textEditingController,
//                     style: const TextStyle(color: Colors.black, fontSize: 25),
//                     textAlign: TextAlign.center,
//                     decoration: const InputDecoration(
//                       fillColor: Color.fromARGB(255, 241, 241, 241),
//                       hintStyle: TextStyle(fontSize: 13),
//                       contentPadding:
//                           EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
//                       filled: false,
//                       border: InputBorder.none,
//                       enabledBorder: InputBorder.none,
//                       focusedBorder: InputBorder.none,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
          // : SizedBox(),
//           Positioned(
//             bottom: 0,
//             left: MediaQuery.of(context).size.width / 2 - 25,
//             child: GestureDetector(
//               key: _deleteIconKey,
//               child: Icon(Icons.delete, size: 50.0, color: Colors.red),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // setState(() {
//           //   isTextFieldVisible = true;
//           // });
//         },
//         child: Icon(isTextFieldVisible ? Icons.close : Icons.text_fields),
//       ),
//     );
//   }

//   bool _isOverDeleteIcon() {
//     // Get the global positions of the text and delete icon
//     RenderBox textRenderBox =
//         _textKey.currentContext!.findRenderObject() as RenderBox;
//     RenderBox deleteIconRenderBox =
//         _deleteIconKey.currentContext?.findRenderObject() as RenderBox;

//     // Check if the text is over the delete icon
//     return textRenderBox.localToGlobal(Offset.zero).dx <
//             deleteIconRenderBox.localToGlobal(Offset.zero).dx + 100.0 &&
//         textRenderBox.localToGlobal(Offset.zero).dx + 200.0 >
//             deleteIconRenderBox.localToGlobal(Offset.zero).dx &&
//         textRenderBox.localToGlobal(Offset.zero).dy <
//             deleteIconRenderBox.localToGlobal(Offset.zero).dy + 100.0 &&
//         textRenderBox.localToGlobal(Offset.zero).dy + 50.0 >
//             deleteIconRenderBox.localToGlobal(Offset.zero).dy;
//   }
// }
