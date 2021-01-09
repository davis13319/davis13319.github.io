// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/src/api/api.dart';
import 'package:web_dashboard/src/app.dart';
import '../utils/functions.dart';
import 'package:http/http.dart';

class NewCategoryForm extends StatefulWidget {
  final Function(String zipcode, String addr, String bldgMgrNum) onChanged;

  NewCategoryForm({@required this.onChanged});

  @override
  _NewCategoryFormState createState() => _NewCategoryFormState();
}

class _NewCategoryFormState extends State<NewCategoryForm> {
  Category _category = Category('');

  @override
  Widget build(BuildContext context) {
    var api = Provider.of<AppState>(context).api;
    return EditCategoryForm(
      category: _category,
      onDone: (shouldInsert) {
        if (shouldInsert) {
          api.categories.insert(_category);
        }
        Navigator.of(context).pop();
      },
      onChanged: (zipcode, addr, bldgMgrNum) =>
          widget.onChanged(zipcode, addr, bldgMgrNum),
    );
  }
}

class EditCategoryForm extends StatefulWidget {
  final Category category;
  final ValueChanged<bool> onDone;
  final Function(String zipcode, String addr, String bldgMgrNum) onChanged;

  EditCategoryForm({
    @required this.category,
    @required this.onDone,
    @required this.onChanged,
  });

  @override
  _EditCategoryFormState createState() => _EditCategoryFormState();
}

class _EditCategoryFormState extends State<EditCategoryForm> {
  final _formKey = GlobalKey<FormState>();
  String stateCd = "01";
  String stateNm = "경상남도";
  List<DropdownMenuItem<String>> stateItems = List<DropdownMenuItem<String>>();
  List<dynamic> stateList;

  String detailStateCd = "000";
  String detailStateNm = "경상남도 전체";
  List<DropdownMenuItem<String>> detailStateItems =
      List<DropdownMenuItem<String>>();
  List<dynamic> detailStateList;

  List<dynamic> addrList = List<dynamic>();
  int currentAddrIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (stateItems.isNotEmpty) {
      return mainWidget(context);
    }

    return FutureBuilder(
      future: procGroup(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container();
        }
        if (snapshot.hasError) {
          String msg = snapshot.error;
        }
        stateItems.clear();
        stateList = jsonDecode(snapshot.data.body);

        for (dynamic stateInfo in stateList) {
          stateItems.add(
            DropdownMenuItem(
              value: stateInfo["COM_CD"],
              child: Text(
                stateInfo["COM_NM"],
              ),
            ),
          );
        }

        return mainWidget(context);
      },
    );
  }

  Future<Response> procGroup() async {
    getDetailState(state: stateNm);

    return post(
      webUri + (database == "R" ? "/execproc.php" : "/execproc-dev.php"),
      body: {
        "procnm": "UP_IOS_COM_CD_S",
        "params": "I_DIV_CD = LOC_GB",
      },
    );
  }

  void getDetailState({@required String state}) async {
    detailStateList = await postHttpNtx(
        procnm: "UP_IOS_GET_LOC_GB_D_S", params: "I_STATE = " + state);
    detailStateItems.clear();

    detailStateItems.add(
      DropdownMenuItem(
        value: "000",
        child: Text(
          state + " 전체",
        ),
      ),
    );

    for (dynamic detailState in detailStateList) {
      detailStateItems.add(
        DropdownMenuItem(
          value: detailState["LOC_GB_D_CD"],
          child: Text(
            detailState["LOC_GB_D_NM"],
          ),
        ),
      );
    }
  }

  Widget mainWidget(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          rowColumn(
            children: [
              Row(
                children: [
                  SizedBox(width: 5),
                  Container(
                    child: Text("시/도"),
                  ),
                  SizedBox(width: 5),
                  Container(
                    width: 140,
                    child: DropdownButton(
                      value: stateCd,
                      items: stateItems,
                      onChanged: (String newValue) async {
                        for (dynamic state in stateList) {
                          if (state["COM_CD"].toString() == newValue) {
                            stateNm = state["COM_NM"].toString();
                            break;
                          }
                        }

                        await getDetailState(state: stateNm);
                        detailStateCd = "0";

                        setState(() {
                          stateCd = newValue;
                          detailStateCd = "000";
                        });
                      },
                      underline: null,
                      isExpanded: true,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: 5),
                  Container(
                    child: Text("시/군/구"),
                  ),
                  SizedBox(width: 5),
                  Container(
                    width: 180,
                    child: DropdownButton(
                      value: detailStateCd,
                      items: detailStateItems,
                      onChanged: (String newValue) {
                        for (dynamic detailState in detailStateList) {
                          if (detailState["LOC_GB_D_NM"].toString() ==
                              newValue) {
                            detailStateNm = newValue;
                            break;
                          }
                        }
                        setState(() {
                          detailStateCd = newValue;
                        });
                      },
                      underline: null,
                      isExpanded: true,
                    ),
                  ),
                ],
              ),
              Container(
                width: 200,
                height: 39,
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: TextFormField(
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: "번지, 건물명",
                    ),
                    onFieldSubmitted: (value) async {
                      List<dynamic> listAddr;
                      if (value.isEmpty) return null;

                      listAddr = await postHttpNtx(
                          procnm: "UP_ZMM_POST_MST_BY_ADDR_S",
                          params: "I_AREA_NM = " +
                              value +
                              ", I_STATE_NM = " +
                              stateNm +
                              ", I_CITY_NM = " +
                              (detailStateNm.contains("전체")
                                  ? ""
                                  : detailStateNm));
                      setState(() {
                        addrList = listAddr;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          Container(
            child: Scrollbar(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(5),
                child: Container(
                  height: MediaQuery.of(context).size.height < 300
                      ? MediaQuery.of(context).size.height
                      : 300,
                  width: MediaQuery.of(context).size.width < 600
                      ? MediaQuery.of(context).size.width
                      : 600,
                  child: IntrinsicHeight(
                    child: IntrinsicWidth(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: 400,
                          minHeight: 200,
                          maxWidth: 400,
                          minWidth: 100,
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: addrList.length,
                          itemBuilder: (context, index) {
                            return addrRow(
                              context: context,
                              index: index,
                              lastItem: index + 1 == addrList.length,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: RaisedButton(
                  child: Text('취소'),
                  onPressed: () {
                    widget.onDone(false);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget rowColumn({List<Widget> children}) {
    if (MediaQuery.of(context).size.width > 640.0) {
      return Row(
        children: children,
      );
    }
    return SizedBox(
      height: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
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
                    Text(
                      addrList[index]["POSTNO_ADDR"],
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      addrList[index]["OLD_POSTNO_ADDR"],
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                child: InkWell(
                  onTap: () {
                    widget.onChanged(
                        addrList[index]["POSTNO_CD"],
                        addrList[index]["POSTNO_ADDR"],
                        addrList[index]["BLDG_MGR_NUM"]);
                    widget.onDone(false);
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
}
