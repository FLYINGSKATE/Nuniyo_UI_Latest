///Static Page
import 'dart:io';

import 'package:angel_broking_demo/extra_demo_screens/FlutCam.dart';
import 'package:angel_broking_demo/widgets/widgets.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';


class WebCamScreen extends StatefulWidget {
  const WebCamScreen({Key? key}) : super(key: key);

  @override
  _WebCamScreenState createState() => _WebCamScreenState();
}

class _WebCamScreenState extends State<WebCamScreen> with WidgetsBindingObserver, TickerProviderStateMixin {

  ///Camera
  CameraController? controller;
  XFile? imageFile;
  XFile? videoFile;
  VideoPlayerController? videoController;
  VoidCallback? videoPlayerListener;
  bool enableAudio = true;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _currentScale = 1.0;
  double _baseScale = 1.0;

  // Counting pointers (number of user fingers on screen)
  int _pointers = 0;
  /// Camera

  Color primaryColorOfApp = Color(0xff6A4EEE);

  bool makeStepsVisible = false;

  @override
  void initState() {
    super.initState();
    manageSteps();
    initializeCamera();
    _ambiguate(WidgetsBinding.instance)?.addObserver(this);
    controller = CameraController(cameras[1], ResolutionPreset.max);
    controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: Icon(Icons.ac_unit,color: Colors.black,),
        title: Text('Nuniyo',style: GoogleFonts.openSans(textStyle: TextStyle(color: Colors.black, letterSpacing: .5,fontWeight: FontWeight.bold)),),
        backgroundColor: Color(0xffF0ECFF),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.0,),
                Row(
                  children: [
                    SizedBox(width: 10.0,),
                    Text("Front Cam Verification (IPV)",textAlign:TextAlign.left,
                      style:GoogleFonts.openSans(textStyle: TextStyle(color: Colors.black,fontSize: 20.0,letterSpacing: .5,fontWeight: FontWeight.bold)),),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0,10,0,0),
                  child: Container(height: 5, width: 35,
                    decoration: BoxDecoration(
                        color: Color(0xff6A4EEE),
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                  ),
                ),
                SizedBox(height: 20.0,),
              ],
            ),
                TextButton(child: Text("Steps to do IPV:",style: GoogleFonts.openSans(
                  textStyle: TextStyle(color: Colors.black, letterSpacing: .5,fontSize: 16),
                ),),onPressed: (){makeStepsVisible = !makeStepsVisible;setState(() {

                });},),
                SizedBox(height: 20,),
                Visibility(visible:makeStepsVisible,child: Text("1.Click on Capture button to get the OTP on screen.\n\n2.Once you see the OTP the recording will start.\n\n3.Enter the OTP in the textbox below capture button.\n\n4.Once you enter the OTP recording will stop and it will get verified.\n",style: GoogleFonts.openSans(
                  textStyle: TextStyle(color: Colors.black, letterSpacing: .5,fontSize: 16),
                ),),),
                SizedBox(height: 20,),
                ///Card Box
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 100.0,
                    width: MediaQuery.of(context).size.width/2,
                    decoration: new BoxDecoration(
                      boxShadow: [ //background color of box
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5.0, // soften the shadow
                          spreadRadius: 2.0, //extend the shadow
                        )
                      ],
                    ),
                    child: Container(
                      height: 80,
                      color: Colors.black26,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: Text("1234",style: GoogleFonts.openSans(
                            textStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, letterSpacing: .5,fontSize: 24),
                          ),),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                ///Video Camera
                Expanded(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Center(
                        child: _cameraPreviewWidget(),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(
                        color:
                        controller != null && controller!.value.isRecordingVideo
                            ? Colors.redAccent
                            : Colors.grey,
                        width: 3.0,
                      ),
                    ),
                  ),
                ),
                _captureControlRowWidget(),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      _thumbnailWidget(),
                    ],
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    onPressed: () {Navigator.pushNamed(context, '/uploaddocumentscreen');},
                    color: primaryColorOfApp,
                    child: Text(
                        "Proceed",
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(color: Colors.white, letterSpacing: .5,fontSize: 16,fontWeight: FontWeight.bold),)
                    ),
                  ),
                ),
                //Retry Button
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                      child: Text("Retry",style: GoogleFonts.openSans(textStyle: TextStyle(decoration: TextDecoration.underline,fontSize: 18,fontWeight: FontWeight.bold,color:primaryColorOfApp, letterSpacing: .5),),),
                      onPressed: (){},),
                ),
                SizedBox(height: 10,),
                Text("type and scrambled it to make a type specimen book.",textAlign: TextAlign.center,style: GoogleFonts.openSans(
                  textStyle: TextStyle(color: Colors.grey,letterSpacing: .5,fontSize: 16),
                ),),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (controller == null || !controller!.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (controller != null) {
        controller = CameraController(cameras[1], ResolutionPreset.max);
      }
    }
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return const Text(
        'Tap a camera',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return Listener(
        onPointerDown: (_) => _pointers++,
        onPointerUp: (_) => _pointers--,
        child: CameraPreview(
          controller!,
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onScaleStart: _handleScaleStart,
                  onScaleUpdate: _handleScaleUpdate,
                  onTapDown: (details) => onViewFinderTap(details, constraints),
                );
              }),
        ),
      );
    }
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (controller == null) {
      return;
    }

    final CameraController cameraController = controller!;

    final offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    cameraController.setExposurePoint(offset);
    cameraController.setFocusPoint(offset);
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _baseScale = _currentScale;
  }

  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
    // When there are not exactly two fingers on screen don't scale
    if (controller == null || _pointers != 2) {
      return;
    }

    _currentScale = (_baseScale * details.scale)
        .clamp(_minAvailableZoom, _maxAvailableZoom);

    await controller!.setZoomLevel(_currentScale);
  }

  /// Display the thumbnail of the captured image or video.
  Widget _thumbnailWidget() {
    final VideoPlayerController? localVideoController = videoController;

    return Expanded(
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            localVideoController == null && imageFile == null
                ? Container()
                : SizedBox(
              child: (localVideoController == null)
                  ? Image.file(File(imageFile!.path))
                  : Container(
                child: Center(
                  child: AspectRatio(
                      aspectRatio:
                      localVideoController.value.size != null
                          ? localVideoController
                          .value.aspectRatio
                          : 1.0,
                      child: VideoPlayer(localVideoController)),
                ),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.pink)),
              ),
              width: 64.0,
              height: 64.0,
            ),
          ],
        ),
      ),
    );
  }

  /// Display the control bar with buttons to take pictures and record videos.
  Widget _captureControlRowWidget() {
    final CameraController? cameraController = controller;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[

        IconButton(
          icon: const Icon(Icons.videocam),
          color: Colors.blue,
          onPressed: cameraController != null &&
              cameraController.value.isInitialized &&
              !cameraController.value.isRecordingVideo
              ? onVideoRecordButtonPressed
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.stop),
          color: Colors.red,
          onPressed: cameraController != null &&
              cameraController.value.isInitialized &&
              cameraController.value.isRecordingVideo
              ? onStopButtonPressed
              : null,
        ),
      ],
    );
  }

  void onVideoRecordButtonPressed() {
    startVideoRecording().then((_) {
      if (mounted) {
        setState(() {});
        Future.delayed(Duration(seconds: 12), () {
          onStopButtonPressed();
        });
      }
    });
  }

  void onStopButtonPressed() {
    stopVideoRecording().then((file) {
      if (mounted) setState(() {});
      if (file != null) {
        showInSnackBar('Video recorded to ${file.path}');
        videoFile = file;
        //_startVideoPlayer();
      }
    });
  }

  /*Future<void> _startVideoPlayer() async {
    if (videoFile == null) {
      return;
    }

    final VideoPlayerController vController =
    VideoPlayerController.file(File(videoFile!.path));
    videoPlayerListener = () {
      if (videoController != null && videoController!.value.size != null) {
        // Refreshing the state to update video player with the correct ratio.
        if (mounted) setState(() {});
        videoController!.removeListener(videoPlayerListener!);
      }
    };
    vController.addListener(videoPlayerListener!);
    await vController.setLooping(true);
    await vController.initialize();
    await videoController?.dispose();
    if (mounted) {
      setState(() {
        imageFile = null;
        videoController = vController;
      });
    }
    await vController.play();
  }*/

  Future<void> startVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return;
    }

    if (cameraController.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return;
    }

    try {
      await cameraController.startVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return;
    }
  }

  Future<XFile?> stopVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return null;
    }

    try {
      return cameraController.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  void showInSnackBar(String message) {
    // ignore: deprecated_member_use
    _scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> manageSteps() async {
    ///REFERENCE
    //'/mobilevalidationscreen'
    //'/bankemailpanvalidationscreen'
    //'/uploaddocumentscreen'
    //'/personaldetailsscreen'
    //'/optionsscreen'
    //'/optionsscreen'
    //'/aadharkycscreen'
    //'/esignscreen'
    //'/webcamscreen'
    //'/congratsscreen'

    ///SET STEP ID HERE
    String ThisStepId = '/webcamscreen';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('STEP_ID',ThisStepId);

    String StepId = prefs.getString('STEP_ID');
    print("You are on STEP  :"+StepId);
  }

}

List<CameraDescription> cameras = [];

Future<void> initializeCamera() async {
  // Fetch the available cameras before initializing the app.
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    logError(e.code, e.description);
  }
}

/// This allows a value of type T or T? to be treated as a value of type T?.
///
/// We use this so that APIs that have become non-nullable can still be used
/// with `!` and `?` on the stable branch.
// TODO(ianh): Remove this once we roll stable in late 2021.
T? _ambiguate<T>(T? value) => value;