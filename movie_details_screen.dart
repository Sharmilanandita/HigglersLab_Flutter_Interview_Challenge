import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:movie_app/model/movie.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Movie? itemInfo;
  MovieDetailsScreen({this.itemInfo});
  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      backgroundColor: Colors.white,
      body:
      Stack(
        children: [
          FadeInImage(
            height: MediaQuery.of(context).size.height*0.5,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            placeholder: AssetImage(
                'assets/images/place_holder.png'),
            image: NetworkImage(
              widget.itemInfo!.movie_image!,
            ),
            imageErrorBuilder: (context, error,
                stackTraceError) {
              return Center(
                child: Icon(Icons.broken_image_outlined),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child:itemInfoWidget(),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child:Container(
              color: Colors.transparent,
              child: Row(
                children: [
                  IconButton(
                    onPressed: (){
                      Get.back();
                    },
                    icon: Icon(Icons.arrow_back,
                      color: Colors.black,
                      size: 30,

                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  itemInfoWidget()
  {
    return Container(
      height:MediaQuery.of(Get.context!).size.height*0.6,
      width: MediaQuery.of(Get.context!).size.width,
      decoration: BoxDecoration(
        color:Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0,-3),
            blurRadius: 0,
            color: Colors.black,
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child:SingleChildScrollView(
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height:18.0,),
            Center(
              child:Container(
                height: 8,
                width: 140,
                decoration: BoxDecoration(
                  color:Colors.black,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 30,),
            Text(
              widget.itemInfo!.movie_title!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          RatingBar.builder(
                            initialRating: widget.itemInfo!.movie_rating!,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemBuilder: (context, c) =>
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,

                                ),
                            onRatingUpdate: (updateRating) {

                            },
                            ignoreGestures: true,
                            unratedColor: Colors.grey,
                            itemSize: 20,
                          ),
                          const SizedBox(width: 8,),
                          Text(
                            "(" +
                                widget.itemInfo!.movie_rating.toString() +
                                ")",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height:10),
                      Text(
                        widget.itemInfo!.movie_releaseyear.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height:16),
                    ],
                  ),
                ),
              ],
            ),
           SizedBox(height:20.0,),
            const Text(
              'Genre:',
              style: TextStyle(
                fontSize: 18,
                color:Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height:8.0,),
            Text(
              widget.itemInfo!.movie_genre!,
              textAlign: TextAlign.left,
              style: TextStyle(
                color:Colors.black,
                fontWeight: FontWeight.bold,
              ),

            ),
            SizedBox(height:20.0,),
            const Text(
              'Director:',
              style: TextStyle(
                fontSize: 18,
                color:Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height:8.0,),
            Text(
              widget.itemInfo!.movie_director!,
              textAlign: TextAlign.left,
              style: TextStyle(
                color:Colors.black,
                fontWeight: FontWeight.bold,
              ),

            ),
            SizedBox(height:20.0,),
            const Text(
              'Movie Details:',
              style: TextStyle(
                fontSize: 18,
                color:Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height:8.0,),
            Text(
              widget.itemInfo!.movie_information!,
              textAlign: TextAlign.justify,
              style: TextStyle(
                color:Colors.black,
                fontWeight: FontWeight.bold,
              ),

            ),
            SizedBox(height:30),
            Material(
              color: Colors.purple[800],
              borderRadius: BorderRadius.circular(10),
              elevation: 4,
              child:InkWell(
                onTap: (){

                },
                borderRadius: BorderRadius.circular(10),
                child:Container(
                  height:50,
                  alignment: Alignment.center,
                  child:Text('View Movie',
                    style: TextStyle(
                      fontSize: 20,
                      color:Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height:30),

          ],
        ),
      ),
    );
  }
}
