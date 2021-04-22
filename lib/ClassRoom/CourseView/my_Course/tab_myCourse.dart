import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_newocean/Course/Course_widget/online_course_card.dart';
import 'package:flutter_app_newocean/Login_Menubar/login_drawer.dart';
import 'package:flutter_app_newocean/route/navigation_locator.dart';
import 'package:flutter_app_newocean/route/navigation_service.dart';

final _firestore = FirebaseFirestore.instance;

class TabMyCourse extends StatefulWidget {
  bool isEnroll = false;

  @override
  _TabMyCourseState createState() => _TabMyCourseState();
}

class _TabMyCourseState extends State<TabMyCourse> {
  List<String> subjects = [];

  @override
  void initState() {
    // TODO: implement initState
    // getMessage();
    //batch_id();
    super.initState();
    print('${LoginDrawer.courseMenuDrawer}TabCoursesView.batchId');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.pinkAccent[100],
            image: DecorationImage(
                image: AssetImage('images/oa_bg.png'),
                repeat: ImageRepeat.repeatY)),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('course').snapshots(),
              // ignore: missing_return
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text("Loading...");
                } else {
                  final messages = snapshot.data.docs;

                  List<MyCourseDb> batchList = [];
                  for (var message in messages) {
                    for (var batch in LoginDrawer.courseMenuDrawer) {
                      if (message.id == batch) {
                        print("now${message.id}");
                        final messageText = message.data()['trainername'];
                        final messageSender = message.data()['coursename'];
                        final messageSession = message.data()['session'];
                        final messageTime = message.data()['time'];
                        final messageImage = message.data()['img'];
                        final messageDescription =
                            message.data()['coursedescription'];
                        final messageBatchId = message.data()['batchid'];

                        final batchDb = MyCourseDb(
                          trainername: messageText,
                          coursename: messageSender,
                          session: messageSession,
                          time: messageTime,
                          image: messageImage,
                          description: messageDescription,
                          batchid: messageBatchId,
                        );
                        // Text('$messageText from $messageSender');
                        batchList.add(batchDb);
                        subjects.add(message.data()["coursename"]);
                      }
                    }
                  }

                  return Wrap(
                    alignment: WrapAlignment.center,
                    children: batchList,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MyCourseDb extends StatefulWidget {
  static bool visiblity = false;
  MyCourseDb(
      {this.coursename,
      this.trainername,
      this.session,
      this.time,
      this.image,
      this.description,
      this.batchid});
  final String coursename;
  final String trainername;
  final String session;
  final String time;
  final String image;
  final String description;
  final String batchid;

  @override
  _MyCourseDbState createState() => _MyCourseDbState();
}

class _MyCourseDbState extends State<MyCourseDb> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          MyCourseDb.visiblity = true;
        });
        setState(() {
          //OnlineCourse.visiblity = false;
        });
        setState(() {
          // Navbar.visiblity = false;
        });
        print("${widget.coursename}widget.coursename");
        // Provider.of<SyllabusView>(context, listen: false).updateCourseSyllabus(
        //     routing: CourseDetails(
        //       batch: widget.batchid,
        //       course: widget.coursename,
        //       trainer: widget.trainername,
        //       sess: widget.time,
        //       desc: widget.description,
        //     ));
      },
      child: Container(
        margin: EdgeInsets.all(35.0),
        //padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
        height: 350.0,
        width: 343.0,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.circular(15.0)),
        child: Column(
          children: [
            SizedBox(
              height: 5,
            ),
            MouseRegion(
              //cursor: SystemMouseCursors.click,
              child: Container(
                width: 330,
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image(
                    image: NetworkImage('${widget.image}'),
                    fit: BoxFit.cover,
                    // width: 350.0,
                    // height: 100.0,
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "${widget.coursename} full package course | ${widget.trainername} | Ocean Academy",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton(
                        hoverColor: Colors.blue[50],
                        height: 45,
                        minWidth: 300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1),
                          side: BorderSide(color: Colors.blue, width: 1),
                        ),
                        color: Colors.white,
                        onPressed: () {
                          setState(() {
                            MyCourseDb.visiblity = true;
                          });
                          setState(() {
                            OnlineCourseCard.visiblity = false;
                          });
                          setState(() {
                            // Navbar.visiblity = false;
                          });
                          print("${widget.coursename}widget.coursename");
                          locator<NavigationService>().navigateTo(
                              'CourseDetails?online=${widget.coursename}&batchID=${widget.batchid}&trainer=${widget.trainername}&description=${widget.description}');
                          // Provider.of<SyllabusView>(context, listen: false)
                          //     .updateCourseSyllabus(
                          //         routing: CourseDetails(
                          //   batch: widget.batchid,
                          //   course: widget.coursename,
                          //   trainer: widget.trainername,
                          //   sess: widget.time,
                          //   desc: widget.description,
                          // ));
                        },
                        child: Text(
                          'MORE INFO',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ))

                    /// todo . .moveUpOnHover,
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}