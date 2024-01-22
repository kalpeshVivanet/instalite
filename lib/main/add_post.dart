// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

import '../navigation_home_screen.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
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
      return ImageEdit(_imageFile, _image!);
    }));
  }

//
}

class ImageEdit extends StatefulWidget {
  File file;
  final img.Image _image;
  ImageEdit(this.file, this._image, {super.key});

  @override
  State<ImageEdit> createState() => _ImageEditState();
}

class _ImageEditState extends State<ImageEdit> {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final TextEditingController _textEditingController = TextEditingController();

  bool isTextFieldVisible = false;
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Image.file(
            widget.file,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        isTextFieldVisible
                            ? setState(() {
                                isTextFieldVisible = false;
                              })
                            : setState(() {
                                isTextFieldVisible = true;
                              });
                      },
                      child: const Text("Aa")),
                  ElevatedButton(
                      onPressed: () {
                        _saveImage();
                      },
                      child: isPressed
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text("Done")),
                ],
              ),
            ),
            isTextFieldVisible
                ? Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: TextFormField(
                        autofocus: true,
                        controller: _textEditingController,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 25),
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          fillColor: Color.fromARGB(255, 241, 241, 241),
                          hintStyle: TextStyle(fontSize: 13),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 12.0),
                          filled: false,
                          border: InputBorder.none, // Hide the bottom line
                          enabledBorder: InputBorder
                              .none, // Hide the border when not focused
                          focusedBorder:
                              InputBorder.none, // Hide the border when focused
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        )),
      ]),
    );
  }

  Future<void> _saveImage() async {
    setState(() {
      isPressed = true;
    });

    // Add text to the image with a larger font size
    img.drawString(widget._image!, _textEditingController.text,
        x: 50, y: 50, font: img.arial48);

    // Convert the modified image to bytes
    Uint8List imageBytes = Uint8List.fromList(img.encodeJpg(widget._image!)!);

    // Upload the modified image to Firebase Storage
    String imageName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageReference = _storage.ref().child('images/$imageName.jpg');

    await storageReference.putData(imageBytes);

    // Get the download URL of the uploaded image
    String imageUrl = await storageReference.getDownloadURL();

    // Print the image URL
    print('Firebase Storage URL: $imageUrl');

    // Perform any additional actions, e.g., save URL to Firestore
    FirebaseFirestore.instance.collection("post").add({
      "post": imageUrl,
      "date": Timestamp.now(),
    });
    Get.to(() => const NavigationHomeScreen(), transition: Transition.zoom);
    setState(() {
      isPressed = false;
    });
  }
}
