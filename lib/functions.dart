import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:web/web.dart' as web;

String webUri = "https://mapp.gnuch.co.kr";
// iOS 27 ATS(FCP v2.1) 요건으로 mapp.gnuch.co.kr의 구버전 TLS(OpenSSL 1.0.2k)가
// OTA 설치를 막는 문제의 임시 우회용 다운로드 호스트. 서버 TLS 업그레이드 후 제거 예정.
String downloadUri = "https://davis13319.github.io/downloads";
String userId = "";
String plistFileNm = "/manifest.plist";
String apkFileNm = "/gnuch_messenger.apk";

// iOS 27 미만임이 확실할 때만 기존 서버를 쓰고, 그 외(27 이상/판별 불가)는 GitHub 호스트를 쓴다.
// Safari는 UA의 Version/ 값이 iOS 메이저 버전과 같고, iOS 26부터 "iPhone OS" 값은 18_6으로 고정되므로
// OS 값은 17 이하일 때만 신뢰한다. (Chrome 등 타 브라우저 + iOS 18은 판별 불가 → GitHub)
String iosDownloadBase() {
  if (web.window.location.host.contains("davis13319.github.io")) {
    return downloadUri;
  }
  final ua = web.window.navigator.userAgent;
  final safari = RegExp(r'Version/(\d+)').firstMatch(ua);
  if (safari != null && int.parse(safari.group(1)!) < 27) return webUri;
  final os = RegExp(r'OS (\d+)_').firstMatch(ua);
  if (safari == null && os != null && int.parse(os.group(1)!) <= 17) {
    return webUri;
  }
  return downloadUri;
}

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
