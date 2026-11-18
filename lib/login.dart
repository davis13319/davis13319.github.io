import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:platform_info/platform_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'functions.dart';

class AuthPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  BuildContext? maincontext;
  FocusNode _pwFocusNode = FocusNode();
  final ValueNotifier<bool> _obscure = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _loading = ValueNotifier<bool>(false);
  static const Color _primary = Color(0xFF2563EB);
  static const Color _primaryDark = Color(0xFF1E3A8A);
  static const double _badgeSize = 92;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double headerHeight = (size.height * 0.28).clamp(170.0, 260.0);
    maincontext = context;

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(
                  height: headerHeight,
                  child: _header(),
                ),
                Expanded(
                  child: SafeArea(
                    top: false,
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: _badgeSize / 2 + 22),
                            child: _inputForm(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: headerHeight - _badgeSize / 2,
              left: 0,
              right: 0,
              child: Center(child: _logoBadge()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() => ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [_primary, _primaryDark],
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Positioned(
                top: -40,
                right: -30,
                child: _softCircle(140, 0.10),
              ),
              Positioned(
                bottom: -60,
                left: -40,
                child: _softCircle(160, 0.08),
              ),
            ],
          ),
        ),
      );

  Widget _softCircle(double size, double opacity) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(opacity),
        ),
      );

  Widget _logoBadge() => Container(
        width: _badgeSize,
        height: _badgeSize,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.16),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          // webUri + "/CI-PUSH.png" 는 서버에 파일이 없어서 SPA fallback 이
          // index.html 을 200 OK 로 대신 돌려준다 (진단 완료). 이미 assets/ 에
          // 번들된 로고를 직접 쓴다.
          child: Image.asset(
            "assets/CI-PUSH.png",
            fit: BoxFit.contain,
          ),
        ),
      );

  Future<void> _login(BuildContext context) async {
    List<dynamic> reslut = await postHttpNtx(
        procnm: "UP_IOS_CHK_ID_PW_S",
        params: "I_ID = " +
            _idController.text +
            ", I_PW = " +
            _passwordController.text +
            ", I_PAYCFRPWD = ");

    if (reslut.length > 0) {
      userId = _idController.text;

      // List<dynamic> result = await postHttpNtx(
      //   procnm: "UP_IOS_TEST_USER_S",
      //   params: "I_ID = " + userId,
      // );

      // if (result.isEmpty) {
      //   plistFileNm = "/manifest.plist";
      //   apkFileNm = "/gnuch_messenger.apk";
      // } else {
      //   plistFileNm = "/manifest-dev.plist";
      //   apkFileNm = "/gnuch_messenger_dev.apk";
      // }

      plistFileNm = "/manifest.plist";
      apkFileNm = "/gnuch_messenger.apk";
      //https://www.dropbox.com/scl/fi/c1bjnt6n71yxoo7jhk87v/manifest.plist?rlkey=ke0e6v6max0pja3evpg1tkkbi&st=l5nurtwr&dl=1
      //https://www.dropbox.com/scl/fi/qqiafrlicbzdr7rw4swf2/gnuch_messenger.apk?rlkey=kedwk1359o404sxeed6aj3zq7&st=a6b6tdxt&dl=1

      Navigator.of(context).pushReplacementNamed('downpage');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
          "사번 혹은 비밀번호가 잘못되었습니다",
          style: TextStyle(
            inherit: false,
            color: Colors.white.withOpacity(0.99),
          ),
        )),
      );
    }
  }

  void _submit(BuildContext context) async {
    if (_loading.value) return;
    if (_formKey.currentState?.validate() ?? false) {
      _loading.value = true;
      try {
        await _login(context);
      } finally {
        _loading.value = false;
      }
    }
  }

  InputDecoration _fieldDecoration(String label, IconData icon,
      {Widget? suffix}) {
    OutlineInputBorder border(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: color, width: width),
        );
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black54),
      floatingLabelStyle: const TextStyle(color: _primary),
      prefixIcon: Icon(icon, color: Colors.black45),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFFF3F6FB),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      enabledBorder: border(Colors.transparent),
      focusedBorder: border(_primary, 1.6),
      errorBorder: border(Colors.redAccent),
      focusedErrorBorder: border(Colors.redAccent, 1.6),
    );
  }

  Widget _authButton(BuildContext context) => ValueListenableBuilder<bool>(
        valueListenable: _loading,
        builder: (context, loading, _) => SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _primary,
              disabledBackgroundColor: _primary.withOpacity(0.6),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: loading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    "로그인",
                    style: TextStyle(
                      inherit: false,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
            onPressed: loading ? null : () => _submit(context),
          ),
        ),
      );

  Widget _inputForm(BuildContext context) {
    const TextStyle inputStyle = TextStyle(
      inherit: false,
      fontSize: 16,
      textBaseline: TextBaseline.alphabetic,
      color: Colors.black87,
    );
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            "가온알리미 설치 페이지",
            textAlign: TextAlign.center,
            style: TextStyle(
              inherit: false,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "직원 확인을 위해 사번과 가온 비밀번호를 입력해 주세요",
            textAlign: TextAlign.center,
            style: TextStyle(
              inherit: false,
              fontSize: 13,
              height: 1.4,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _idController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            decoration: _fieldDecoration("사번", Icons.person_outline),
            style: inputStyle,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return "사번을 입력해 주세요";
              }
              return null;
            },
            onFieldSubmitted: (inputValue) {
              FocusScope.of(maincontext!).requestFocus(_pwFocusNode);
            },
          ),
          const SizedBox(height: 14),
          ValueListenableBuilder<bool>(
            valueListenable: _obscure,
            builder: (context, obscure, _) => TextFormField(
              obscureText: obscure,
              focusNode: _pwFocusNode,
              controller: _passwordController,
              textInputAction: TextInputAction.done,
              style: inputStyle,
              decoration: _fieldDecoration(
                "비밀번호",
                Icons.lock_outline,
                suffix: IconButton(
                  icon: Icon(
                    obscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.black45,
                  ),
                  onPressed: () => _obscure.value = !obscure,
                ),
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "가온 비밀번호를 입력해주세요";
                }
                return null;
              },
              onFieldSubmitted: (inputValue) => _submit(maincontext!),
            ),
          ),
          const SizedBox(height: 26),
          _authButton(context),
        ],
      ),
    );
  }
}
