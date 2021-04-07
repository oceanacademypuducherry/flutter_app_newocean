import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app_newocean/Home/DesktopHome_subTopics/main_title_widget.dart';
import 'package:flutter_app_newocean/common/comments.dart';
import 'package:flutter_app_newocean/common/text.dart';

import 'package:provider/provider.dart';

import '../../route/Provider/provider_routing.dart';

class UpcomingCourse extends StatefulWidget {
  @override
  _UpcomingCourseState createState() => _UpcomingCourseState();
}

class _UpcomingCourseState extends State<UpcomingCourse> {
  final _firestore = FirebaseFirestore.instance;
  // var leftnumber;
  // int number = 1;
  // void left() {
  //   number = number + 1;
  //   print("nnnn");
  //   if (number < leftnumber) {
  //     number = 1;
  //     print("aaa");
  //   }
  // }

  //void right() {}
  List<Container> bubbles = [];
  List<Container> temp = [];

  void getData() async {
    final message = await _firestore.collection('Upcoming_Course').get();
    print(message.docs);

    for (var courses in message.docs) {
      //print(courses.data()['img']);
      String a = courses.data()['upcomingcourse'];
      Provider.of<UpcomingModel>(context, listen: false).updateFlags(1);
      Widget coursIMG = Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            height: 300.0,
            child: Image(
              image: NetworkImage(a),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );

      bubbles.add(coursIMG);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  var a;
  void left() {
    bubbles.insert(0, temp[temp.length - 1]);
    temp.removeAt(temp.length - 1);
  }

  void right() {
    if (bubbles.length > 4) {
      a = bubbles.removeAt(0);
      print(a);
      temp.add(a);
    } else {
      print("DASAAda");
    }
    // print(temp);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('images/oa_bg.png'))),
          padding: EdgeInsets.only(top: 20.0, bottom: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: MainTitleWidgetHome(
                  title: "Upcoming Courses",
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              TextWidget(
                title: upcomingcontent,
              ),
              SizedBox(
                height: 40.0,
              ),
              Container(
                alignment: Alignment.center,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Consumer<UpcomingModel>(
                          builder: (context, cart, child) {
                        return Row(
                          children: bubbles,
                        );
                      }),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              left();
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.all(15.0),
                            alignment: Alignment.center,
                            width: 60.0,
                            height: 60.0,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(500.0)),
                            child: Icon(
                              Icons.chevron_left,
                              size: 50.0,
                            ),
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              right();
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.all(15.0),
                            alignment: Alignment.center,
                            width: 60.0,
                            height: 60.0,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(500.0)),
                            child: Icon(
                              Icons.chevron_right,
                              size: 50.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}