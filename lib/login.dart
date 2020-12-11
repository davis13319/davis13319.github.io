import 'package:flutter/material.dart';
import 'package:platform_info/platform_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'functions.dart';

class AuthPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  BuildContext maincontext;
  final FocusNode _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    maincontext = context;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CustomPaint(
            size: size,
            painter: LoginBackground(
              isJoin: false,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              _logoImage,
              Stack(
                children: <Widget>[
                  _inputForm(size),
                  _authButton(size, context),
                ],
              ),
              // Container(
              //   height: size.height * 0.1,
              // ),
              // Text(
              //         "로그인하기" ,
              //         style: TextStyle(
              //             color: Colors.blue),
              //       ),
              // Container(
              //   height: size.height * 0.05,
              // )
            ],
          ),
        ],
      ),
    );
  }

  // void _register(BuildContext context) async {
  //   final AuthResult result = await FirebaseAuth.instance
  //       .createUserWithEmailAndPassword(
  //           email: _emailController.text, password: _passwordController.text);
  //   final FirebaseUser user = result.user;

  //   if (user == null) {
  //     final snacBar = SnackBar(
  //       content: Text('Please try again later.'),
  //     );
  //     Scaffold.of(context).showSnackBar(snacBar);
  //   }

//    Navigator.push(context,
//        MaterialPageRoute(builder: (context) => MainPage(email: user.email)));

  void _login(BuildContext context) async {
    List<dynamic> reslut = await postHttpNtx(
        procnm: "UP_IOS_CHK_ID_PW_S",
        params: "I_ID = " +
            _idController.text +
            ", I_PW = " +
            _passwordController.text +
            ", I_PAYCFRPWD = ") as List<dynamic>;
    if (reslut.length > 0) {
      if (platform.isIOS) {
        await launch(
            "itms-services://?action=download-manifest&url=" +
                webUri +
                "/manifest.plist",
            forceSafariVC: true);
      } else if (platform.isAndroid) {
        await launch(webUri + "/gnuchapp.apk", forceWebView: true);
      } else {
        await launch(
          webUri + "/gnuchapp.apk",
        );
      }
      Navigator.of(context).pushReplacementNamed('downpage');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("사번 혹은 비밀번호가 잘못되었습니다")),
      );
    }
  }

  Widget get _logoImage => Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 40, left: 24, right: 24),
          child: FittedBox(
            fit: BoxFit.contain,
            child: CircleAvatar(
              backgroundImage: NetworkImage(webUri + "/CI-PUSH.png"),
            ),
          ),
        ),
      );

  Widget _authButton(Size size, BuildContext context) => Positioned(
        left: size.width * 0.15,
        right: size.width * 0.15,
        bottom: 0,
        child: SizedBox(
          height: 50,
          child: RaisedButton(
              child: Text(
                "Login",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              onPressed: () {
                _login(context);
              }),
        ),
      );

  Widget _inputForm(Size size) {
    return Padding(
      padding: EdgeInsets.all(size.width * 0.05),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 6,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 12.0, right: 12, top: 12, bottom: 32),
          child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("직원 확인을 위해 사번과 가온 비밀번호를 입력해 주세요"),
                  Text(
                    platform.operatingSystem.toString(),
                  ),
                  TextFormField(
                    controller: _idController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.account_circle),
                      labelText: "사번",
                    ),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "사번을 입력해 주세요";
                      }
                      return null;
                    },
                    onFieldSubmitted: (inputValue) {
                      FocusScope.of(maincontext).requestFocus(_focusNode);
                    },
                  ),
                  TextFormField(
                    obscureText: true,
                    focusNode: _focusNode,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.vpn_key),
                      labelText: "비밀번호",
                    ),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "가온 비밀번호를 입력해주세요";
                      }
                      return null;
                    },
                    onFieldSubmitted: (inputValue) {
                      _login(maincontext);
                    },
                  ),
                  Container(
                    height: 8,
                  ),
                ],
              )),
        ),
      ),
    );
  }
}

class LoginBackground extends CustomPainter {
  LoginBackground({@required this.isJoin});

  final bool isJoin;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = isJoin ? Colors.red : Colors.blue;
    canvas.drawCircle(
        Offset(size.width * 0.5, size.height * 0.2), size.height * 0.5, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
