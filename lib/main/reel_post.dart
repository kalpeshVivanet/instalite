// ignore_for_file: must_be_immutable, library_private_types_in_public_api

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:lindi_sticker_widget/lindi_controller.dart';
import 'package:lindi_sticker_widget/lindi_sticker_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import '../navigation_home_screen.dart';
import '../utils/utils.dart';
// import 'package:image_editor/utils/utils.dart';

TextEditingController textEditingController = TextEditingController();

class ReelPost extends StatefulWidget {
  const ReelPost({super.key});

  @override
  _ReelPostState createState() => _ReelPostState();
}

class _ReelPostState extends State<ReelPost> {
  late File _imageFile;
  img.Image? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Editor'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Pick Image'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
        _image = img.decodeImage(_imageFile.readAsBytesSync())!;
      });
    }
    // ignore: use_build_context_synchronously
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EditPost(_imageFile, _image!);
    }));
  }
}

class EditPost extends StatefulWidget {
  File imageFile;
  img.Image image;

  EditPost(this.imageFile, this.image, {super.key});

  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  late LindiController controller;

  final FirebaseStorage _storage = FirebaseStorage.instance;
  ScreenshotController screenshotController = ScreenshotController();
  // List<Widget> widgets = [
  //   SizedBox(
  //       height: 100,
  //       width: 100,
  //       child: Image.network('https://picsum.photos/200/200')),
  //   const Icon(Icons.favorite, color: Colors.red, size: 50)
  // ];

  @override
  void initState() {
    controller = LindiController(
      showDone: false,
      showFlip: false,
      showLock: false,
      // showAllBorders: false,
      showAllBorders: false,
      showStack: false,
    );
    // for (var element in widgets) {
    //   controller.addWidget(element);
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Screenshot(
            controller: screenshotController,
            child: LindiStickerWidget(
              controller: controller,
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Image.file(
                  widget.imageFile,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            child: Padding(
                padding: const EdgeInsets.only(right: 20, top: 50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          controller.addWidget(
                            SizedBox(
                              width: 250,
                              child: TextFormField(
                                autofocus: true,
                                controller: textEditingController,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 25),
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  fillColor: Color.fromARGB(255, 241, 241, 241),
                                  hintStyle: TextStyle(fontSize: 13),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 12.0),
                                  filled: false,
                                  border:
                                      InputBorder.none, // Hide the bottom line
                                  enabledBorder: InputBorder
                                      .none, // Hide the border when not focused
                                  focusedBorder: InputBorder
                                      .none, // Hide the border when focused
                                ),
                              ),
                            ),
                          );
                        },
                        child: Text("Aa")),
                    ElevatedButton(
                        onPressed: () {
                          screenshotController
                              .capture()
                              .then((Uint8List? image) {
                            saveImage(image!);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Image saved to gallery.'),
                              ),
                            );
                          }).catchError((err) => print(err));
                        },
                        child: Text("Done"))
                  ],
                )),
          )
        ],
      ),
    );
  }

  saveImage(Uint8List bytes) async {
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '-')
        .replaceAll(':', '-');
    final name = "screenshot_$time";
    await requestPermission(Permission.storage);
    await ImageGallerySaver.saveImage(bytes, name: name);
  }
}
