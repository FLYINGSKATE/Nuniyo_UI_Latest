import 'package:angel_broking_demo/ApiRepository/localapis.dart';
import 'package:angel_broking_demo/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webviewx/webviewx.dart';

import '../globals.dart';

class BrowserViewX extends StatefulWidget {
  const BrowserViewX({Key? key}) : super(key: key);

  @override
  _BrowserViewXState createState() => _BrowserViewXState();

}

class _BrowserViewXState extends State<BrowserViewX> {

  late WebViewXController webviewController;
  String webURL = "";

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
            onPressed:(){Navigator.pushNamed(context, 'Personal');},
            //onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          TextButton(
            onPressed:() {
              Navigator.pushNamed(context, 'Personal');
              //await LocalApiRepo().UpdateStage_Id();
              //await ContinueToStep();
              },
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
      appBar: WidgetHelper().NuniyoAppBar(),
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
            callBack: (msg) => print("Waht is this ? "+msg.toString()),
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lead_id= prefs.getString(LEAD_ID_KEY);
    await webviewController.loadContent(
      'https://api.digitallocker.gov.in/public/oauth2/1/authorize?response_type=code&client_id=140FF210&state=$lead_id&redirect_uri=https://nuniyo.tech/digilocker/index.html',
      SourceType.url,
    );
  }

  Future<void> ContinueToStep() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ThisStepId = prefs.getString(STAGE_KEY);
    print("YOU LEFT ON THIS PAGE LAST TIME"+ThisStepId);
    Navigator.pushNamed(context,ThisStepId);
  }
}
