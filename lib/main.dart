import 'package:fingerprint/second_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FingerPrint(),
  ));
}

class FingerPrint extends StatefulWidget {
  @override
  _FingerPrintState createState() => _FingerPrintState();
}

class _FingerPrintState extends State<FingerPrint> {
  LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometric;
  List<BiometricType> _availableBiometric;
  String authorized = "Not authorized";

  Future<void> _checkBiometric() async {
    bool canCheckBiometric;
    try {
      canCheckBiometric = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _canCheckBiometric = canCheckBiometric;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometric;
    try {
      availableBiometric = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _availableBiometric = availableBiometric;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticateWithBiometrics(
        localizedReason: "Scan your finger print to authenticate",
        useErrorDialogs: true,
        stickyAuth: false,
      );
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      authorized =
          authenticated ? "Autherized success" : "Failed to authenticate";
      if (authenticated) {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => SecondPage()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _checkBiometric();
    _getAvailableBiometrics();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Color(0xFF00001A),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 24,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Login",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                vertical: 50,
              ),
              child: Column(
                children: [
                  Image.asset(
                    "assets/finger.jfif",
                    width: 120,
                  ),
                ],
              ),
            ),
            Text(
              "Fingerprint Auth",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Authentication using your fingerprint",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                height: 1.5,
              ),
            ),
            SizedBox(
              height: 100,
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(
                vertical: 15,
              ),
              child: RaisedButton(
                elevation: 0,
                color: Color(0xFF04A5ED),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                onPressed: _authenticate,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 24,
                  ),
                  child: Text(
                    "Authenticate",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
