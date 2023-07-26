import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:movie_app/model/movie.dart';
import 'package:http/http.dart' as http;
import '../api_connection/api_connection.dart';
import 'movie_details_screen.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({Key? key}) : super(key: key);

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {

  Future <List<Movie>> getAllMovieItems() async
  {
    List<Movie> allMovieItemsList = [];
    try {
      var res = await http.post(Uri.parse(API.allMovieItems));
      if (res.statusCode == 200) {
        var responseBodyOfAllMovies = jsonDecode(res.body);
        if (responseBodyOfAllMovies["success"] == true) {
          print("yes...........success");
          (responseBodyOfAllMovies["movieItemsData"] as List).forEach((
              eachRecord) {
            allMovieItemsList.add(Movie.fromJson(eachRecord));
          });
        }
        print(allMovieItemsList[0].movie_director.toString());
      }
      else {
        Fluttertoast.showToast(msg: "Error, Status code os not equal to 200");
      }
    }
    catch (e) {
      print("Error:: " + e.toString());
    }
    return allMovieItemsList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body:
        SingleChildScrollView(
          child:SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16,),
                child: Text('Latest Movies',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
              allItemsWidget(context),
            ],
          ),
        )));
  }
  Widget allItemsWidget(context) {
    return FutureBuilder(
        future: getAllMovieItems(),
        builder: (context, AsyncSnapshot<List<Movie>> dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (dataSnapShot.data == null) {
            return const Center(
              child: Text('Latest Movies not found.'),
            );
          }
          if (dataSnapShot.data!.length >= 0) {
            return ListView.builder(
              itemCount: dataSnapShot.data!.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                Movie eachMovieItemsRecord = dataSnapShot.data![index];
                return GestureDetector(
                  onTap: () {
                    Get.to(MovieDetailsScreen(itemInfo:eachMovieItemsRecord));
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(
                      16,
                      index == 0 ? 16 : 8,
                      16,
                      index == dataSnapShot.data!.length - 1 ? 16 : 8,
                    ),

                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow:
                        [
                          BoxShadow(
                            offset: Offset(0, 0),
                            blurRadius: 5,
                            color: Colors.black,
                          )
                        ]
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        eachMovieItemsRecord.movie_title!,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                 ],
                                ),
                                SizedBox(height: 16.0,),
                              ],
                            ),
                          ),
                        ),
                        ClipRRect(
                            borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),

                          ),
                          child: FadeInImage(

                            height: 130,
                            width: 130,
                            fit: BoxFit.cover,
                            placeholder: AssetImage(
                                'assets/images/place_holder.png'),
                            image: NetworkImage(
                              eachMovieItemsRecord.movie_image!,
                            ),
                            imageErrorBuilder: (context, error,
                                stackTraceError) {
                              return Center(
                                child: Icon(Icons.broken_image_outlined),
                              );
                            },
                          ),
                        ),

                      ],
                    ),

                  ),
                );
              },
            );
          }
          else {
            return const Center(
              child: Text('Empty, no data found'),
            );
          }
        });
  }
}
