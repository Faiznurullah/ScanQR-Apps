import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Scan QR",
      theme: ThemeData(
        primaryColor: Colors.redAccent,
      ),
      home: DqScreen(),
    );
  }
}

class DqScreen extends StatefulWidget {
  const DqScreen({super.key});

  @override
  State<DqScreen> createState() => _DqScreenState();
}

class _DqScreenState extends State<DqScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: "qr");
  QRViewController? controller;
  String result = "";

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _QRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData.code!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan QR"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _QRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                'Scan Result: ${result}',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (result.isNotEmpty) {
                      Clipboard.setData(ClipboardData(text: result));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Copied to Clipboard')),
                      );
                    }
                  },
                  child: Text('Copy Link'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
