// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'dart:convert';
import 'package:flutter/material.dart';
import '../utils/abstracts.dart';
import '../utils/functions.dart';
import '../widgets/dialogs.dart';
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

  @override
  void clearState() {
    // formState.setClear();
    formState = null;
  }

  @override
  void formClear() {
    formState.setClear();
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

  String locCd = "01"; //확진번호(지역)
  String locNm = "경남";
  List<DropdownMenuItem<String>> locItems = List<DropdownMenuItem<String>>();

  TextEditingController zipCodeController = TextEditingController(); //우편번호
  TextEditingController addrController = TextEditingController(); //주소
  TextEditingController detailAddrController = TextEditingController(); //상세주소
  String bldgMgrNum = ""; //주소 건물관리번호(키값)

  TextEditingController resNumController = TextEditingController(); //주민등록번호
  TextEditingController birthYmdController = TextEditingController(); //생일
  TextEditingController ptntNmController = TextEditingController(); //환자명
  TextEditingController hpNoController = TextEditingController(); //전화번호
  String ptntNo = "0";

  TextEditingController diseaseNoController =
      TextEditingController(); //확진번호(숫자)
  TextEditingController defYmdController = TextEditingController(); //확진일자
  TextEditingController symYmdController = TextEditingController(); //증상시작일
  TextEditingController admiYmdController = TextEditingController(); //입소일
  TextEditingController healthNmController = TextEditingController(); //보건소
  TextEditingController hosNmController = TextEditingController(); //병원
  TextEditingController roomNoController = TextEditingController(); //격리실번호

  void saveFunction() async {
    int rtn = 0, rtn2 = 0;
    Map<String, String> params = {
      "I_PTNT_NO": ptntNo,
      "I_PTNT_NO_IU_GB": (ptntNo == "0" ? "I" : "U"),
      "I_RES_NO1": resNumController.text.substring(0, 6),
      "I_RES_NO2": resNumController.text.substring(7, 14),
      "I_SEX": gender,
      "I_BIRTH_YMD": birthYmdController.text.replaceAll("/", ""),
      "I_PTNT_NM": ptntNmController.text,
      "I_NAT": natCd,
      "I_HP_NO": hpNoController.text,
      "I_POSTNO_CD": zipCodeController.text,
      "I_BLDG_MGR_NUM": bldgMgrNum,
      "I_DTL_ADDR": detailAddrController.text,
      "I_ENT_ID": userId,
      "I_ENT_IP": "SACHUN",
    };

    rtn =
        await postHttpTx(procnm: "UP_IOS_COR_CUR_PTNT_INFO_IU", params: params);

    params = {
      "I_INPUT_GB": "A", //A:입소 D:퇴소
      "I_DIAG_LOC_CD": locCd,
      "I_DIAG_NO": diseaseNoController.text,
      "I_PTNT_NO": rtn.toString().padLeft(10, "0"),
      "I_DIAG_YMD": defYmdController.text.replaceAll("/", ""),
      "I_SYMP_YMD": symYmdController.text.replaceAll("/", ""),
      "I_HEALTH_CEN_NM": healthNmController.text,
      "I_HOS_NM": hosNmController.text,
      "I_ADMI_YMD": admiYmdController.text.replaceAll("/", ""),
      "I_ROOM_NO": roomNoController.text.padLeft(2, "0"),
      "I_DSC_YMD": "",
      "I_DSC_RESN_CD": "",
      "I_TRNS_HOS_NM": "",
      "I_DEL_YN": "N",
      "I_ENT_ID": userId,
      "I_ENT_IP": "SACHUN",
    };

    rtn2 =
        await postHttpTx(procnm: "UP_IOS_COR_CUR_ADMI_INFO_IU", params: params);

    ScaffoldMessenger.of(mainContext).showSnackBar(SnackBar(
      content: Text(rtn.toString() + " " + rtn2.toString()),
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

  Future<Response> procGroup() async {
    List<dynamic> locList;

    locList = await postHttpNtx(
        procnm: "UP_IOS_COM_CD_S",
        params: "I_DIV_CD = LOC_GB") as List<dynamic>;

    locItems.clear();
    for (dynamic locInfo in locList) {
      locItems.add(
        DropdownMenuItem(
          value: locInfo["COM_CD"],
          child: Text(
            locInfo["SUB_VAL3"],
          ),
        ),
      );
    }

    return post(
      webUri + (database == "R" ? "/execproc.php" : "/execproc-dev.php"),
      body: {
        "procnm": "UP_IOS_COM_CD_S",
        "params": "I_DIV_CD = NAT",
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    mainContext = context;
    List<dynamic> natList;
    if (menuItems.isNotEmpty) {
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
                  controller: resNumController,
                  validator: (value) {
                    return null;
                    //return 'Not a valid adjective.';
                  },
                  inputFormatters: [
                    MaskTextInputFormatter(
                        mask: '######-#######', filter: {"#": RegExp(r'[0-9]')})
                  ],
                  decoration: InputDecoration(
                    // filled: true,
                    labelText: '주민등록번호',
                  ),
                  onChanged: (value) {
                    if (value.length == 14) {
                      setUserInfo(value.replaceAll("-", ""));
                    }
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
                  controller: birthYmdController,
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
                  controller: hpNoController,
                  validator: (value) {
                    return null;
                    //return 'Not a valid adjective.';
                  },
                  decoration: InputDecoration(
                    // // filled: true,
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
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Container(
                      child: Text("주소"),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 60,
                      child: TextFormField(
                        controller: zipCodeController,
                        enabled: false,
                        validator: (value) {
                          return null;
                        },
                        decoration: InputDecoration(
                            // filled: true,
                            ),
                        onChanged: (value) {},
                      ),
                    ),
                    RaisedButton(
                      child: Text("주소찾기"),
                      onPressed: () {
                        showDialog<NewCategoryDialog>(
                          context: context,
                          builder: (context) => NewCategoryDialog(
                            onChanged: (zipcode, addr, pBldgMgrNum) {
                              zipCodeController.text = zipcode;
                              addrController.text = addr;
                              bldgMgrNum = pBldgMgrNum;
                            },
                          ),
                        );
                      },
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: TextFormField(
                          controller: addrController,
                          enabled: false,
                          validator: (value) {
                            return null;
                            //return 'Not a valid adjective.';
                          },
                          decoration: InputDecoration(
                              // filled: true,
                              ),
                          onChanged: (value) {
                            adjective = value;
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
        Padding(
          padding: EdgeInsets.all(5.0),
          child: TextFormField(
            controller: detailAddrController,
            validator: (value) {
              return null;
              //return 'Not a valid adjective.';
            },
            decoration: InputDecoration(
              // filled: true,
              labelText: '상세주소',
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
                  controller: defYmdController,
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
                  controller: symYmdController,
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
                  controller: healthNmController,
                  validator: (value) {
                    return null;
                    //return 'Not a valid adjective.';
                  },
                  decoration: InputDecoration(
                    // filled: true,
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
                  controller: hosNmController,
                  validator: (value) {
                    return null;
                    //return 'Not a valid adjective.';
                  },
                  decoration: InputDecoration(
                    // filled: true,
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
          ],
        ),
      ],
    );
  }

  void setUserInfo(String resNo) async {
    List<dynamic> ptntInfo;
    ptntInfo = await postHttpNtx(
        procnm: "UP_IOS_PTNT_INFO_S", params: "I_RES_NO = " + resNo);

    if (ptntInfo.length == 0) {
      String dateText = MaskTextInputFormatter(
              mask: '####/##/##', filter: {"#": RegExp(r'[0-9]')})
          .maskText(int.parse(resNo.substring(0, 2)) > 1
              ? ("19" + resNo)
              : ("20" + resNo));
      birthYmdController.text = dateText;

      setState(() {
        gender = resNo.substring(6, 7).contains(RegExp(r'[2|4]')) ? "F" : "M";
      });
      return;
    }

    birthYmdController.text = ptntInfo[0]["BIRTH_YMD"];
    ptntNmController.text = ptntInfo[0]["PTNT_NM"];
    hpNoController.text = ptntInfo[0]["HP_NO"];
    detailAddrController.text = ptntInfo[0]["DTL_ADDR"];
    zipCodeController.text = ptntInfo[0]["POSTNO_CD"];
    addrController.text = ptntInfo[0]["POSTNO_ADDR"];
    ptntNo = ptntInfo[0]["PTNT_NO"];
    bldgMgrNum = ptntInfo[0]["BLDG_MGR_NUM"];

    setState(() {
      gender = ptntInfo[0]["SEX"];
      natCd = ptntInfo[0]["NAT"];
    });
  }

  void setClear() {
    resNumController.text = "";
    birthYmdController.text = "";
    ptntNmController.text = "";
    hpNoController.text = "";
    detailAddrController.text = "";
    zipCodeController.text = "";
    addrController.text = "";
    ptntNo = "";
    bldgMgrNum = "";

    setState(() {
      gender = "M";
      natCd = "KR";
      locCd = "01";
    });
  }
}
