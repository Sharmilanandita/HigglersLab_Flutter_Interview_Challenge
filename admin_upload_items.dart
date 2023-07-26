import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_app/api_connection/api_connection.dart';
import '../app/movie_list_screen.dart';


class AdminUploadItemsScreen extends StatefulWidget {
  const AdminUploadItemsScreen({Key? key}) : super(key: key);

  @override
  State<AdminUploadItemsScreen> createState() => _AdminUploadItemsScreenState();
}

class _AdminUploadItemsScreenState extends State<AdminUploadItemsScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? pickedImageXFile;
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var releaseYearController = TextEditingController();
  var ratingController = TextEditingController();
  var genreController = TextEditingController();
  var directorController = TextEditingController();
  var informationController = TextEditingController();
  String movieImageLink = "";


  captureImageWithPhoneCamera() async
  {
    pickedImageXFile = await _picker.pickImage(source: ImageSource.camera);
    Get.back();
    setState(() => pickedImageXFile);
  }

  pickImageFromPhoneGallery() async
  {
    pickedImageXFile = await _picker.pickImage(source: ImageSource.gallery);
    Get.back();
    setState(() => pickedImageXFile);
  }

  showDialogBoxForPickingAndCapturing() {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            backgroundColor: Colors.black,
            title: const Text(
              'Item Image',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  captureImageWithPhoneCamera();
                },
                child: const Text(
                  'Capture With Phone Camera',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  pickImageFromPhoneGallery();
                },
                child: const Text(
                  'Pick Image From Phone Gallery',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Get.back();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          );
        }
    );
  }


  uploadItemImage() async
  {
    var requestImgurApi = http.MultipartRequest(
        "POST",
        Uri.parse("https://api.imgur.com/3/image")
    );
    String imageName = DateTime
        .now()
        .microsecondsSinceEpoch
        .toString();
    requestImgurApi.fields['title'] = imageName;
    requestImgurApi.headers['Authorization'] = "Client-ID " + "e5a65d13363b4e2";

    var imageFile = await http.MultipartFile.fromPath(
      'image',
      pickedImageXFile!.path,
      filename: imageName,
    );
    requestImgurApi.files.add(imageFile);
    var responseFromImgurApi = await requestImgurApi.send();
    var responseDataFromImgurApi = await responseFromImgurApi.stream.toBytes();
    var resultFromImgurApi = String.fromCharCodes(responseDataFromImgurApi);
    print("Result :: ");
    print(resultFromImgurApi);
    Map<String, dynamic> jsonRes = jsonDecode(resultFromImgurApi);
    movieImageLink = (jsonRes["data"]["link"]).toString();
    print(movieImageLink);
    saveItemInfoToDatabase();
  }

  saveItemInfoToDatabase() async
  {
     try {
      var response = await http.post(Uri.parse(API.uploadMovieItems),
          body:
          {
            'movie_id': '1',
            'movie_title': titleController.text.trim().toString(),
            'movie_releaseyear':releaseYearController.text.trim().toString(),
            'movie_rating': ratingController.text.trim().toString(),
            'movie_genre': genreController.text.trim().toString(),
            'movie_director': directorController.text.trim().toString(),
            'movie_information': informationController.text.trim().toString(),
            'movie_image': movieImageLink.toString(),
          });
      if (response.statusCode == 200) {
        var responseBodyOfUploadItem = jsonDecode(response.body);
        if (responseBodyOfUploadItem['success'] == true) {
          Fluttertoast.showToast(msg: 'New movie got uploaded successfully.');
          setState(() {
            pickedImageXFile=null;
            titleController.clear();
            releaseYearController.clear();
            ratingController.clear();
            genreController.clear();
            directorController.clear();
            informationController.clear();
          });
          Get.to(AdminUploadItemsScreen());
        }
        else {
          Fluttertoast.showToast(
              msg: 'Movie Item not uploaded successfully. Error, try again.');
        }
      }
    }
    catch (e) {
      print("Error:: " + e.toString());
    }
  }


  Widget uploadItemFormScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black12,
                Colors.deepPurple,
              ],
            ),
          ),
        ),
        title: Text('Upload Form'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            setState(() {
              pickedImageXFile=null;
              titleController.clear();
              releaseYearController.clear();
              ratingController.clear();
              genreController.clear();
              directorController.clear();
              informationController.clear();
            });
            Get.to(AdminUploadItemsScreen());
          },
          icon: const Icon(
            Icons.clear,
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Fluttertoast.showToast(
                      msg: 'Uploading movie items starts now.');
                  uploadItemImage();
                }
              },
              child: Text(
                'Done',
                style: TextStyle(
                  color: Colors.red,
                ),
              ))
        ],

      ),
      body:
      ListView(
        children: [
          Container(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.4,
            width: MediaQuery
                .of(context)
                .size
                .width * 0.8,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(File(pickedImageXFile!.path)),
                fit: BoxFit.cover,
              ),

            ),
          ),
          Padding(
            padding: EdgeInsets.all(18),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.all(
                  Radius.circular(60),
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 0,
                    color: Colors.black26,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(30, 30, 30, 8),
                child: Column(
                  children: [
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: titleController,
                            validator: (val) =>
                            val == ''
                                ? "Enter movie name"
                                : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.title,
                                color: Colors.black,
                              ),
                              hintText: "Movie name...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                          SizedBox(height: 18.0),
                          TextFormField(
                            controller: releaseYearController,
                            validator: (val) =>
                            val == ''
                                ? "Enter release year...."
                                : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.data_saver_on_outlined,
                                color: Colors.black,
                              ),
                              hintText: "release year...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                          SizedBox(height: 18.0),
                          TextFormField(
                            controller: ratingController,
                            validator: (val) =>
                            val == ''
                                ? "Enter ratings"
                                : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.rate_review,
                                color: Colors.black,
                              ),
                              hintText: "Movie rating...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                          SizedBox(height: 18.0),

                          TextFormField(
                            controller: genreController,
                            validator: (val) =>
                            val == ''
                                ? "Pls enter gentre"
                                : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.tag,
                                color: Colors.black,
                              ),
                              hintText: "Genre Name...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                          SizedBox(height: 18.0),

                          TextFormField(
                            controller: directorController,
                            validator: (val) =>
                            val == ''
                                ? "Pls enter the director of the movie..."
                                : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.price_change_outlined,
                                color: Colors.black,
                              ),
                              hintText: "Director name...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                          SizedBox(height: 18.0),

                          TextFormField(
                            controller: informationController,
                            validator: (val) =>
                            val == ''
                                ? "Pls write the details about the movie"
                                : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.picture_in_picture,
                                color: Colors.black,
                              ),
                              hintText: "Movie Details...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                          SizedBox(height: 18.0),
                          Material(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(30),
                            child: InkWell(
                              onTap: () {
                                if (formKey.currentState!.validate()) {
                                  Fluttertoast.showToast(
                                      msg: 'Uploading movie items starts now.');
                                  uploadItemImage();
                                }
                              },
                              borderRadius: BorderRadius.circular(30),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 28,
                                ),
                                child: Text('Upload', style: TextStyle(
                                    fontSize: 16, color: Colors.white),),

                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),

                  ],
                ),),
            ),),

        ],
      ),
    );
  }

  Widget defaultScreen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black12,
                Colors.deepPurple,
              ],
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
              onPressed: () {
                  Get.to(MovieListScreen());
              },
      icon: const Icon(
        Icons.list,
        color:Colors.red,
        size: 40,
        ),
    ),
     ),
      body:
      Container(
        child:
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.add_photo_alternate,
                color: Colors.grey,
                size: 200,
              ),
              Material(
                color: Colors.black,
                borderRadius: BorderRadius.circular(30),
                child: InkWell(
                  onTap: () {
                    showDialogBoxForPickingAndCapturing();
                  },

                  borderRadius: BorderRadius.circular(30),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 28,
                    ),
                    child: Text('Add New Item',
                      style: TextStyle(fontSize: 16, color: Colors.white),),

                  ),
                ),
              ),
            ],
          ),),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return pickedImageXFile == null ? defaultScreen() : uploadItemFormScreen();
  }
}


