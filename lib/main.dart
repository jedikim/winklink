import 'dart:async';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_flashlight/flutter_flashlight.dart';
import 'package:screen/screen.dart';
//import 'package:qr_flutter/src/types.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:torch_compat/torch_compat.dart';

void main() => runApp(MaterialApp(home: QRViewExample()));

const flashOn = 'FLASH ON';
const flashOff = 'FLASH OFF';
const frontCamera = 'FRONT CAMERA';
const backCamera = 'BACK CAMERA';

class QRViewExample extends StatefulWidget {
  const QRViewExample({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  var qrText = '';
  var flashState = flashOn;
  var cameraState = frontCamera;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//  final myController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final message =
    // ignore: lines_longer_than_80_chars
        'Dami Jung 삼성폰 ★★☆';
    final qrFutureBuilder = FutureBuilder(
      //future: _loadOverlayImage(),
      builder: (ctx, snapshot) {
        final size = 200.0;
        if (!snapshot.hasData) {
        //  return Container(width: size, height: size);
        }
        return CustomPaint(
          size: Size.square(size),
          painter: QrPainter(
            data: message,
            version: QrVersions.auto,
            eyeStyle: const QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: Color(0xff000000),
            ),
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: Color(0xff000000),
            ),

            embeddedImage: snapshot.data,
            embeddedImageStyle: QrEmbeddedImageStyle(
              size: Size.square(60),
            ),
          ),
        );
      },
    );
    return Scaffold(
      body: Column(
        children: <Widget>[

          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('Scanned Text: $qrText'),
                  Text('Your Text: $message'),
                  Center(
                    child: Container(
                      width: 260,
                      height: 300,
                      child: qrFutureBuilder,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: null,

            ),
          ),
        ],
      ),
    );
  }

  bool _isFlashOn(String current) {
    return flashOn == current;
  }

  bool _isBackCamera(String current) {
    return backCamera == current;
  }
  Future<void> onStop() async {
    print('onStop');
    //Flashlight.lightOn();
    await Flashlight.lightOff();
    //controller.toggleFlash();
    //await Future.delayed(Duration(milliseconds: 1000), (){this.controller.flipCamera(); });
    await Future.delayed(Duration(milliseconds: 2000), (){ qrText = '';controller?.resumeCamera();});
    //await Future.delayed(Duration(milliseconds: 600), (){ this.controller.flipCamera();});
//    this.controller.flipCamera();
//    this.controller.toggleFlash();
  }
  Future<void> onStart() async {
    print('onStart');
    //Flashlight.lightOn();
    await Flashlight.lightOn();
    //controller.toggleFlash();
    //await Future.delayed(Duration(milliseconds: 1000), (){this.controller.flipCamera(); });
    await Future.delayed(Duration(milliseconds: 10), (){ onStop();});
    //await Future.delayed(Duration(milliseconds: 600), (){ this.controller.flipCamera();});
//    this.controller.flipCamera();
//    this.controller.toggleFlash();
  }
  Future<void> onPrepare() async {
    // print('onStart');
    //Flashlight.lightOn();
//    await Flashlight.lightOn();
    //controller.toggleFlash();
    controller?.pauseCamera();
    //await Future.delayed(Duration(milliseconds: 1000), (){this.controller.flipCamera(); });
    await Future.delayed(Duration(milliseconds: 800), (){ onStart();});
    //await Future.delayed(Duration(milliseconds: 600), (){ this.controller.flipCamera();});
//    this.controller.flipCamera();
//    this.controller.toggleFlash();
  }

  void _onQRViewCreated(QRViewController controller)  {
    print('ok');
    this.controller = controller;
    if (this.controller != null) {
    }
    Screen.keepOn(true);
    print('ok2');
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        if (qrText == '') {
          //
          //controller?.pauseCamera();
          qrText = scanData;
          //controller.flipCamera();
          onPrepare();
          //Flashlight.lightOn();
          //controller.toggleFlash();
          Vibration.vibrate(duration: 200);


          //controller.toggleFlash();



        }
      });
    }
    );
    print('all');
  }

  @override
  void dispose() {
    controller.dispose();
    //  myController.dispose();
    super.dispose();
  }
}