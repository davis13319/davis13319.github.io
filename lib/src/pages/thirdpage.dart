// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'dart:convert';
import 'package:flutter/material.dart';
import '../utils/abstracts.dart';
import '../utils/functions.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:http/http.dart';

class ThirdPage extends StatefulWidget implements ISaveUtil {
  static _ThirdPageState formState = _ThirdPageState();
  final String searchMode; //N : 조회창 없음, 현재 재원인원만 조회,  A:조회창있음, 전부 조회가능

  ThirdPage({@required this.searchMode});

  @override
  _ThirdPageState createState() {
    if (formState == null) formState = _ThirdPageState();
    return formState;
  }

  @override
  void save() {
    formState.saveFunction();
  }

  @override
  void clearState() {
    formState = null;
  }

  @override
  void formClear() {
    formState.setClear();
  }
}

class _ThirdPageState extends State<ThirdPage> {
  final _formKey = GlobalKey<FormState>();

  void saveFunction() async {}

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

  Future<Response> procGroup() async {
    return post(
      webUri + (database == "R" ? "/execproc.php" : "/execproc-dev.php"),
      body: {
        "procnm": "UP_IOS_COM_CD_S",
        "params": "I_DIV_CD = LOC_GB",
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.searchMode == "A") {
      return mainScaffold();
    }

    // return FutureBuilder(
    //   future: procGroup(),
    //   builder: (BuildContext ctx, AsyncSnapshot<dynamic> snapshot) {
    //     if (snapshot.connectionState != ConnectionState.done) {
    //       return Container();
    //     }
    //     if (snapshot.hasError) {
    //       String msg = snapshot.error;
    //     }
    //     locItems.clear();
    //     locList = jsonDecode(snapshot.data.body);

    //     for (dynamic natInfo in locList) {
    //       locItems.add(
    //         DropdownMenuItem(
    //           value: natInfo["COM_CD"],
    //           child: Text(
    //             natInfo["SUB_VAL3"],
    //           ),
    //         ),
    //       );
    //     }
    //     return mainScaffold();
    //   },
    // );
  }

  Widget mainScaffold() {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: mainWidget(searchMode: widget.searchMode),
          ),
        ),
      ),
    );
  }

  Widget mainWidget({String searchMode}) {
    if (searchMode == "A") {
      return Column(
        children: [
          searchBar(),
          Divider(),
          searchList(),
        ],
      );
    } else {
      return Column(
        children: [
          searchList(),
        ],
      );
    }
  }

  Widget searchList() {
    return Container(
      child: Row(
        children: [
          Row(
            children: [
              // Text("조회기간"),
              //지역, 조회기간
            ],
          )
        ],
      ),
    );
  }

  Widget searchBar() {
    return Container();
  }

  Widget addrRow(
      {@required BuildContext context,
      @required int index,
      @required bool lastItem}) {
    Widget row = IntrinsicHeight(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 100,
          minHeight: 40,
          // maxWidth: 400,
          // minWidth: 100,
        ),
        child: Container(
          // height: 30,
          width: double.infinity,
          child: Stack(
            children: [
              Positioned.fill(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   addrList[index]["POSTNO_ADDR"],
                    //   textAlign: TextAlign.left,
                    // ),
                    // Text(
                    //   addrList[index]["OLD_POSTNO_ADDR"],
                    //   textAlign: TextAlign.left,
                    // ),
                  ],
                ),
              ),
              Positioned.fill(
                child: InkWell(
                  onTap: () {
                    // widget.onChanged(
                    //     addrList[index]["POSTNO_CD"],
                    //     addrList[index]["POSTNO_ADDR"],
                    //     addrList[index]["BLDG_MGR_NUM"]);
                    // widget.onDone(false);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (lastItem) {
      return row;
    }

    return Column(
      children: <Widget>[
        row,
        Padding(
          padding: const EdgeInsets.only(
            left: 0,
            right: 0,
          ),
          child: Container(
            height: 1,
            color: ThemeData.light().dividerColor,
          ),
        ),
      ],
    );
  }

  void setClear() {}
}
