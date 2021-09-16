//Mobile Validation

import 'dart:async';

import 'package:angel_broking_demo/ApiRepository/apirepository.dart';
import 'package:angel_broking_demo/nuniyo_custom_icons.dart';
import 'package:angel_broking_demo/widgets/widgets.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MobileValidationLoginScreen extends StatefulWidget {
  const MobileValidationLoginScreen({Key? key}) : super(key: key);

  @override
  _MobileValidationLoginScreenState createState() => _MobileValidationLoginScreenState();
}

class _MobileValidationLoginScreenState extends State<MobileValidationLoginScreen> {

  late String OTPFromApi;
  late String phoneNumberString;

  SharedPreferences? preferences;

  bool isValidOTP = false;
  bool isPhoneNumberValid = false;
  bool enableOTPButton = true;

  String OTPErrorText = "Wrong OTP";
  bool showOTPErrorText = false;

  final interval = const Duration(seconds: 1);

  final int _resendOTPIntervalTime = 3;

  int currentSeconds = 0;

  int howManyTimesResendOTPPressed = 0;

  bool showReferralTextField = false;

  String get resendOTPButtonText =>
      'Wait for :${((_resendOTPIntervalTime - currentSeconds) ~/ 60).toString().padLeft(2, '0')}: ${((_resendOTPIntervalTime - currentSeconds) % 60).toString().padLeft(2, '0')}';


  Color primaryColorOfApp = Color(0xff6A4EEE);

  late FocusNode _phoneNumberFocusNode,_otpFocusNode,_referralCodeNode;

  @override
  void initState() {
    super.initState();
    initializePreference().whenComplete((){
      setState(() {});
    });
    _phoneNumberFocusNode = FocusNode();
    _otpFocusNode = FocusNode();
    _referralCodeNode = FocusNode();
  }

  void _requestPhoneFocus(){
    setState(() {
      FocusScope.of(context).requestFocus(_phoneNumberFocusNode);
    });
  }

  void _requestOtpFocus(){
    setState(() {
      FocusScope.of(context).requestFocus(_otpFocusNode);
    });
  }

  void _requestReferralCodeFocus(){
    setState(() {
      FocusScope.of(context).requestFocus(_referralCodeNode);
    });
  }

  @override
  void dispose() {
    _phoneNumberFocusNode.dispose();
    _otpFocusNode.dispose();
    _referralCodeNode.dispose();
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
                WidgetHelper().DetailsTitle('Registration'),
                Row(
                  children: [
                    Text("Already have an account ? ",style: GoogleFonts.openSans(
                      textStyle: TextStyle(color: Colors.black, letterSpacing: .5,fontSize: 16,fontWeight: FontWeight.bold),
                    ),),
                    TextButton(
                      onPressed: (){
                        Navigator.pushNamed(context, '/personaldetailsscreen');
                      },
                      child:Text("Log In",style: GoogleFonts.openSans(
                      textStyle: TextStyle(decoration: TextDecoration.underline,fontSize: 16,fontWeight: FontWeight.bold,color: primaryColorOfApp, letterSpacing: .5),
                    ),),)
                  ],
                ),
                SizedBox(height: 20,),
                Flexible(
                    child: TextField(
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                      cursorColor: primaryColorOfApp,
                      style :GoogleFonts.openSans(textStyle: TextStyle(color: Colors.black, letterSpacing: .5,fontSize: 14,fontWeight: FontWeight.bold)),
                      focusNode: _phoneNumberFocusNode,
                      onTap: _requestPhoneFocus,
                      decoration: InputDecoration(
                        counter: Offstage(),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.fromLTRB(0.0,0.0,20.0,0.0),
                          child: Icon(NuniyoCustomIcons.mobile_number_black,size: 26.0,color: _phoneNumberFocusNode.hasFocus ?primaryColorOfApp : Colors.grey,),
                        ),
                        labelText: _phoneNumberFocusNode.hasFocus ? 'Mobile Number' : 'Enter Mobile Number',
                          labelStyle: TextStyle(fontWeight: FontWeight.bold,
                              color: _phoneNumberFocusNode.hasFocus ?primaryColorOfApp : Colors.grey,
                          )
                      ),
                      onChanged: (_phoneNumber) async {
                        print(_phoneNumber.length);
                        phoneNumberString = _phoneNumber;
                        if (_phoneNumber.length >= 10) {
                          print(_phoneNumber);
                          phoneNumberString = _phoneNumber;
                          //Store Mobile Number in Shared Preferences
                          this.preferences?.setString("PhoneNumber", phoneNumberString);
                          //Store Mobile Number in Shared Preferences
                          this.preferences?.setString("PhoneNumber", phoneNumberString);
                          print("Below Given is the Value From Shared Prefereneces");
                          print(this.preferences?.getString("PhoneNumber"));
                          isPhoneNumberValid = await ApiRepo().SendMobileNumber(_phoneNumber);
                          //OTPFromApi = await ApiRepo().fetchOTP(_phoneNumber);
                          howManyTimesResendOTPPressed ++;
                          setState((){});
                        }
                        else{
                          //isPhoneNumberValid = false;
                        }
                      },
                    ),
                ),
                Flexible(
                    child: TextField(
                      onChanged: (value) async {
                        if(value.length==4){
                          isValidOTP = await ApiRepo().VerifyOTP(phoneNumberString, value);
                          showOTPErrorText= !isValidOTP;
                          setState(() {});
                          // if(value==OTPFromApi){
                          //   print("Correct OTP");
                          //   isValidOTP = true;
                          //   setState(() {});
                        }
                      },
                      maxLength: 4,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      cursorColor: primaryColorOfApp,
                      style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                      focusNode: _otpFocusNode,
                      onTap: _requestOtpFocus,
                      decoration: InputDecoration(
                          counter: Offstage(),
                          errorText: showOTPErrorText?"$OTPErrorText":null,
                          suffixIcon: Padding(
                            padding: const EdgeInsets.fromLTRB(0.0,0.0,40.0,0.0),
                            child: Icon(NuniyoCustomIcons.mobile_otp_black,size: 12.0,color: _otpFocusNode.hasFocus ?primaryColorOfApp : Colors.grey,),
                          ),
                          labelText: _otpFocusNode.hasFocus ? 'OTP' : 'Enter OTP',
                          labelStyle: TextStyle(
                            color: _otpFocusNode.hasFocus ?primaryColorOfApp : Colors.grey,
                          )
                      ),
                    )
                ),
                Visibility(
                  visible: _shouldResendOTPBTNbeVisible(),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        child: Text("Resend OTP",style: GoogleFonts.openSans(textStyle: TextStyle(decoration: TextDecoration.underline,fontSize: 18,fontWeight: FontWeight.bold,color:enableOTPButton?primaryColorOfApp:Colors.black12, letterSpacing: .5),),),
                        onPressed: enableOTPButton ? () async {
                          enableOTPButton = false;
                          howManyTimesResendOTPPressed ++;
                          setState((){});
                          startTimer();
                          if(phoneNumberString.length==10 && isPhoneNumberValid){
                            await ApiRepo().SendMobileNumber(phoneNumberString);
                          }
                        }:null),
                  ),
                ),
                SizedBox(height: 10,),
                Visibility(
                  visible: showReferralTextField,
                  child: Flexible(
                      child: DottedBorder(
                          radius: Radius.circular(8.0),
                          color: _referralCodeNode.hasFocus ?primaryColorOfApp : Colors.black,//color of dotted/dash line
                          strokeWidth: 3,
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          borderType: BorderType.RRect,
                          strokeCap: StrokeCap.round,//thickness of dash/dots
                          dashPattern: [10,8],
                        child: TextField(
                          maxLength: 10,
                          cursorColor: _referralCodeNode.hasFocus ?primaryColorOfApp : Colors.black,
                          style :GoogleFonts.openSans(textStyle: TextStyle(color: Colors.black, letterSpacing: .5,fontSize: 14,fontWeight: FontWeight.bold)),
                          focusNode: _referralCodeNode,
                          onTap: _requestReferralCodeFocus,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(20, 10, 0, 12),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              counter: Offstage(),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.fromLTRB(0.0,0.0,20.0,0.0),
                                child: Padding(padding:EdgeInsets.fromLTRB(0, 0, 0, 16.0),child: Icon(NuniyoCustomIcons.referral_code_black,size: 26.0,color: _referralCodeNode.hasFocus ?primaryColorOfApp : Colors.black,),)
                              ),
                              hintText: 'Referral Code ',
                              labelStyle: TextStyle(
                                color: _referralCodeNode.hasFocus ?primaryColorOfApp : Colors.black,
                              )
                          ),
                        ),
                      )
                  ),
                ),
                Visibility(
                  visible: !showReferralTextField,
                  child: Row(
                    children: [
                      Text("Do you have a ",textAlign:TextAlign.left, style:GoogleFonts.openSans(textStyle: TextStyle(color: Colors.black,fontSize: 16.0,letterSpacing: .5,fontWeight: FontWeight.normal)),),
                      TextButton(
                          child: Text("Referral Code ?",style: GoogleFonts.openSans(textStyle: TextStyle(decoration: TextDecoration.underline,fontSize: 16,fontWeight: FontWeight.bold,color:enableOTPButton?primaryColorOfApp:Colors.black12, letterSpacing: .5),),),
                          onPressed: (){
                            showReferralTextField = true;
                            setState(() {
                            });
                          }
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Text("By Clicking on proceed I agree to all the",textAlign:TextAlign.left, style:GoogleFonts.openSans(color:Colors.black,textStyle: TextStyle(color: Colors.black,fontSize: 12.0,letterSpacing: .5,fontWeight: FontWeight.normal)),),
                TextButton(child: Text("Terms & Conditions",textAlign:TextAlign.left,style: GoogleFonts.openSans(textStyle: TextStyle(decoration: TextDecoration.underline,fontSize: 12,fontWeight: FontWeight.bold,color:enableOTPButton?primaryColorOfApp:Colors.black12, letterSpacing: .5),),),
                    onPressed: (){}
                ),
                SizedBox(height: 20,),
                //Real Button
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  height: 60,
                  child: FlatButton(
                      disabledTextColor: Colors.blue,
                      disabledColor: Color(0xffD2D0E1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      onPressed: !isValidOTP ? null : () => {
                        ContinueToStep()
                      },
                      color: primaryColorOfApp,
                      child: Text(
                        "Proceed",
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(color: Colors.white, letterSpacing: .5,fontSize: 16,fontWeight: FontWeight.bold),)
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void startTimer() {
    var duration = interval;
    Timer.periodic(duration, (timer) {
      setState(() {
        print(timer.tick);
        currentSeconds = timer.tick;
        if (timer.tick >= _resendOTPIntervalTime){
          enableOTPButton = true;
          timer.cancel();
        }
      });
    });
  }

  bool _shouldResendOTPBTNbeVisible() {
    if(howManyTimesResendOTPPressed>0 && howManyTimesResendOTPPressed < 4 ){
      return true;
    }
    else if(howManyTimesResendOTPPressed>=4){
      OTPErrorText = "Too Many Attempts.....";
      showOTPErrorText = true;
      setState(() {

      });
      return false;
    }
    else{
      return false;
    }
  }

  Future<void> initializePreference() async{
    this.preferences = await SharedPreferences.getInstance();
    //this.preferences?.setString("name", "Peter");
    //this.preferences?.setStringList("infoList", ["developer","mobile dev"]);
  }


  Future<void> ContinueToStep() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey('STEP_ID')){
      String ThisStepId = prefs.getString("STEP_ID");
      print("YOU LEFT ON THIS PAGE LAST TIME"+ThisStepId);
      Navigator.pushNamed(context,ThisStepId);
    }
    else{
      print("WELCOME NEW USER");
      Navigator.pushNamed(context,'/bankemailpanvalidationscreen');
    }
  }
}


