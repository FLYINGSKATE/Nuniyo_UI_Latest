//Aadhar KYC

import 'package:angel_broking_demo/nuniyo_screens/nuniyo_web_view.dart';
import 'package:angel_broking_demo/extra_demo_screens/web_view.dart';
import 'package:angel_broking_demo/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';


class AadharKYCScreen extends StatefulWidget {
  const AadharKYCScreen({Key? key}) : super(key: key);

  @override
  _AadharKYCScreenState createState() => _AadharKYCScreenState();
}

class _AadharKYCScreenState extends State<AadharKYCScreen> {

  Color primaryColorOfApp = Color(0xff6A4EEE);

  @override
  void initState() {
    super.initState();
    manageSteps();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
                WidgetHelper().DetailsTitle('Aadhar KYC'),
                Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",style: GoogleFonts.openSans(
                  textStyle: TextStyle(color: Colors.black, letterSpacing: .5,fontSize: 16),
                ),),
                SizedBox(height: 20,),
                Container(
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BrowserViewX()),
                      );
                      //Navigator.pushNamed(context, '/personaldetailsscreen');
                    },
                    color: primaryColorOfApp,
                    child: Text(
                        "Continue to DigiLocker",
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(color: Colors.white, letterSpacing: .5,fontSize: 16,fontWeight: FontWeight.bold),)
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",style: GoogleFonts.openSans(
                  textStyle: TextStyle(color: Colors.black, letterSpacing: .5,fontSize: 16),
                ),),
              ],
            ),
          ),
        ),
      ),
    );
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
    String ThisStepId = '/aadharkycscreen';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('STEP_ID',ThisStepId);

    String StepId = prefs.getString('STEP_ID');
    print("You are on STEP  :"+StepId);
  }
}
