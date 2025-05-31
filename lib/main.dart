import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ExpoReservationView extends StatefulWidget {
  // 修正点: コンストラクタに Key? key を追加し、super(key: key) を呼び出す
  const ExpoReservationView({Key? key}) : super(key: key);

  @override
  _ExpoReservationViewState createState() => _ExpoReservationViewState();
}

class _ExpoReservationViewState extends State<ExpoReservationView> {
  InAppWebViewController? webViewController;
  // TODO: 大阪万博のパビリオン予約サイトの正式なURLに置き換えてください
  final String targetUrl = "https://ticket.expo2025.or.jp/myticket_detail/"; // 例: "https://www.expo2025.or.jp/" (実際の予約サイトとは異なります)
  // final String targetUrl = "https://ticket.expo2025.or.jp/";

  final String customCSS = """
    .style_search_item_note__vExQQ,
    .style_event_links__jS3Q_,
    .style_search_item_row__moqWC:has(img[src*="calendar_none.svg"]) {
      display: none !important;
    }
  """;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("万博パビリオン予約（空きのみ）"),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(targetUrl)),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        onLoadStop: (controller, url) async {
          if (url.toString().startsWith(targetUrl)) { // ターゲットURLでのみCSSを適用
            String js = """
              var style = document.createElement('style');
              style.type = 'text/css';
              style.innerHTML = '${customCSS.replaceAll("\n", "")}';
              document.head.appendChild(style);
              // デバッグ用: CSSが適用されたか確認
              // alert('Custom CSS Injected!');
            """;
            await controller.evaluateJavascript(source: js);
          }
        },
        // 読み込みエラーのハンドリング（任意）
        onLoadError: (controller, url, code, message) {
          print("WebView load error: $url, code: $code, message: $message");
          // ここでエラー表示などを行うこともできます
        },
        onLoadHttpError: (controller, url, statusCode, description) {
          print("WebView HTTP error: $url, statusCode: $statusCode, description: $description");
        },
      ),
    );
  }
}

// main.dart でこのウィジェットを呼び出す例
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // こちらのコンストラクタも key を持つように修正
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expo Reservation App',
      home: ExpoReservationView(), // ここでKeyを渡す必要は通常ありません
    );
  }
}