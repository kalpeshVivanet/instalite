// ignore_for_file: use_build_context_synchronously, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:instalite/main_screen.dart';
import '../utilites/constant.dart';
import 'login_page.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isSignUpButtonClick = false;
  bool isUsernameTaken = false;
  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _mobileNumberController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  Future<bool> isUsernameAlreadyTaken(String username) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('UserDetail')
          .where('UserName', isEqualTo: username)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkUsername() async {
    String username = _userNameController.text;
    if (username.isNotEmpty) {
      return isUsernameTaken = await isUsernameAlreadyTaken(username);
    } else {
      return isUsernameTaken = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Instagram",
                    style: TextStyle(
                        fontFamily: 'Billabong',
                        fontWeight: FontWeight.bold,
                        fontSize: 45),
                  ),
                  spaceht30,
                  const Text(
                    "Sign up to see photos and videos from your friends.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color.fromARGB(255, 114, 114, 114)),
                  ),
                  spaceht30,
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: 45,
                    child: ElevatedButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // Adjust the radius as needed
                        ),
                      ),
                      onPressed: () async {
                        // Trigger Facebook login
                        final result = await FacebookAuth.instance.login();

                        // Check if the login was successful
                        if (result.status == LoginStatus.success) {
                          // Authenticate with Firebase using the Facebook access token
                          final AuthCredential credential =
                              FacebookAuthProvider.credential(
                                  result.accessToken!.token);
                          await FirebaseAuth.instance
                              .signInWithCredential(credential);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return MainScreen();
                          }));
                          print('User signed in with Facebook');
                        } else {
                          print('Facebook login failed');
                        }
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.facebook,
                          ),
                          Text(" Log in with Facebook")
                        ],
                      ),
                    ),
                  ),
                  spaceht20,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: const Divider(
                          indent: 5,
                          endIndent: 10,
                          thickness: 1.0,
                          color: Color.fromARGB(255, 198, 198, 198),
                        ),
                      ),
                      const Text("OR"),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: const Divider(
                          indent: 10,
                          endIndent: 5,
                          // height: 20,
                          thickness: 1.0,
                          color: Color.fromARGB(255, 198, 198, 198),
                        ),
                      ),
                    ],
                  ),
                  // spacewt5,
                  spaceht20,
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: TextFormField(
                      controller: _emailController,
                      style: const TextStyle(fontSize: 13.0),
                      decoration: const InputDecoration(
                        hintText: "Email address",
                        hintStyle: TextStyle(fontSize: 13),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0),
                        filled: true,
                        fillColor: Color.fromARGB(255, 241, 241, 241),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter email address';
                        } else if (!RegExp(
                                r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
                            .hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                  ),

                  spaceht20,
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: TextFormField(
                      controller: _mobileNumberController,
                      style: const TextStyle(fontSize: 13.0),
                      decoration: const InputDecoration(
                        hintText: "Mobile number",
                        hintStyle: TextStyle(fontSize: 13),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0),
                        filled: true,
                        fillColor: Color.fromARGB(255, 241, 241, 241),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter mobile number';
                        } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                          return 'Please enter a valid 10-digit mobile number';
                        }
                        return null;
                      },
                    ),
                  ),
                  spaceht20,

                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: TextFormField(
                      controller: _fullNameController,
                      style: const TextStyle(fontSize: 13.0),
                      decoration: const InputDecoration(
                        hintText: "Full name",
                        hintStyle: TextStyle(fontSize: 13),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0),
                        filled: true,
                        fillColor: Color.fromARGB(255, 241, 241, 241),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter full name';
                        }
                        return null;
                      },
                    ),
                  ),
                  spaceht20,
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: FutureBuilder<bool>(
                      future: checkUsername(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          // Handle errors
                          return Text('Error: ${snapshot.error}');
                        } else {
                          bool isTaken = snapshot.data ?? false;

                          return TextFormField(
                            controller: _userNameController,
                            style: const TextStyle(fontSize: 13.0),
                            decoration: InputDecoration(
                              hintText: "Username",
                              hintStyle: const TextStyle(fontSize: 13),
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 12.0),
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 241, 241, 241),
                              errorText: isTaken
                                  ? 'This username is already taken. Please choose another one.'
                                  : null,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a username';
                              }

                              return null;
                            },
                          );
                        }
                      },
                    ),
                  ),
                  spaceht20,
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      style: const TextStyle(fontSize: 13.0),
                      decoration: InputDecoration(
                        hintText: "Password",
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        suffixIconColor:
                            _isPasswordVisible ? Colors.blue : Colors.grey,
                        hintStyle: const TextStyle(fontSize: 13),
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 241, 241, 241),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        } else if (value.length < 8) {
                          return 'Password must be at least 8 characters long';
                        } else {
                          // Check for at least one uppercase letter
                          if (!RegExp(r'^(?=.*[A-Z])').hasMatch(value)) {
                            return 'Password must contain at least one uppercase letter';
                          }
                          // Check for at least one symbol
                          if (!RegExp(r'^(?=.*[@$!%*?&])').hasMatch(value)) {
                            return 'Password must contain at least one symbol';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                  spaceht20,

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 22),
                    child: Text(
                      "People who use our service may have uploaded your contact information to Instagram. Learn more",
                      style: TextStyle(fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  spaceht20,
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 22),
                    child: Text(
                      "By signing up, you agree to our Terms, Privacy Policy and Cookies Policy.",
                      style: TextStyle(fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  spaceht20,
                  ElevatedButton(
                      style: TextButton.styleFrom(
                        minimumSize:
                            Size(MediaQuery.of(context).size.width * 0.85, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          try {
                            setState(() {
                              _isSignUpButtonClick = true;
                            });
                            bool check = await checkUsername();

                            if (!check) {
                              await createAccount(context);
                            }
                            setState(() {
                              _isSignUpButtonClick = false;
                            });
                            // }
                          } on FirebaseAuthException catch (e) {
                            setState(() {
                              _isSignUpButtonClick = false;
                            });
                            if (e.code == 'weak-password') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.red,
                                  content:
                                      Text("Password Provided is too Weak"),
                                ),
                              );
                            } else if (e.code == 'email-already-in-use') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text("Account Already exists"),
                                ),
                              );
                            }
                          }
                        }
                      },
                      child: _isSignUpButtonClick
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text("Sign up")),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Color.fromARGB(255, 198, 198, 198),
                width: 1.5,
              ),
            ),
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Have an account?",
                  style: TextStyle(fontSize: 13.0),
                ),
                TextButton(
                    onPressed: () {
                      Get.to(() => LoginPage(), transition: Transition.zoom);
                      // Navigator.push(context, MaterialPageRoute(builder: (context) {
                      //   return const LoginPage();
                      // }));
                    },
                    child: const Text(
                      "Log in.",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13.0),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> createAccount(BuildContext context) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );
    final auth = FirebaseAuth.instance;
    User user = auth.currentUser!;
    user.sendEmailVerification();

    String? uid = userCredential.user?.uid;
    await FirebaseFirestore.instance.collection("UserDetail").doc(uid).set({
      'Email': _emailController.text.toLowerCase(),
      'Mobile': _mobileNumberController.text.toLowerCase(),
      'UserName': _userNameController.text.toLowerCase(),
      'FullName': _fullNameController.text.toLowerCase(),
      'ProfilePicture':
          "https://www.das-macht-schule.net/wp-content/uploads/2018/04/dummy-profile-pic.png"
    });
    setState(() {
      _isSignUpButtonClick = false;
    });
    auth.signOut();
    Get.to(() => LoginPage(), transition: Transition.zoom);

    String email = _emailController.text.toLowerCase();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(
            "Verification link sent to $email.. Please verify your Email....!!!"),
      ),
    );

    _userNameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _mobileNumberController.clear();
    _fullNameController.clear();
  }
}
// ignore_for_file: use_build_context_synchronously, avoid_function_literals_in_foreach_calls

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// import 'package:instalite/main.dart';
// import 'package:instalite/navigation_home_screen.dart';
// import '../main/home.dart';
// import '../utilites/constant.dart';
// import 'login_page.dart';

// class SignUp extends StatefulWidget {
//   const SignUp({super.key});

//   @override
//   State<SignUp> createState() => _SignUpState();
// }

// class _SignUpState extends State<SignUp> {
//   final _formKey = GlobalKey<FormState>();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _mobileNumberController = TextEditingController();
//   final TextEditingController _userNameController = TextEditingController();
//   final TextEditingController _fullNameController = TextEditingController();
//   bool _isPasswordVisible = false;
//   bool _isSignUpButtonClick = false;
//   bool isUsernameTaken = false;
//   @override
//   void dispose() {
//     _userNameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _mobileNumberController.dispose();
//     _fullNameController.dispose();
//     super.dispose();
//   }

//   Future<bool> isUsernameAlreadyTaken(String username) async {
//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('UserDetail')
//           .where('UserName', isEqualTo: username)
//           .get();

//       return querySnapshot.docs.isNotEmpty;
//     } catch (e) {
//       return false;
//     }
//   }

//   Future<bool> checkUsername() async {
//     String username = _userNameController.text;
//     if (username.isNotEmpty) {
//       return isUsernameTaken = await isUsernameAlreadyTaken(username);
//     } else {
//       return isUsernameTaken = false;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Form(
//               autovalidateMode: AutovalidateMode.onUserInteraction,
//               key: _formKey,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text(
//                     "Instagram",
//                     style: TextStyle(
//                         fontFamily: 'Billabong',
//                         fontWeight: FontWeight.bold,
//                         fontSize: 45),
//                   ),
//                   spaceht30,
//                   const Text(
//                     "Sign up to see photos and videos from your friends.",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18,
//                         color: Color.fromARGB(255, 114, 114, 114)),
//                   ),
//                   spaceht30,
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width * 0.85,
//                     height: 45,
//                     child: ElevatedButton(
//                       style: TextButton.styleFrom(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(
//                               10.0), // Adjust the radius as needed
//                         ),
//                       ),
//                       onPressed: () async {
//                         // Trigger Facebook login
//                         final result = await FacebookAuth.instance.login();

//                         // Check if the login was successful
//                         if (result.status == LoginStatus.success) {
//                           // Authenticate with Firebase using the Facebook access token
//                           final AuthCredential credential =
//                               FacebookAuthProvider.credential(
//                                   result.accessToken!.token);
//                           await FirebaseAuth.instance
//                               .signInWithCredential(credential);
//                           Navigator.push(context,
//                               MaterialPageRoute(builder: (context) {
//                             return MainScreen();
//                           }));
//                           print('User signed in with Facebook');
//                         } else {
//                           print('Facebook login failed');
//                         }
//                       },
//                       child: const Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             FontAwesomeIcons.facebook,
//                           ),
//                           Text(" Log in with Facebook")
//                         ],
//                       ),
//                     ),
//                   ),
//                   spaceht20,
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.4,
//                         child: const Divider(
//                           indent: 5,
//                           endIndent: 10,
//                           thickness: 1.0,
//                           color: Color.fromARGB(255, 198, 198, 198),
//                         ),
//                       ),
//                       const Text("OR"),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.4,
//                         child: const Divider(
//                           indent: 10,
//                           endIndent: 5,
//                           // height: 20,
//                           thickness: 1.0,
//                           color: Color.fromARGB(255, 198, 198, 198),
//                         ),
//                       ),
//                     ],
//                   ),
//                   // spacewt5,
//                   spaceht20,
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width * 0.85,
//                     child: TextFormField(
//                       controller: _emailController,
//                       style: const TextStyle(fontSize: 13.0),
//                       decoration: const InputDecoration(
//                         hintText: "Email address",
//                         hintStyle: TextStyle(fontSize: 13),
//                         border: OutlineInputBorder(),
//                         contentPadding: EdgeInsets.symmetric(
//                             vertical: 8.0, horizontal: 12.0),
//                         filled: true,
//                         fillColor: Color.fromARGB(255, 241, 241, 241),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter email address';
//                         } else if (!RegExp(
//                                 r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
//                             .hasMatch(value)) {
//                           return 'Please enter a valid email address';
//                         }
//                         return null;
//                       },
//                     ),
//                   ),

//                   spaceht20,
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width * 0.85,
//                     child: TextFormField(
//                       controller: _mobileNumberController,
//                       style: const TextStyle(fontSize: 13.0),
//                       decoration: const InputDecoration(
//                         hintText: "Mobile number",
//                         hintStyle: TextStyle(fontSize: 13),
//                         border: OutlineInputBorder(),
//                         contentPadding: EdgeInsets.symmetric(
//                             vertical: 8.0, horizontal: 12.0),
//                         filled: true,
//                         fillColor: Color.fromARGB(255, 241, 241, 241),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter mobile number';
//                         } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
//                           return 'Please enter a valid 10-digit mobile number';
//                         }
//                         return null;
//                       },
//                     ),
//                   ),
//                   spaceht20,

//                   SizedBox(
//                     width: MediaQuery.of(context).size.width * 0.85,
//                     child: TextFormField(
//                       controller: _fullNameController,
//                       style: const TextStyle(fontSize: 13.0),
//                       decoration: const InputDecoration(
//                         hintText: "Full name",
//                         hintStyle: TextStyle(fontSize: 13),
//                         border: OutlineInputBorder(),
//                         contentPadding: EdgeInsets.symmetric(
//                             vertical: 8.0, horizontal: 12.0),
//                         filled: true,
//                         fillColor: Color.fromARGB(255, 241, 241, 241),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter full name';
//                         }
//                         return null;
//                       },
//                     ),
//                   ),
//                   spaceht20,
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width * 0.85,
//                     child: FutureBuilder<bool>(
//                       future: checkUsername(),
//                       builder: (context, snapshot) {
//                         if (snapshot.hasError) {
//                           // Handle errors
//                           return Text('Error: ${snapshot.error}');
//                         } else {
//                           bool isTaken = snapshot.data ?? false;

//                           return TextFormField(
//                             controller: _userNameController,
//                             style: const TextStyle(fontSize: 13.0),
//                             decoration: InputDecoration(
//                               hintText: "Username",
//                               hintStyle: const TextStyle(fontSize: 13),
//                               border: const OutlineInputBorder(),
//                               contentPadding: const EdgeInsets.symmetric(
//                                   vertical: 8.0, horizontal: 12.0),
//                               filled: true,
//                               fillColor:
//                                   const Color.fromARGB(255, 241, 241, 241),
//                               errorText: isTaken
//                                   ? 'This username is already taken. Please choose another one.'
//                                   : null,
//                             ),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter a username';
//                               }

//                               return null;
//                             },
//                           );
//                         }
//                       },
//                     ),
//                   ),
//                   // spaceht20,
//                   // SizedBox(
//                   //   width: MediaQuery.of(context).size.width * 0.85,
//                   //   child: TextFormField(
//                   //     controller: _passwordController,
//                   //     obscureText: !_isPasswordVisible,
//                   //     style: const TextStyle(fontSize: 13.0),
//                   //     decoration: InputDecoration(
//                   //       hintText: "Password",
//                   //       suffixIcon: IconButton(
//                   //         icon: Icon(
//                   //           _isPasswordVisible
//                   //               ? Icons.visibility
//                   //               : Icons.visibility_off,
//                   //         ),
//                   //         onPressed: () {
//                   //           setState(() {
//                   //             _isPasswordVisible = !_isPasswordVisible;
//                   //           });
//                   //         },
//                   //       ),
//                   //       suffixIconColor:
//                   //           _isPasswordVisible ? Colors.blue : Colors.grey,
//                   //       hintStyle: const TextStyle(fontSize: 13),
//                   //       border: const OutlineInputBorder(),
//                   //       contentPadding: const EdgeInsets.symmetric(
//                   //           vertical: 8.0, horizontal: 12.0),
//                   //       filled: true,
//                   //       fillColor: const Color.fromARGB(255, 241, 241, 241),
//                   //     ),
//                   //     validator: (value) {
//                   //       if (value == null || value.isEmpty) {
//                   //         return 'Please enter password';
//                   //       } else if (value.length < 8) {
//                   //         return 'Password must be at least 8 characters long';
//                   //       } else {
//                   //         // Check for at least one uppercase letter
//                   //         if (!RegExp(r'^(?=.*[A-Z])').hasMatch(value)) {
//                   //           return 'Password must contain at least one uppercase letter';
//                   //         }
//                   //         // Check for at least one symbol
//                   //         if (!RegExp(r'^(?=.*[@$!%*?&])').hasMatch(value)) {
//                   //           return 'Password must contain at least one symbol';
//                   //         }
//                   //       }
//                   //       return null;
//                   //     },
//                   //   ),
//                   // ),
//                   spaceht20,

//                   const Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 22),
//                     child: Text(
//                       "People who use our service may have uploaded your contact information to Instagram. Learn more",
//                       style: TextStyle(fontSize: 13),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                   spaceht20,
//                   const Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 22),
//                     child: Text(
//                       "By signing up, you agree to our Terms, Privacy Policy and Cookies Policy.",
//                       style: TextStyle(fontSize: 13),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                   spaceht20,
//                   ElevatedButton(
//                       style: TextButton.styleFrom(
//                         minimumSize:
//                             Size(MediaQuery.of(context).size.width * 0.85, 45),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                       ),
//                       onPressed: () async {
//                         if (_formKey.currentState?.validate() ?? false) {
//                           try {
//                             setState(() {
//                               _isSignUpButtonClick = true;
//                             });
//                             bool check = await checkUsername();

//                             if (!check) {
//                               await createAccount(context);
//                             }
//                             setState(() {
//                               _isSignUpButtonClick = false;
//                             });
//                             // }
//                           } on FirebaseAuthException catch (e) {
//                             setState(() {
//                               _isSignUpButtonClick = false;
//                             });
//                             if (e.code == 'weak-password') {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                   backgroundColor: Colors.red,
//                                   content:
//                                       Text("Password Provided is too Weak"),
//                                 ),
//                               );
//                             } else if (e.code == 'email-already-in-use') {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                   backgroundColor: Colors.red,
//                                   content: Text("Account Already exists"),
//                                 ),
//                               );
//                             }
//                           }
//                         }
//                       },
//                       child: _isSignUpButtonClick
//                           ? const CircularProgressIndicator(
//                               color: Colors.white,
//                             )
//                           : const Text("Sign up")),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         bottomNavigationBar: Container(
//           decoration: const BoxDecoration(
//             border: Border(
//               top: BorderSide(
//                 color: Color.fromARGB(255, 198, 198, 198),
//                 width: 1.5,
//               ),
//             ),
//           ),
//           child: Padding(
//             padding:
//                 const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 18),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text(
//                   "Have an account?",
//                   style: TextStyle(fontSize: 13.0),
//                 ),
//                 TextButton(
//                     onPressed: () {
//                       Get.to(() => OTPScreen(), transition: Transition.zoom);
//                       // Navigator.push(context, MaterialPageRoute(builder: (context) {
//                       //   return const LoginPage();
//                       // }));
//                     },
//                     child: const Text(
//                       "Log in.",
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold, fontSize: 13.0),
//                     ))
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> createAccount(BuildContext context) async {
//     UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//       email: _emailController.text,
//       password: "Kalpesh@123",
//     );
// final auth = FirebaseAuth.instance;
//     User user = auth.currentUser!;
//     user.sendEmailVerification();
//     String? uid = userCredential.user?.uid;
//     await FirebaseFirestore.instance.collection("UserDetail").doc(uid).set({
//       'Email': _emailController.text.toLowerCase(),
//       'Mobile': _mobileNumberController.text.toLowerCase(),
//       'UserName': _userNameController.text.toLowerCase(),
//       'FullName': _fullNameController.text.toLowerCase(),
//     });
//     setState(() {
//       _isSignUpButtonClick = false;
//     });

//  auth.signOut();
//     Get.to(() => OTPScreen(), transition: Transition.zoom);
//     // Navigator.push(context, MaterialPageRoute(builder: (context) {
//     //   return const LoginPage();
//     // }));
//     String email = _emailController.text.toLowerCase();
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         backgroundColor: Colors.green,
//         content: Text(
//             "Verification link sent to $email.. Please verify your Email....!!!"),
//       ),
//     );


//     _userNameController.clear();
//     _emailController.clear();
//     _passwordController.clear();
//     _mobileNumberController.clear();
//     _fullNameController.clear();
//   }
// }
