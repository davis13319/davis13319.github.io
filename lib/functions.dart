import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

String webUri = "https://mapp.gnuch.co.kr";
// iOS 27 ATS(FCP v2.1) 요건으로 mapp.gnuch.co.kr의 구버전 TLS(OpenSSL 1.0.2k)가
// OTA 설치를 막는 문제의 임시 우회용 다운로드 호스트. 서버 TLS 업그레이드 후 제거 예정.
String downloadUri = "https://davis13319.github.io/downloads";
String userId = "";
String plistFileNm = "";
String apkFileNm = "";

Future<List<dynamic>> postHttpNtx(
    {required String procnm, required params}) async {
  String paramsText = '';

  if (params is String) {
    paramsText = params;
  } else if (params is Map<String, String>) {
    params.forEach((key, value) {
      paramsText += key + " = " + value + ", ";
    });
    if (paramsText.length != 0) {
      paramsText = paramsText.substring(0, paramsText.length - 2);
    }
  } else {
    return [];
  }
  Map<String, String> postParams = {
    "procnm": procnm,
    "params": paramsText,
  };
  Response response = await post(
    Uri.parse(webUri + "/execproc.php"),
    body: postParams,
  );
  return jsonDecode(response.body);
}

Future<int> postHttpTx({required String procnm, required params}) async {
  String paramsText = '';

  if (params is String) {
    paramsText = params;
  } else if (params is Map<String, String>) {
    params.forEach((key, value) {
      paramsText += key + " : " + value + ", ";
    });
    if (paramsText.length != 0) {
      paramsText = paramsText.substring(0, paramsText.length - 2);
    }
  } else {
    return -1;
  }
  Map<String, String> postParams = {
    "procnm": procnm,
    "params": paramsText,
  };
  Response response = await post(
    Uri.parse(webUri + "/execproctx.php"),
    body: postParams,
  );

  return int.tryParse(response.body.trim()) ?? -1;
}
