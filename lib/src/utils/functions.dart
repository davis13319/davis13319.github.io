import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter/cupertino.dart';

bool gUpdateCheckRequired = true;
const String webUri = "https://gnuchapp-web.gnuch.co.kr";
String userId = "214604";
String database = "D";

Future<List<dynamic>> postHttpNtx(
    {@required String procnm, @required dynamic params}) async {
  String paramsText = "";
  String connFileNm = "";

  if (database == "R") {
    connFileNm = "/execproc.php";
  } else if (database == "D") {
    connFileNm = "/execproc-dev.php";
  } else {
    connFileNm = "/execproc.php";
  }

  if (params is String) {
    paramsText = params;
  } else if (params is Map<String, String>) {
    params.forEach((String key, String value) {
      paramsText += key + " = " + value + ", ";
    });
    if (paramsText.length != 0) {
      paramsText = paramsText?.substring(0, paramsText.length - 2);
    }
  } else {
    return null;
  }
  Map<String, String> postParams = {
    "procnm": procnm,
    "params": paramsText,
  };
  Response response = await post(
    webUri + connFileNm,
    body: postParams,
  );
  return jsonDecode(response.body);
}

Future<int> postHttpTx(
    {@required String procnm, @required dynamic params}) async {
  String paramsText = "";
  String connFileNm = "";

  if (database == "R") {
    connFileNm = "/execproctx.php";
  } else if (database == "D") {
    connFileNm = "/execproctx-dev.php";
  } else {
    connFileNm = "/execproctx.php";
  }

  if (params is String) {
    paramsText = params;
  } else if (params is Map<String, String>) {
    params.forEach((key, value) {
      paramsText += key + " = " + value + ", ";
    });
    if (paramsText.length != 0) {
      paramsText = paramsText?.substring(0, paramsText.length - 2);
    }
  } else {
    return null;
  }
  Map<String, String> postParams = {
    "procnm": procnm,
    "params": paramsText,
  };
  Response response = await post(
    webUri + connFileNm,
    body: postParams,
  );

  return int.tryParse(response.body.trim());
}
