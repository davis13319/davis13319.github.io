// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'dart:convert';
import 'package:flutter/material.dart';
import '../utils/abstracts.dart';
import '../utils/functions.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:http/http.dart';

class SecondPage extends StatefulWidget implements ISaveUtil {
  static _SecondPageState formState = _SecondPageState();
  @override
  _SecondPageState createState() {
    if (formState == null) formState = _SecondPageState();
    return formState;
  }

  @override
  void save() {
    formState.saveFunction();
  }

  void clearState() {
    formState = null;
  }
}

class _SecondPageState extends State<SecondPage> {
  final _formKey = GlobalKey<FormState>();
  String adjective;
  String noun;
  BuildContext mainContext;
  String outReason = "M";
  String natCd = "KR";
  String natNm = "대한민국";
  List<DropdownMenuItem<String>> menuItems = List<DropdownMenuItem<String>>();

  void saveFunction() {
    ScaffoldMessenger.of(mainContext).showSnackBar(SnackBar(
      content: Text("저장기능"),
    ));
  }

  Widget rowColumn({List<Widget> children}) {
    if (MediaQuery.of(context).size.width > 640.0) {
      return Row(
        children: children,
      );
    }
    return SizedBox(
      height: 130,
      child: Column(
        children: children,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mainContext = context;
    return mainScaffold();
  }

  Widget mainScaffold() {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('📖 Story Generator'),
      //   actions: [
      //     Padding(
      //       padding: EdgeInsets.all(8),
      //       child: FlatButton(
      //         textColor: Colors.white,
      //         child: Text('Submit'),
      //         onPressed: () {
      //           // Validate the form by getting the FormState from the GlobalKey
      //           // and calling validate() on it.
      //           var valid = _formKey.currentState.validate();
      //           if (!valid) {
      //             return;
      //           }

      //           showDialog<void>(
      //             context: context,
      //             builder: (context) => AlertDialog(
      //               title: Text('Your story'),
      //               content: Text('The $adjective developer saw a $noun'),
      //               actions: [
      //                 FlatButton(
      //                   child: Text('Done'),
      //                   onPressed: () {
      //                     Navigator.of(context).pop();
      //                   },
      //                 ),
      //               ],
      //             ),
      //           );
      //         },
      //       ),
      //     ),
      //   ],
      // ),
      body: Form(
        key: _formKey,
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                outInfo(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget outInfo() {
    return Column(
      children: [
        rowColumn(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: TextFormField(
                  validator: (value) {
                    return null;
                    //return 'Not a valid adjective.';
                  },
                  decoration: InputDecoration(
                    filled: true,
                    labelText: '확진번호',
                  ),
                  onChanged: (value) {
                    adjective = value;
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: TextFormField(
                  validator: (value) {
                    return null;
                    //return 'Not a valid adjective.';
                  },
                  decoration: InputDecoration(
                    filled: true,
                    labelText: '환자명',
                  ),
                  onChanged: (value) {
                    adjective = value;
                  },
                ),
              ),
            ),
          ],
        ),
        rowColumn(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: TextFormField(
                  validator: (value) {
                    return null;
                    //return 'Not a valid adjective.';
                  },
                  decoration: InputDecoration(
                    filled: true,
                    labelText: '격리실번호',
                  ),
                  onChanged: (value) {
                    adjective = value;
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: TextFormField(
                  inputFormatters: [
                    MaskTextInputFormatter(
                        mask: '####/##/##', filter: {"#": RegExp(r'[0-9]')})
                  ],
                  validator: (value) {
                    return null;
                    //return 'Not a valid adjective.';
                  },
                  decoration: InputDecoration(
                    filled: true,
                    labelText: '내원일',
                  ),
                  onChanged: (value) {
                    adjective = value;
                  },
                ),
              ),
            ),
          ],
        ),
        rowColumn(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: TextFormField(
                  inputFormatters: [
                    MaskTextInputFormatter(
                        mask: '####/##/##', filter: {"#": RegExp(r'[0-9]')})
                  ],
                  validator: (value) {
                    return null;
                    //return 'Not a valid adjective.';
                  },
                  decoration: InputDecoration(
                    filled: true,
                    labelText: '퇴소일',
                  ),
                  onChanged: (value) {
                    adjective = value;
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Text("퇴소사유"),
                    ),
                    Expanded(
                      child: ListTile(
                        title: Text("퇴소"),
                        leading: Radio(
                          value: "O",
                          groupValue: outReason,
                          onChanged: (String value) {
                            setState(() {
                              outReason = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: Text("전원"),
                        leading: Radio(
                          value: "T",
                          groupValue: outReason,
                          onChanged: (String value) {
                            setState(() {
                              outReason = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        rowColumn(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: TextFormField(
                  validator: (value) {
                    return null;
                    //return 'Not a valid adjective.';
                  },
                  decoration: InputDecoration(
                    filled: true,
                    labelText: '전원병원',
                  ),
                  onChanged: (value) {
                    adjective = value;
                  },
                ),
              ),
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
      ],
    );
  }
}
