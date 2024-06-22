import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instalite/model/user_detail.dart';
import 'package:instalite/utilites/constant.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shimmer/shimmer.dart';

import '../data/database.dart';
import '../login/login_page.dart';
import '../main_screen.dart';

class MyPost extends StatefulWidget {
  MyPost({super.key});

  @override
  State<MyPost> createState() => _MyPostState();
}

class _MyPostState extends State<MyPost> {
  final auth = FirebaseAuth.instance;

  bool isStoryHighlightVisible = true;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                floating: true,
                snap: true,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                titleSpacing: 25,
                toolbarHeight: 60,
                elevation: 0.0,
                title: Text(
                  userDetailData.userName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      // Scaffold.of(context).openEndDrawer();
                    },
                    icon: const Icon(
                      Icons.add_box_outlined,
                      size: 30,
                    ),
                  ),
                  spacewt5,
                  IconButton(
                    onPressed: () {
                      showBottomSheet();
                    },
                    icon: const Icon(
                      Icons.menu,
                      size: 30,
                    ),
                  ),
                  spacewt5
                ],
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      spaceht10,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            clipBehavior: Clip.antiAlias,
                            width: 80.0,
                            height: 80.0,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: showProfilePicture
                                ? CachedNetworkImage(
                                    imageUrl: userDetailData.profilePicture,
                                    placeholder: (context, url) => Container(
                                      color: const Color.fromARGB(
                                          255, 239, 239, 239),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                      'assets/images/user.png',
                                      color: Colors.white.withOpacity(0.2),
                                    ),
                                  )
                                : Container(
                                    color: const Color.fromARGB(
                                        255, 239, 239, 239),
                                  ),
                          ),
                          // CircleAvatar(
                          //   radius: 40.0,
                          //   backgroundImage: NetworkImage(
                          //     userDetailData.profilePicture,
                          //   ),
                          // ),
                          const Column(
                            children: [
                              Text(
                                "0",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Text("Posts")
                            ],
                          ),
                          const Column(
                            children: [
                              Text(
                                "0",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Text("Followers")
                            ],
                          ),
                          const Column(
                            children: [
                              Text(
                                "0",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Text("Following")
                            ],
                          ),
                        ],
                      ),
                      spaceht8,
                      Row(
                        children: [
                          spacewt12,
                          Text(
                            userDetailData.fullName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      spaceht10,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.44,
                              height: 35,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            8.0), // Adjust the radius as needed
                                      ),
                                    ),
                                    elevation:
                                        MaterialStateProperty.all<double>(0),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            const Color.fromARGB(
                                                255, 239, 239, 239)),
                                  ),
                                  onPressed: () {},
                                  child: const Text(
                                    "Edit profile",
                                    style: TextStyle(color: Colors.black),
                                  )),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.44,
                              height: 35,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            8.0), // Adjust the radius as needed
                                      ),
                                    ),
                                    elevation:
                                        MaterialStateProperty.all<double>(0),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            const Color.fromARGB(
                                                255, 239, 239, 239)),
                                  ),
                                  onPressed: () {},
                                  child: const Text(
                                    "Share profile",
                                    style: TextStyle(color: Colors.black),
                                  )),
                            )
                          ],
                        ),
                      ),
                      spaceht10,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Story highlights",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 25,
                              child: IconButton(
                                  onPressed: () {
                                    isStoryHighlightVisible
                                        ? setState(() {
                                            isStoryHighlightVisible = false;
                                          })
                                        : setState(() {
                                            isStoryHighlightVisible = true;
                                          });
                                  },
                                  icon: isStoryHighlightVisible
                                      ? const Icon(
                                          FontAwesomeIcons.angleDown,
                                          size: 12,
                                        )
                                      : const Icon(
                                          FontAwesomeIcons.angleUp,
                                          size: 12,
                                        )),
                            )
                          ],
                        ),
                      ),
                      isStoryHighlightVisible
                          ? Wrap(children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.0),
                                child: Text(
                                    "Keep your favorite stories on your profile"),
                              ),
                              spaceht30,
                              Container(
                                height: 90,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 4,
                                  itemBuilder: (context, index) {
                                    if (index == 0) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 0,
                                            bottom: 0,
                                            right: 10,
                                            top: 0),
                                        child: Column(children: <Widget>[
                                          Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.black,
                                                // width: 2.0,
                                              ),
                                            ),
                                            child: const CircleAvatar(
                                              radius: 34.0,
                                              backgroundColor: Colors.white,
                                              child: Icon(
                                                Icons.add,
                                                size: 40,
                                                color: Colors.black,
                                              ),
                                              // backgroundImage: NetworkImage(
                                              //     "https://icon-library.com/images/default-user-icon/default-user-icon-8.jpg"),
                                            ),
                                          ),
                                          const SizedBox(height: 4.0),
                                          const Text(
                                            'New',
                                            style: TextStyle(fontSize: 12.0),
                                          )
                                        ]),
                                      );
                                    } else {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 0,
                                            bottom: 0,
                                            right: 10,
                                            top: 0),
                                        child: Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {},
                                              child: const Padding(
                                                padding: EdgeInsets.all(2.0),
                                                child: CircleAvatar(
                                                  radius: 35.0,
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 239, 239, 239),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ])
                          : const SizedBox(),
                      spaceht10,
                    ],
                  ),
                ),
              ),
              SliverPersistentHeader(
                delegate: _MyTabBarDelegate(
                  const TabBar(
                    indicatorColor: Colors.black,
                    unselectedLabelColor:
                        Colors.grey, // Set unselected tab color here
                    labelColor: Colors.black,
                    tabs: [
                      Tab(
                        icon: Icon(Icons.grid_on),
                      ),
                      Tab(
                        icon: Icon(FontAwesomeIcons.userTag),
                      ),
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: Container(
            color: Colors.white,
            child: TabBarView(
              children: [
                // Content of Tab 1
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                      child: const CircleAvatar(
                        radius: 25.0,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.camera_alt_outlined,
                          size: 35,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    spaceht5,
                    const Text(
                      'No Posts Yet',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                // Content of Tab 2
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                      child: const CircleAvatar(
                        radius: 25.0,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.camera_front_outlined,
                          size: 35,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    spaceht5,
                    const Text(
                      'No Posts Yet',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: true, // Enable outside touch to close
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      backgroundColor: Colors.white,
      builder: (context) {
        return Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            spaceht10,
            Container(
              clipBehavior: Clip.antiAlias,
              height: 4,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 96, 96, 96),
                  borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(100), left: Radius.circular(100))),
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.44),
            ),
            spaceht30,
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Log out"),
              onTap: () {
                auth.signOut();
                // Navigator.push(context, MaterialPageRoute(builder: (context) {
                //   return OTPScreen();
                // }));
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const LoginPage();
                }));
              },
            ),
          ],
        );
      },
    );
  }
}

class _MyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _MyTabBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: Colors.white, child: _tabBar);
  }

  @override
  bool shouldRebuild(_MyTabBarDelegate oldDelegate) {
    return false;
  }
}
