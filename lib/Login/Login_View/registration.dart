import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_newocean/Login/Login_View/otp.dart';

import 'package:flutter_app_newocean/Login/login_widget/new_user_widget/contry_states.dart';
import 'package:flutter_app_newocean/Login/login_widget/new_user_widget/date_picker.dart';
import 'package:flutter_app_newocean/Login/login_widget/new_user_widget/gender_dropdoen_field.dart';
import 'package:flutter_app_newocean/Login/login_widget/new_user_widget/input_text_field.dart';
import 'package:flutter_app_newocean/getx_controller.dart';
import 'package:flutter_app_newocean/route/navigation_locator.dart';
import 'package:flutter_app_newocean/route/navigation_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _firestore = FirebaseFirestore.instance;
  //text field controller and variable
  // GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String firstName;
  String lastName;
  String eMail;
  String companyOrSchool;
  String dgree;
  // String country;
  String state;
  String phoneNumber;
  String portfolioLink;

  String dOB;

  Future<DateTime> _selectDateTime(BuildContext context) {
    return showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1980),
        lastDate: DateTime.now());
  }

  final _dateOfBirth = TextEditingController();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _eMail = TextEditingController();
  final _companyOrSchool = TextEditingController();
  final _dgree = TextEditingController();
  final _phoneNumber = TextEditingController(text: OTP.userID);

  List inputFormatte({@required String regExp, int length}) {
    List<TextInputFormatter> formater = [
      FilteringTextInputFormatter.allow(RegExp(regExp)),
      LengthLimitingTextInputFormatter(length)
    ];
    return formater;
  }

  session() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', OTP.userID);
    print("${OTP.userID} ssssssssssssss");
    print('Otp Submited');
  }

  Uint8List uploadFile;
  String fileName;
  String profilePictureLink;

  List<String> country = [];
  final countryContrller = TextEditingController();
  final stateContrller = TextEditingController();
  String selectedCountry = '';
  String selectedState = '';
  Map<String, List> countryState = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (var i in contryState['countries']) {
      print(i['states']);
      country.add(i['country']);
      countryState.addAll({i['country']: i['states']});
      // _phoneNumber.text = LoginResponsive.registerNumber;
    }
  }

  final valueController = Get.find<ValueListener>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          color: Color(0xff2B9DD1),
          height: 1000.0,
        ),
        Positioned(
            top: -70,
            left: -250.0,
            child: Image.asset(
              'images/rectangle-01.png',
              width: 600.0,
            )),
        Positioned(
            top: -90,
            right: 100.0,
            child: Image.asset(
              'images/tryangle-01.png',
              width: 350.0,
            )),
        Positioned(
            bottom: 90,
            right: 0.0,
            child: Image.asset(
              'images/circle-01.png',
              width: 450.0,
            )),
        Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20.0),
              width: 1250,
              decoration: BoxDecoration(
                  color: Color(0xff006793),
                  borderRadius: BorderRadius.circular(10.0)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Register Your Account',
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            // color: Colors.white,
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(100.0),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 8.0,
                                  offset: Offset(4.0, 4.0))
                            ]),
                        child: GestureDetector(
                          onTap: () async {
                            FilePickerResult result = await FilePicker.platform
                                .pickFiles(type: FileType.image);
                            if (result != null) {
                              uploadFile = result.files.single.bytes;
                              fileName = basename(result.files.single.name);
                              print(fileName);
                              uploadProfilePicture(context);
                            } else {
                              print('pick image');
                            }
                            // Upload to  firebase Storage
                            // call upload function
                          },
                          child: CircleAvatar(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(500.0),
                              child: Container(
                                color: Colors.white,
                                width: 100.0,
                                height: 100.0,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    profilePictureLink != null
                                        ? Image.network(
                                            profilePictureLink,
                                            width: 250.0,
                                            height: 250.0,
                                            fit: BoxFit.cover,
                                          )
                                        : Icon(
                                            Icons.add_a_photo,
                                            color: Colors.blue,
                                          ),
                                  ],
                                ),
                              ),
                            ),
                            radius: 45.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  Form(
                    // key: formkey,
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      children: [
                        LableWithTextField(
                          lableText: 'First Name',
                          errorText: 'Enter First Name',
                          width: 300.0,
                          controller: _firstName,
                          visible: isFirstName,
                          onChanged: (value) {},
                          inputFormatters: inputFormatte(
                              regExp: r"[a-zA-Z]+|\s", length: 15),
                        ),
                        LableWithTextField(
                            lableText: 'Last Name',
                            errorText: 'Enter Last Name',
                            width: 300.0,
                            visible: isLastName,
                            controller: _lastName,
                            onChanged: (value) {},
                            inputFormatters: inputFormatte(
                                regExp: r"[a-zA-Z]+|\s", length: 15)),
                        GenderDropdownField(
                          visible: isGender,
                          errorText: 'Select',
                        ),
                        DatePicker(
                          errorText: 'Date Required',
                          datePickerIcon: IconButton(
                            icon: Icon(Icons.date_range),
                            onPressed: () async {
                              final selectedDate =
                                  await _selectDateTime(context);
                              setState(() {
                                dOB = DateFormat('d-M-y').format(selectedDate);
                                _dateOfBirth.text = dOB;
                                print('${dOB}date of birth');
                              });
                            },
                          ),
                          controller: _dateOfBirth,
                          visible: isDateOfBirth,
                          onChanged: (value) {
                            setState(() {
                              _dateOfBirth.text = value;
                            });
                          },
                        ),
                        LableWithTextField(
                          lableText: 'E-Mail Adsress',
                          errorText: 'Invalid Email Adress',
                          visible: isEmail,
                          width: 300.0,
                          controller: _eMail,
                          onChanged: (value) {},
                        ),
                        LableWithTextField(
                          lableText: 'Company/School',
                          errorText: 'Your Company/School Name',
                          width: 300.0,
                          visible: isCompanyOrSchool,
                          controller: _companyOrSchool,
                          inputFormatters:
                              inputFormatte(regExp: r"[a-zA-Z]+|\s"),
                          onChanged: (value) {},
                        ),
                        LableWithTextField(
                          lableText: 'Degree',
                          errorText: 'Enter your Education Qualification',
                          width: 250.0,
                          visible: isDegree,
                          controller: _dgree,
                          onChanged: (value) {},
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Country',
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.white),
                              ),
                              SizedBox(
                                height: 9,
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: 300,
                                padding: EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                ),
                                child: DropDownField(
                                  controller: countryContrller,
                                  hintText: 'Select Country',
                                  hintStyle: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[500]),
                                  textStyle: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[700]),
                                  enabled: true,
                                  strict: true,
                                  required: isCountry,
                                  itemsVisibleInDropdown: 3,
                                  items: country,
                                  onValueChanged: (value) {
                                    setState(() {
                                      selectedCountry = value;
                                      print(selectedCountry);
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'State',
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.white),
                              ),
                              SizedBox(
                                height: 9,
                              ),
                              Container(
                                  alignment: Alignment.center,
                                  width: 300,
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white,
                                  ),
                                  child: DropDownField(
                                    controller: stateContrller,
                                    hintText: 'Select State',
                                    hintStyle: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[500]),
                                    textStyle: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[700]),
                                    enabled: selectedCountry.length > 1
                                        ? true
                                        : false,
                                    strict: true,
                                    required: true,
                                    itemsVisibleInDropdown: 3,
                                    items: countryState[selectedCountry],
                                    onValueChanged: (value) {
                                      setState(() {
                                        selectedState = value;
                                        print(selectedState);
                                      });
                                    },
                                  )),
                            ],
                          ),
                        ),
                        LableWithTextField(
                          lableText: 'Phone Number',
                          errorText: 'Invalid Phonenumber',
                          width: 250.0,
                          rReadOnly: true,
                          visible: isPhoneNumber,
                          controller: _phoneNumber,
                          onChanged: (value) {},
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlatButton(
                          minWidth: 300.0,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 25.0),
                            ),
                          ),
                          color: Color(0xff014965),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          onPressed: () async {
                            if (registerFormValidation() == true) {
                              print('Completed');

                              fireStoreAdd();
                              textFieldClear();
                              await session();
                              locator<NavigationService>().navigateTo(
                                  '/ClassRoom?userNumber=${OTP.userID}&typeOfCourse=My%20Course');
                              valueController.navebars.value = 'Login';
                              valueController.userNumber.value = OTP.userID;
                            } else {
                              print('fill again');
                            }

                            // fireStoreAdd();
                            //  textFieldClear();
                          }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }

  Future uploadProfilePicture(BuildContext context) async {
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = firebaseStorageRef.putData(uploadFile);
    // SnakBar Message
    TaskSnapshot taskSnapShot = await uploadTask.whenComplete(() {
      setState(() {
        print('Profile Picuter Upload Complete');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Profile picture Uploaded')));
        // get Link
        uploadTask.snapshot.ref.getDownloadURL().then((value) {
          setState(() {
            profilePictureLink = value;
          });
          print("${profilePictureLink}profilePictureLink1111111111111");
        });
      });
    });
  }

  void textFieldClear() {
    setState(() {
      profilePictureLink = profilePictureLink = null;
    });
    _firstName.clear();
    _lastName.clear();
    _dateOfBirth.clear();
    GenderDropdownField.gendVal = null;
    _eMail.clear();
    _companyOrSchool.clear();
    _dgree.clear();
    countryContrller.clear();
    stateContrller.clear();
    _phoneNumber.clear();
  }

  void fireStoreAdd() {
    _firestore.collection('new users').doc(_phoneNumber.text).set({
      'Profile Picture': profilePictureLink,
      'First Name': _firstName.text,
      'Last Name': _lastName.text,
      'Gender': GenderDropdownField.gendVal,
      'Date of Birth': dOB,
      'E Mail': _eMail.text,
      'Company or School': _companyOrSchool.text,
      'Degree': _dgree.text,
      'Country': selectedCountry,
      'State': selectedState,
      'Phone Number': _phoneNumber.text,
      'Courses': [],
      'batchid': [],
    });
  }

  bool isEmail = false;
  bool isFirstName = false;
  bool isLastName = false;
  bool isDateOfBirth = false;
  bool isGender = false;
  bool isCompanyOrSchool = false;
  bool isDegree = false;
  bool isCountry = false;
  bool isState = false;
  bool isPhoneNumber = false;

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  bool nameValidation(String value) {
    Pattern pattern = r"[a-zA-Z]+|\s";
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  bool phoneNumberValidation(String value) {
    Pattern pattern = r'^\d+\.?\d{0,2}';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  bool validateUrl(String value) {
    Pattern pattern =
        r'^(http:\/\/www\.)*(https:\/\/www\.)*(http:\/\/)*(https:\/\/)*(www\.)*(WWW\.)*[a-z0-9A-Z]+([\-\.]{1}[a-z0-9A-Z]+)*\.[a-zA-Z]{2,5}(:[0-9]{1,5})?(\/.*)?$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  bool registerFormValidation() {
    bool ifRFV = false;
    bool elseRFV = true;
    // first name
    if (!nameValidation(_firstName.text) || _firstName.text.length < 3) {
      setState(() {
        isFirstName = true;
        ifRFV = isFirstName;
      });
    } else {
      setState(() {
        isFirstName = false;
        elseRFV = isFirstName;
      });
    }

    if (GenderDropdownField.gendVal == null) {
      setState(() {
        isGender = true;
        ifRFV = isGender;
      });
    } else {
      setState(() {
        isGender = false;
        elseRFV = isGender;
      });
    }
    //date
    if (_dateOfBirth.text.isEmpty) {
      setState(() {
        isDateOfBirth = true;
        ifRFV = isDateOfBirth;
      });
    } else {
      setState(() {
        isDateOfBirth = false;
        elseRFV = isDateOfBirth;
      });
    }
    // email
    if (!validateEmail(_eMail.text)) {
      setState(() {
        isEmail = true;
        ifRFV = isEmail;
      });
    } else {
      setState(() {
        isEmail = false;
        elseRFV = isEmail;
      });
    }
    //Company or school
    if (!nameValidation(_companyOrSchool.text) ||
        _companyOrSchool.text.length < 3) {
      setState(() {
        isCompanyOrSchool = true;
        ifRFV = isCompanyOrSchool;
      });
    } else {
      setState(() {
        isCompanyOrSchool = false;
        elseRFV = isCompanyOrSchool;
      });
    }
    //Degree
    if (!nameValidation(_dgree.text) || _dgree.text.length < 1) {
      setState(() {
        isDegree = true;
        ifRFV = isDegree;
      });
    } else {
      setState(() {
        isDegree = false;
        elseRFV = isDegree;
      });
    }
    //Country
    if (selectedCountry == null || selectedCountry.length < 1) {
      setState(() {
        isCountry = true;
        ifRFV = isCountry;
      });
    } else {
      setState(() {
        isCountry = false;
        elseRFV = isCountry;
      });
    }
    //state
    if (selectedState == null || selectedState.length < 1) {
      setState(() {
        isState = true;
        ifRFV = isState;
      });
    } else {
      setState(() {
        isState = false;
        elseRFV = isState;
      });
    }
    //phonenumber
    if (_phoneNumber.text.length < 6) {
      setState(() {
        isPhoneNumber = true;
        ifRFV = isPhoneNumber;
      });
    } else {
      setState(() {
        isPhoneNumber = false;
        elseRFV = isPhoneNumber;
      });
    }

    return ifRFV == elseRFV;
  }
}
