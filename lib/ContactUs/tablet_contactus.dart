// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'package:flutter_app_newocean/ContactUs/iframe_map.dart';
import 'package:flutter_app_newocean/Footer/tablet_footer.dart';
import 'package:flutter_app_newocean/TopNavigationBar/tablet_topnavigationbar.dart';
import 'package:flutter_app_newocean/common/mobile_constents.dart';
import 'package:flutter_app_newocean/common/text.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:progress_indicator_button/progress_button.dart';
import 'package:random_string/random_string.dart';

final _firestore = FirebaseFirestore.instance;

class TabletContactUs extends StatefulWidget {
  @override
  _TabletContactUsState createState() => _TabletContactUsState();
}

class _TabletContactUsState extends State<TabletContactUs> {
  List<String> enquery = [
    'Select',
    'Enquery1',
    'Enquery2',
    'Enquery3',
    'Enquery4',
  ];

  String enquiry = 'Select';
  String fullname;
  String email;
  String query;
  String phoneNumber;
  var date;
  var time;
  String firstInt;
  String secondInt;
  int answer;
  String total;
  bool validation = false;
  bool showSpinner = false;

  final enquiryController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final queryController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final answerController = TextEditingController();

  dynamic getDate() async {
    return DateTime.now();
  }

  void getData() async {
    http.Response response = await http.get(
        """https://shrouded-fjord-03855.herokuapp.com/?name=$fullname&des=$query&mobile=$phoneNumber&email=$email&date=$date $time &type=$enquiry""");

    if (response.statusCode == 200) {
      String data = response.body;
      print(data);
    } else {
      print(response.statusCode);
    }
  }

  String linkMaps =
      "https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d2320.9284365759204!2d79.82874531102095!3d11.952276565466109!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3a53616c1e43a73f%3A0xf3758f2502e74f5b!2sOcean%20Academy%20Software%20Training%20Division!5e0!3m2!1sen!2sin!4v1613816776714!5m2!1sen!2sin";
  final GlobalKey<FormState> _formKeyTab = GlobalKey<FormState>();

  Widget _buildName() {
    return TextFormField(
      // ignore: deprecated_member_use
      autovalidate: validation,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z]+|\s")),
        LengthLimitingTextInputFormatter(40),
      ],
      validator: (value) {
        if (value.isEmpty) {
          return 'Name is required*';
        } else if (value.length < 3) {
          return 'character should be morethan 3*';
        }
        return null;
      },
      decoration: InputDecoration(
        errorStyle: TextStyle(color: Colors.redAccent, fontSize: 12),
        border: OutlineInputBorder(),
        hintText: 'Enter Your Name',
        labelText: 'Name',
      ),
      controller: nameController,
      onChanged: (value) {
        fullname = value;
      },
    );
  }

  Widget _buildphonenumber() {
    return TextFormField(
      // ignore: deprecated_member_use
      autovalidate: validation,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}")),
        LengthLimitingTextInputFormatter(10),
      ],
      validator: (value) {
        if (value.isEmpty) {
          return 'phone_number is required*';
        }
        return null;
      },
      decoration: InputDecoration(
        errorStyle: TextStyle(color: Colors.redAccent, fontSize: 12),
        border: OutlineInputBorder(),
        hintText: 'Enter Your Number',
        labelText: 'Number',
      ),
      controller: phoneNumberController,
      onChanged: (value) {
        phoneNumber = value;
      },
    );
  }

  Widget _buildEmail() {
    return TextFormField(
      // ignore: deprecated_member_use
      autovalidate: validation,
      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"\s"))],
      validator: (value) =>
          EmailValidator.validate(value) ? null : "invalid email",
      decoration: InputDecoration(
        errorStyle: TextStyle(color: Colors.redAccent, fontSize: 12),
        border: OutlineInputBorder(),
        hintText: 'Enter Your Email',
        labelText: 'Email',
      ),
      controller: emailController,
      onChanged: (value) {
        email = value;
      },
    );
  }

  Widget _buildquery() {
    return TextFormField(
      // ignore: deprecated_member_use
      autovalidate: validation,
      validator: (value) {
        // query = value;
        if (value.isEmpty) {
          print(value);
          return "query is required";
        } else if (value.length < 2) {
          return 'character should be more than 2';
        }
        return null;
      },
      maxLines: null,
      maxLength: 1000,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.question_answer_outlined),
        errorStyle: TextStyle(color: Colors.redAccent, fontSize: 12),
        border: OutlineInputBorder(),
        hintText: 'Enter Your Query',
        labelText: 'Query',
      ),
      controller: queryController,
      onChanged: (value) {
        query = value;
      },
    );
  }

  Widget _buildAnswerField() {
    return TextFormField(
      // ignore: deprecated_member_use
      autovalidate: validation,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(
          RegExp(r"^\d+\.?\d{0,2}"),
        ),
        LengthLimitingTextInputFormatter(2),
      ],
      validator: (value) {
        if (answer.toString() != total) {
          return 'wrong';
        }
        return null;
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(5),
        // prefixIcon: Icon(Icons.phone_android_outlined),
        errorStyle: TextStyle(color: Colors.redAccent, fontSize: 0),
        border: OutlineInputBorder(),
        // hintText: 'Enter Your Number',
        // labelText: 'Number',
      ),
      controller: answerController,
      onChanged: (value) {
        total = value;
      },
    );
  }

  List getDropdown() {
    List<DropdownMenuItem<String>> dropList = [];

    for (var enquerys in enquery) {
      var newList = DropdownMenuItem(
        child: Text(enquerys),
        value: enquerys,
      );
      dropList.add(newList);
    }
    return dropList;
  }

  calc() {
    var first = int.parse(firstInt);
    var second = int.parse(secondInt);
    answer = first + second;

    print("$firstInt  //////////////////firstInt");
    print("$secondInt  //////////////////secondInt");
    print("$answer  //////////////////answer");
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      opacity: 0.1,
      inAsyncCall: showSpinner,
      child: SingleChildScrollView(
        child: Column(
          children: [
            TabletTopNavigationBar(
              title: 'Contact Us',
            ),
            Padding(
              padding: EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.mobileAlt,
                        color: Colors.blue,
                        size: 40,
                      ),
                      SizedBox(height: 10),
                      Text(
                        '0413-2238675',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          letterSpacing: 1,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          fontFamily: kfontname,
                          color: kcontentcolor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.email_outlined,
                        color: Colors.blue,
                        size: 40,
                      ),
                      Text(
                        'oceanacademy@gmail.com',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          letterSpacing: 1,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          fontFamily: kfontname,
                          color: kcontentcolor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.mapMarkerAlt,
                        color: Colors.blue,
                        size: 40,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'No. 2, Karuvadikuppam Main Rd, '
                        'near GINGER HOTEL, Senthamarai Nagar, '
                        'Muthialpet, Puducherry, 605003',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          letterSpacing: 1,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          fontFamily: kfontname,
                          color: kcontentcolor,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Form(
              key: _formKeyTab,
              child: Padding(
                padding: EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Contact Form',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color(0xff505050),
                          fontSize: 20,
                          fontFamily: kfontname),
                    ),
                    SizedBox(height: 10),
                    Text(
                      contactuscontent,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontFamily: kfontname,
                          color: kcontentcolor,
                          height: 1.5),
                    ),
                    SizedBox(height: 30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'This Enquiry is for',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            fontFamily: kfontname,
                            color: kcontentcolor,
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.grey)),
                          child: DropdownButtonFormField<String>(
                            // ignore: deprecated_member_use
                            autovalidate: validation,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              fontFamily: kfontname,
                              color: kcontentcolor,
                            ),
                            value: enquiry,
                            isExpanded: true,
                            items: getDropdown(),
                            onChanged: (value) {
                              setState(() {
                                enquiry = value;
                              });
                              print(value);
                            },
                          ),
                        ),
                        SizedBox(height: 30),
                        Text(
                          'Full Name',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            fontFamily: kfontname,
                            color: kcontentcolor,
                          ),
                        ),
                        SizedBox(height: 10),
                        _buildName(),
                        SizedBox(height: 30),
                        Text(
                          'Phone Number',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            fontFamily: kfontname,
                            color: kcontentcolor,
                          ),
                        ),
                        SizedBox(height: 10),
                        _buildphonenumber(),
                        SizedBox(height: 30),
                        Text(
                          'E-mail Address',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            fontFamily: kfontname,
                            color: kcontentcolor,
                          ),
                        ),
                        SizedBox(height: 10),
                        _buildEmail(),
                        SizedBox(height: 30),
                        Text(
                          'Your Query',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            fontFamily: kfontname,
                            color: kcontentcolor,
                          ),
                        ),
                        SizedBox(height: 10),
                        _buildquery(),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Text(
                            "I'm not Robot",
                            style: TextStyle(
                              color: Colors.grey[600],
                              letterSpacing: 2,
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey[100],
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blue[400],
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    alignment: Alignment.center,
                                    width: 50,
                                    height: 30,
                                    child: Text(
                                      firstInt =
                                          randomBetween(1, 10).toString(),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    width: 50,
                                    height: 30,
                                    child: Text(
                                      '+',
                                      style: TextStyle(
                                          fontSize: 25, color: Colors.grey),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blue[400],
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    alignment: Alignment.center,
                                    width: 50,
                                    height: 30,
                                    child: Text(
                                      secondInt =
                                          randomBetween(1, 10).toString(),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    width: 50,
                                    height: 30,
                                    child: Text(
                                      '=',
                                      style: TextStyle(
                                          fontSize: 25, color: Colors.grey),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    width: 50,
                                    height: 30,
                                    color: Colors.white,
                                    child: _buildAnswerField(),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 25),
                    Container(
                      width: 100,
                      height: 40,
                      child: ProgressButton(
                          color: Color(0xff0091D2),
                          animationDuration: Duration(milliseconds: 200),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          strokeWidth: 2,
                          child: Text(
                            "Submit",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: kfontname,
                            ),
                          ),
                          onPressed: (AnimationController controller) async {
                            calc();
                            print(answerController.text);

                            TimeOfDay picked = TimeOfDay.now();
                            MaterialLocalizations localizations =
                                MaterialLocalizations.of(context);
                            time = localizations.formatTimeOfDay(picked,
                                alwaysUse24HourFormat: false);

                            date = DateFormat("d-M-y").format(DateTime.now());
                            print('$time < Current Time >');
                            if (_formKeyTab.currentState.validate()) {
                              if (controller.isCompleted) {
                                controller.reverse();
                              } else {
                                controller.forward();
                              }
                              _formKeyTab.currentState.save();
                              if (enquiry != null &&
                                  fullname != null &&
                                  email != null &&
                                  query != null &&
                                  phoneNumber != null &&
                                  answer.toString() == total) {
                                await _firestore.collection('contact_us').add({
                                  'Enquery': enquiry,
                                  'Full_Name': fullname,
                                  'Email': email,
                                  'Query': query,
                                  'Phone_Number': phoneNumber
                                });
                                getData();
                                print("$date < Date Time >");
                                setState(() {
                                  print(
                                      'working////////////////////////////////////');
                                  validation = false;
                                });
                                if (enquiry.isNotEmpty) {
                                  setState(() {
                                    enquiry = enquery[0];
                                  });
                                }
                                nameController.clear();
                                emailController.clear();
                                queryController.clear();
                                phoneNumberController.clear();
                                answerController.clear();

                                if (controller.isCompleted) {
                                  setState(() {
                                    controller.reverse();
                                  });
                                }
                                _showMyDialog(
                                    context: context, content: Alert());
                              }
                            } else {
                              setState(() {
                                print(
                                    'working////////////////////////////////////');
                                validation = true;
                              });
                            }
                          }),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  height: 300,
                  width: 400,
                  child: IframeScreen(400, 300, linkMaps),
                ),
                SizedBox(height: 40),
              ],
            ),
            TabletFooter()
          ],
        ),
      ),
    );
  }
}

class Alert extends StatefulWidget {
  @override
  _AlertState createState() => _AlertState();
}

class _AlertState extends State<Alert> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      height: 420,
      width: 350,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.zero,
            width: 400,
            height: 400,
            child: Container(
              child: Image(
                image: AssetImage(
                  'images/contactus_alert/Group 1.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.zero,
            width: 400,
            height: 500,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Container(
                  width: 180,
                  height: 200,
                  child: Lottie.asset("images/41793-correct.json",
                      controller: _controller,
                      fit: BoxFit.cover, onLoaded: (composition) {
                    _controller
                      ..duration = composition.duration
                      ..forward();
                  }),
                ),
                // Icon(
                //   Icons.check_circle_outline_outlined,
                //   size: 130,
                //   color: Colors.green[500],
                // ),
                SizedBox(height: 40),
                Text(
                  'Sent Successfully!',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 30,
                    fontWeight: FontWeight.normal,
                    fontFamily: "Gilroy",
                  ),
                ),
                // SizedBox(height: 40),
                // Text(
                //   'Now we can go further',
                //   style: TextStyle(color: Colors.grey),
                // ),
                // SizedBox(height: 5),
                // Text(
                //   'Few more steps',
                //   style: TextStyle(color: Colors.grey),
                // ),
                SizedBox(height: 40),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  color: Colors.green[500],
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _showMyDialog({context, content}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        // titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        content: content,
        actions: <Widget>[],
      );
    },
  );
}
