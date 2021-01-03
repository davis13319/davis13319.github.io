// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'dart:convert';
import 'package:flutter/material.dart';
import '../utils/abstracts.dart';
import '../utils/functions.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:http/http.dart';

class FirstPage extends StatefulWidget implements ISaveUtil {
  static _FirstPageState formState = _FirstPageState();
  @override
  _FirstPageState createState() {
    if (formState == null) formState = _FirstPageState();
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

class _FirstPageState extends State<FirstPage> {
  final _formKey = GlobalKey<FormState>();
  String adjective;
  String noun;
  BuildContext mainContext;
  String gender = "M";
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
    List<dynamic> natList;
    if (menuItems.isNotEmpty) {
      return mainScaffold();
    }

    return FutureBuilder(
      future: post(
        webUri + "/execproc.php",
        body: {
          "procnm": "UP_IOS_COM_CD_S",
          "params": "I_DIV_CD = NAT",
        },
      ),
      builder: (BuildContext ctx, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container();
        }
        if (snapshot.hasError) {
          String msg = snapshot.error;
        }
        menuItems.clear();
        natList = jsonDecode(snapshot.data.body);

        for (dynamic natInfo in natList) {
          menuItems.add(
            DropdownMenuItem(
              value: natInfo["COM_CD"],
              child: Text(
                natInfo["COM_NM"],
              ),
            ),
          );
        }
        return mainScaffold();
      },
    );
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
                baseInfo(),
                SizedBox(
                  height: 30,
                ),
                inInfo(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget baseInfo() {
    return Column(
      children: [
        Container(
          child: Text("기본정보"),
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
                  inputFormatters: [
                    MaskTextInputFormatter(
                        mask: '######-#######', filter: {"#": RegExp(r'[0-9]')})
                  ],
                  decoration: InputDecoration(
                    filled: true,
                    labelText: '주민등록번호',
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
                      child: Text("성별"),
                    ),
                    Expanded(
                      child: ListTile(
                        title: Text("남자"),
                        leading: Radio(
                          value: "M",
                          groupValue: gender,
                          onChanged: (String value) {
                            setState(() {
                              gender = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: Text("여자"),
                        leading: Radio(
                          value: "F",
                          groupValue: gender,
                          onChanged: (String value) {
                            setState(() {
                              gender = value;
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
                    labelText: '생년월일',
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Text("국적"),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                        child: DropdownButton(
                          value: natCd,
                          items: menuItems,
                          onChanged: (String newValue) {
                            setState(() {
                              natCd = newValue;
                            });
                          },
                          underline: null,
                          isExpanded: true,
                        ),
                      ),
                    ),
                  ],
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
                    labelText: '연락처',
                  ),
                  onChanged: (value) {
                    adjective = value;
                  },
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.all(5.0),
          child: TextFormField(
            validator: (value) {
              return null;
              //return 'Not a valid adjective.';
            },
            decoration: InputDecoration(
              filled: true,
              labelText: '주소',
            ),
            onChanged: (value) {
              adjective = value;
            },
          ),
        ),
      ],
    );
  }

  Widget inInfo() {
    return Column(
      children: [
        Container(
          child: Text("입소정보"),
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
                    labelText: '지역',
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
                    labelText: '번호',
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
                    labelText: '확진일자',
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
                    labelText: '증상시작일',
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
                    labelText: '보건소',
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
                    labelText: '병원',
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
                    labelText: '입소일',
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
                    labelText: '격리실번호',
                  ),
                  onChanged: (value) {
                    adjective = value;
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
