// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/material.dart';

class WebRTCVirtualBackground extends StatefulWidget {
  const WebRTCVirtualBackground({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WebRTCVirtualBackgroundState createState() =>
      _WebRTCVirtualBackgroundState();
}

class _WebRTCVirtualBackgroundState extends State<WebRTCVirtualBackground> {
  html.VideoElement? _localVideoElement;

  @override
  void initState() {
    super.initState();
//    _initializeVideoElement();
  }

  Future<void> _initializeVideoElement() async {
    final mediaConstraints = {'video': true, 'audio': false};

    // カメラの映像を取得
    final stream = await html.window.navigator.mediaDevices!
        .getUserMedia(mediaConstraints);

    // VideoElementにカメラ映像を設定
    _localVideoElement = html.VideoElement()
      ..autoplay = true
      ..muted = true
      ..srcObject = stream
      ..style.position = 'absolute' // ビデオ要素を絶対配置
      ..style.top = '0'
      ..style.left = '0'
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.zIndex = '1000'; // 他の要素の上に表示する

    // ビデオ要素をDOMに追加
    html.document.body!.append(_localVideoElement!);

    setState(() {
      // ビデオが表示されたことを通知
    });
  }

  @override
  void dispose() {
    super.dispose();
    // ビデオ要素をDOMから削除
    _localVideoElement?.remove();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeVideoElement();
    });

    return Scaffold(
      appBar: AppBar(title: const Text('WebRTC Virtual Background')),
      body: Center(
        child: _localVideoElement != null
            ? const Text('カメラ映像が表示されています')
            : const CircularProgressIndicator(),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: WebRTCVirtualBackground()));
}
