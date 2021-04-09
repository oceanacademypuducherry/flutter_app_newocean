import 'package:flutter/material.dart';
import 'package:flutter_app_newocean/Home/DesktopHome_subTopics/stars.dart';

class GoogleReview extends StatefulWidget {
  @override
  _GoogleReviewState createState() => _GoogleReviewState();
}

class _GoogleReviewState extends State<GoogleReview> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 370.0,
      child: Column(
        children: [
          SizedBox(height: 30),
          Container(
            width: 300,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image(
                  image: AssetImage('images/googleReview.png'),
                  width: 220,
                ),
                Positioned(
                  bottom: 5.0,
                  right: -5.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stars(
                        containerSize: 30,
                        iconColor: Colors.green,
                        starRating: 5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
