import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_newocean/common/constants.dart';
import 'package:flutter_app_newocean/ocean_icon/ocean_icons.dart';

class DesktopTopNavigationBar extends StatelessWidget {
  final String title;

  DesktopTopNavigationBar({this.title});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Color(0xff0091D2),
          height: 310,
          width: double.infinity,
          child: Center(
            child: AutoSizeText(
              title,
              maxLines: 1,
              style: TextStyle(
                fontSize: 35,
                color: Colors.white,
                wordSpacing: 1.8,
                fontFamily: kfontname,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Positioned(
          top: 20,
          left: 20,
          child: Icon(
            Ocean.o,
            size: 70,
            color: Color(0xffBFD400),
          ),
        ),
        Positioned(
          top: 120,
          left: 70,
          child: Icon(
            Ocean.o,
            size: 70,
            color: Color(0xffF8BE5A),
          ),
        ),
        Positioned(
          top: 180,
          left: 170,
          child: Icon(
            Ocean.line_circleshape,
            size: 95,
            color: Color(0xffFFD444),
          ),
        ),
        Positioned(
          top: 20,
          right: 20,
          child: Icon(
            Ocean.o,
            size: 70,
            color: Color(0xffBFD400),
          ),
        ),
        Positioned(
          top: 130,
          right: 100,
          child: Icon(
            Ocean.o,
            size: 70,
            color: Color(0xffF8BE5A),
          ),
        ),
        Positioned(
          top: 130,
          right: 1,
          child: Transform.rotate(
            angle: -0.3,
            child: Icon(
              Ocean.a,
              size: 75,
              color: Color(0xff00FFB9),
            ),
          ),
        ),
        Positioned(
          top: 220,
          right: 40,
          child: Transform.rotate(
            angle: -0.3,
            child: Icon(
              Ocean.a,
              size: 75,
              color: Color(0xffFF00FF),
            ),
          ),
        ),
        Positioned(
          top: 180,
          right: 210,
          child: Icon(
            Ocean.line_circleshape,
            size: 95,
            color: Color(0xffFFD444),
          ),
        )
      ],
    );
  }
}
