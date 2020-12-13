import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:platform_info/platform_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'functions.dart';

class FileDownPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String installText;
    if (platform.isIOS) {
      installText = "설치";
    } else {
      installText = "다운로드";
    }

    // if (platform.isMacOS || platform.isIOS) {
    //   launch(
    //       "itms-services://?action=download-manifest&url=" +
    //           webUri +
    //           "/manifest.plist",
    //       universalLinksOnly: true);
    //   launch("itms-services://?action=download-manifest&url=" +
    //       webUri +
    //       "/manifest.plist");
    // } else if (platform.isAndroid) {
    //   launch(webUri + "/gnuchapp.apk", forceWebView: true);
    // } else {
    //   launch(
    //     webUri + "/gnuchapp.apk",
    //   );
    // }
    return FutureBuilder(
      future: Future.delayed(
        Duration(seconds: 2),
        // () async {
        //   if (platform.isMacOS || platform.isIOS) {
        //     return await launch(
        //         "itms-services://?action=download-manifest&url=" +
        //             webUri +
        //             "/manifest.plist");
        //   } else if (platform.isAndroid) {
        //     return await launch(webUri + "/gnuchapp.apk", forceWebView: true);
        //   } else {
        //     return await launch(
        //       webUri + "/gnuchapp.apk",
        //     );
        //   }
        // },
      ),
      builder: (context, snapshot) {
        return Scaffold(
          body: Row(
            children: [
              RichText(
                text: new TextSpan(children: [
                  TextSpan(
                    text: installText + "가 시작되지 않으면 ",
                    style: TextStyle(color: Colors.black),
                  ),
                  TextSpan(
                      text: "이곳",
                      style: TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          if (platform.isMacOS || platform.isIOS) {
                            await launch(
                              "itms-services://?action=download-manifest&url=" +
                                  webUri +
                                  "/manifest.plist",
                            );
                            await launch(
                                "itms-services://?action=download-manifest&url=" +
                                    webUri +
                                    "/manifest.plist",
                                universalLinksOnly: true);
                          } else if (platform.isAndroid) {
                            await launch(webUri + "/gnuchapp.apk",
                                forceWebView: true);
                          } else {
                            await launch(
                              webUri + "/gnuchapp.apk",
                            );
                          }
                        }),
                  TextSpan(
                    text: "을 눌러주세요",
                    style: TextStyle(color: Colors.black),
                  ),
                  TextSpan(
                      text: "저곳",
                      style: TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          if (platform.isMacOS || platform.isIOS) {
                            await launch(
                                "itms-services://?action=download-manifest&url=" +
                                    webUri +
                                    "/manifest.plist",
                                universalLinksOnly: true);
                          } else if (platform.isAndroid) {
                            await launch(webUri + "/gnuchapp.apk",
                                forceWebView: true);
                          } else {
                            await launch(
                              webUri + "/gnuchapp.apk",
                            );
                          }
                        }),
                  TextSpan(
                      text: "요곳",
                      style: TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          if (platform.isMacOS || platform.isIOS) {
                            await launch(
                                "itms-services://?action=download-manifest&url=" +
                                    webUri +
                                    "/manifest.plist");
                          } else if (platform.isAndroid) {
                            await launch(webUri + "/gnuchapp.apk",
                                forceWebView: true);
                          } else {
                            await launch(
                              webUri + "/gnuchapp.apk",
                            );
                          }
                        }),
                  TextSpan(
                      text: "그곳1",
                      style: TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          if (platform.isMacOS || platform.isIOS) {
                            await launch(
                                "itms-services://?action=download-manifest&url=" +
                                    webUri +
                                    "/manifest.plist");
                          } else if (platform.isAndroid) {
                            await launch(webUri + "/gnuchapp.apk",
                                forceWebView: true);
                          } else {
                            await launch(
                              webUri + "/gnuchapp.apk",
                            );
                          }
                        }),
                ]),
              )
            ],
          ),
        );
      },
    );
  }
}
