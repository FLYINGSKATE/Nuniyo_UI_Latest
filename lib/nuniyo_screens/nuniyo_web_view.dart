import 'package:flutter/material.dart';
import 'package:webviewx/webviewx.dart';

class BrowserViewX extends StatefulWidget {
  const BrowserViewX({Key? key}) : super(key: key);


  @override
  _BrowserViewXState createState() => _BrowserViewXState();
}

class _BrowserViewXState extends State<BrowserViewX> {

  late WebViewXController webviewController;


  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    initializeWebView();
  }

  @override
  void dispose() {
    webviewController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit DigiLocker'),
        actions: <Widget>[
          TextButton(
            onPressed:(){Navigator.pushNamed(context, '/personaldetailsscreen');},
            //onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          TextButton(
            onPressed:(){Navigator.pushNamed(context, '/personaldetailsscreen');},
            //onPressed: () => Navigator.of(context).pop(true),
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        title: const Text('Nuniyo'),
        // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: WebViewX(
        key: const ValueKey('webviewx'),
        initialContent: '<h2>Please Wait.......</h2>',
        initialSourceType: SourceType.html,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        onWebViewCreated: (controller) {webviewController = controller;initializeWebView();},
        onPageStarted: (src) =>
            debugPrint('A new page has started loading: $src\n'),
        onPageFinished: (src) =>
            debugPrint('The page has finished loading: $src\n'),
        jsContent: const {
          EmbeddedJsContent(
            js: "function testPlatformIndependentMethod() { console.log('Hi from JS') }",
          ),
          EmbeddedJsContent(
            webJs:
            "function testPlatformSpecificMethod(msg) { TestDartCallback('Web callback says: ' + msg) }",
            mobileJs:
            "function testPlatformSpecificMethod(msg) { TestDartCallback.postMessage('Mobile callback says: ' + msg) }",
          ),
        },
        dartCallBacks: {
          DartCallback(
            name: 'TestDartCallback',
            callBack: (msg) => print(msg.toString()),
          )
        },
        webSpecificParams: const WebSpecificParams(
          printDebugInfo: true,
        ),
        mobileSpecificParams: const MobileSpecificParams(
          androidEnableHybridComposition: true,
        ),
        navigationDelegate: (navigation) {
          debugPrint(navigation.content.sourceType.toString());
          return NavigationDecision.navigate;
        },
      ),
    ), onWillPop: _onWillPop);
  }

  Future<void> initializeWebView() async {
    await webviewController.loadContent(
      'https://accounts.digitallocker.gov.in/signin/oauth_partner/%252Foauth2%252F1%252Fauthorize%253Fresponse_type%253Dcode%2526client_id%253D140FF210%2526state%253D123%2526redirect_uri%253Dhttps%25253A%25252F%25252Fnuniyo.tech%25252F%2526orgid%253D005685%2526txn%253D6142ec01cf20bfd78e500611oauth21631775745%2526hashkey%253D64fbbfafa80c49a7f3cfef7e6c7dbca5d6b1a417c89930f394ae107a2f9bf22b%2526requst_pdf%253DY%2526signup%253Dsignup',
      SourceType.url,
    );
  }

}
