import 'package:flutter/material.dart';

class ScanQrcodePage extends StatelessWidget {
  const ScanQrcodePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
      ),
      body: const Center(
        child: Text('Scan QR Code'),
      ),
    );
  }
}
