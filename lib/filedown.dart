import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:platform_info/platform_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'functions.dart';

class FileDownPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Future.delayed(Duration(seconds: 1), () async {
          launch(
              "itms-services://?action=download-manifest&url=https://gnuchapp-web.gnuch.co.kr/manifest.plist");
        }),
        builder: (context, snapshot) {
          return Text("설치가 시작되지 않으면 이곳을 눌러주세요");
        },
      ),
    );
  }
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       body: Row(
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       Column(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Expanded(
  //             child: SizedBox(
  //               height: MediaQuery.of(context).size.height,
  //               width: MediaQuery.of(context).size.width,
  //               child: ListView(
  //                 children: [
  //                   Container(
  //                     width: MediaQuery.of(context).size.width > 450.0
  //                         ? 450.0
  //                         : (MediaQuery.of(context).size.width * 0.7),
  //                     height: MediaQuery.of(context).size.width > 450.0
  //                         ? 450.0
  //                         : (MediaQuery.of(context).size.width * 0.7),
  //                     child: Stack(
  //                       children: [
  //                         Positioned.fill(
  //                           child: Image(
  //                             image: AssetImage("Android_logo.png"),
  //                           ),
  //                         ),
  //                         Positioned.fill(child: InkWell(
  //                           onTap: () {
  //                             launch(
  //                                 "itms-services://?action=download-manifest&url=https://gnuchapp-web.gnuch.co.kr/manifest.plist");
  //                           },
  //                         )),
  //                       ],
  //                     ),
  //                   ),
  //                   Container(
  //                     width: MediaQuery.of(context).size.width * 0.7,
  //                     height: MediaQuery.of(context).size.width * 0.7,
  //                     child: Stack(
  //                       children: [
  //                         Positioned.fill(
  //                           child: Image(
  //                             image: AssetImage("apple_logo.png"),
  //                           ),
  //                         ),
  //                         Positioned.fill(child: InkWell(
  //                           onTap: () {
  //                             launch(webUri + "/gnuchapp.apk");
  //                           },
  //                         )),
  //                       ],
  //                     ),
  //                   ),
  //                   Text(platform.operatingSystem.toString() + " 로그인페이지"),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ],
  //   ));
  // }
}
