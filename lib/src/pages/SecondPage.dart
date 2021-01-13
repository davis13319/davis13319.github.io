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

  @override
  void clearState() {
    formState = null;
  }

  @override
  void formClear() {
    formState.setClear();
  }
}

class _SecondPageState extends State<SecondPage> {
  final _formKey = GlobalKey<FormState>();
  String adjective;
  String noun;
  BuildContext mainContext;

  String locCd = "01"; //확진번호(지역)
  String locNm = "경남";
  List<DropdownMenuItem<String>> locItems = List<DropdownMenuItem<String>>();

  TextEditingController diseaseNoController =
      TextEditingController(); //확진번호(숫자)
  TextEditingController ptntNmController = TextEditingController(); //환자명
  TextEditingController roomNoController = TextEditingController(); //격리실번호
  TextEditingController admiYmdController = TextEditingController(); //입소일
  TextEditingController dscYmdController = TextEditingController(); //퇴소일
  String dscReason = "O";
  TextEditingController trnsHosController = TextEditingController(); //전원병원
  String ptntNo = "";

  void saveFunction() async {
    var valid = _formKey.currentState.validate();
    if (!valid) {
      return;
    }
    Map<String, String> params = {
      "I_INPUT_GB": "D", //A:입소 D:퇴소
      "I_DIAG_LOC_CD": locCd,
      "I_DIAG_NO": diseaseNoController.text,
      "I_PTNT_NO": ptntNo,
      "I_DIAG_YMD": "",
      "I_SYMP_YMD": "",
      "I_HEALTH_CEN_NM": "",
      "I_HOS_NM": "",
      "I_ADMI_YMD": admiYmdController.text.replaceAll("/", ""),
      "I_ROOM_NO": roomNoController.text,
      "I_DSC_YMD": dscYmdController.text.replaceAll("/", ""),
      "I_DSC_RESN_CD": dscReason,
      "I_TRNS_HOS_NM": trnsHosController.text,
      "I_DEL_YN": "N",
      "I_ENT_ID": userId,
      "I_ENT_IP": "SACHUN",
    };

    Map rtn = await postHttpTxWithErr(
        procnm: "UP_IOS_COR_CUR_ADMI_INFO_IU2", params: params);

    if (rtn["O_RET"] as int != 0) {
      ScaffoldMessenger.of(mainContext).showSnackBar(SnackBar(
        content: Text("저장되었습니다"),
      ));
    } else {
      ScaffoldMessenger.of(mainContext).showSnackBar(SnackBar(
        content: Text(
            ("저장에 실패했습니다 초기화 후 다시 저장해 주세요\n" + (rtn["O_ERR_MSG"] ?? ""))
                .trim()),
      ));
    }
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
    mainContext = context;
    List<dynamic> locList;
    if (locItems.isNotEmpty) {
      return mainScaffold();
    }

    return FutureBuilder(
      future: procGroup(),
      builder: (BuildContext ctx, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container();
        }
        if (snapshot.hasError) {
          String msg = snapshot.error;
        }
        locItems.clear();
        locList = jsonDecode(snapshot.data.body);

        for (dynamic natInfo in locList) {
          locItems.add(
            DropdownMenuItem(
              value: natInfo["COM_CD"],
              child: Text(
                natInfo["SUB_VAL3"],
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
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              child: Text("지역"),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Container(
                                child: DropdownButton(
                                  value: locCd,
                                  items: locItems,
                                  onChanged: (String newValue) {
                                    setState(() {
                                      locCd = newValue;
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
                          controller: diseaseNoController,
                          validator: (value) {
                            return null;
                            //return 'Not a valid adjective.';
                          },
                          decoration: InputDecoration(
                            // filled: true,
                            labelText: '번호',
                          ),
                          onFieldSubmitted: (value) {
                            setAdmiInfo(locCd: locCd, diseaseNo: value);
                          },
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
                  controller: ptntNmController,
                  validator: (value) {
                    return null;
                    //return 'Not a valid adjective.';
                  },
                  decoration: InputDecoration(
                    // filled: true,
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
                  controller: roomNoController,
                  validator: (value) {
                    return null;
                    //return 'Not a valid adjective.';
                  },
                  decoration: InputDecoration(
                    // filled: true,
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
                  controller: admiYmdController,
                  inputFormatters: [
                    MaskTextInputFormatter(
                        mask: '####/##/##', filter: {"#": RegExp(r'[0-9]')})
                  ],
                  validator: (value) {
                    return null;
                    //return 'Not a valid adjective.';
                  },
                  decoration: InputDecoration(
                    // filled: true,
                    labelText: '입소일',
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
                  controller: dscYmdController,
                  inputFormatters: [
                    MaskTextInputFormatter(
                        mask: '####/##/##', filter: {"#": RegExp(r'[0-9]')})
                  ],
                  validator: (value) {
                    if (value.length < 8) {
                      return "입력값을 확인해 주세요";
                    }
                    return null;
                    //return 'Not a valid adjective.';
                  },
                  decoration: InputDecoration(
                    // filled: true,
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
                          groupValue: dscReason,
                          onChanged: (String value) {
                            setState(() {
                              dscReason = value;
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
                          groupValue: dscReason,
                          onChanged: (String value) {
                            setState(() {
                              dscReason = value;
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
                  controller: trnsHosController,
                  validator: (value) {
                    return null;
                    //return 'Not a valid adjective.';
                  },
                  decoration: InputDecoration(
                    // filled: true,
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

  void setAdmiInfo({String locCd, String diseaseNo, String ptntNo = ""}) async {
    List<dynamic> admiInfo;
    admiInfo = await postHttpNtx(
        procnm: "UP_IOS_COR_CUR_ADMI_S",
        params: "I_DIAG_LOC_CD = " +
            locCd +
            ", I_DIAG_NO = " +
            diseaseNo +
            ", I_PTNT_NO = " +
            ptntNo);

    if (admiInfo.length == 0) return;

    ptntNmController.text = admiInfo[0]["PTNT_NM"];
    roomNoController.text = admiInfo[0]["ROOM_NO"];
    admiYmdController.text = dateFormatter(admiInfo[0]["ADMI_YMD"]);
    dscYmdController.text = dateFormatter(admiInfo[0]["DSC_YMD"] ??
        (DateTime.now().year.toString() +
            DateTime.now().month.toString().padLeft(2, "0") +
            DateTime.now().day.toString().padLeft(2, "0")));
    trnsHosController.text = admiInfo[0]["TRNS_HOS_NM"];

    setState(() {
      dscReason = admiInfo[0]["DSC_RESN_CD"] ?? "O";
    });
  }

  void setClear() {
    diseaseNoController.text = "";
    ptntNmController.text = "";
    roomNoController.text = "";
    admiYmdController.text = "";
    dscYmdController.text = "";
    trnsHosController.text = "";

    setState(() {
      dscReason = "O";
      locCd = "01";
    });
  }
}
