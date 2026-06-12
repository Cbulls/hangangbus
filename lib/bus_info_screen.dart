import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BusInfoScreen extends StatefulWidget {
  const BusInfoScreen({Key? key}) : super(key: key);

  @override
  State<BusInfoScreen> createState() => _BusInfoScreenState();
}

class _BusInfoScreenState extends State<BusInfoScreen> {
  late final WebViewController controller;
  bool isLoading = true;

  // 한강01번 버스의 카카오맵 URL
  // 실제 URL은 카카오맵에서 한강01번 버스 검색 후 얻을 수 있습니다
  final String busInfoUrl =
      'https://m.map.kakao.com/actions/busLineView?busID=1003200001&showMap=true';

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('페이지 로드 오류: ${error.description}')),
            );
          },
        ),
      )
      ..loadRequest(Uri.parse(busInfoUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                '순환',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text('한강01'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              controller.reload();
            },
            tooltip: '새로고침',
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoChip('발산역 ↔ 발산역', Icons.route),
              _buildInfoChip('배차간격 15분', Icons.schedule),
              _buildInfoChip('08:30 - 21:30', Icons.access_time),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey[700]),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
      ],
    );
  }
}
