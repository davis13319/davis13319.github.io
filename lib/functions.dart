import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

const String webUri = "https://gnuchapp-web.gnuch.co.kr";
Future<List<dynamic>> postHttpNtx(
    {@required String procnm, @required params}) async {
  String paramsText;

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
    webUri + "/execproc.php",
    body: postParams,
  );
  return jsonDecode(response.body);
}

Future<int> postHttpTx({@required String procnm, @required params}) async {
  String paramsText;

  if (params is String) {
    paramsText = params;
  } else if (params is Map<String, String>) {
    params.forEach((key, value) {
      paramsText += key + " : " + value + ", ";
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
    webUri + "/execproctx.php",
    body: postParams,
  );

  return int.tryParse(response.body.trim());
}
