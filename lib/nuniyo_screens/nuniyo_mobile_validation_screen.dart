//Mobile Validation
import 'dart:async';
import 'package:angel_broking_demo/ApiRepository/apirepository.dart';
import 'package:angel_broking_demo/ApiRepository/localapis.dart';
import 'package:angel_broking_demo/nuniyo_custom_icons.dart';
import 'package:angel_broking_demo/nuniyo_screens/nuniyo_terms_and_conditions_webview.dart';
import 'package:angel_broking_demo/widgets/widgets.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../globals.dart';

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
  bool enableResendOTPButtonm = true;
  

  String OTPErrorText = "Wrong OTP";
  bool showOTPErrorText = false;

  final interval = const Duration(seconds: 1);

  final int _resendOTPIntervalTime = 3;

  int currentSeconds = 0;

  int howManyTimesResendOTPPressed = 0;

  bool showReferralTextField = false;

  bool tncChecked = false;

  bool showTNCError = false;

  TextEditingController _otpTextEditingController = TextEditingController();
  TextEditingController _phoneNumberTextEditingController = TextEditingController();

  bool enableOTPTextField = true;

  bool ShowOTP=false;

  bool enablePhoneNumberTextField = true;

  bool showPhoneNumberError = false;

  String phoneNumberError = "Please Enter a Valid Phone Number";

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
    _phoneNumberTextEditingController.dispose();
    _otpTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: WidgetHelper().NuniyoAppBar(),
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
                        Navigator.pushNamed(context, 'Personal');
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
                    controller: _phoneNumberTextEditingController,
                    keyboardType: TextInputType.number,
                    cursorColor: primaryColorOfApp,
                    style :GoogleFonts.openSans(textStyle: TextStyle(color: Colors.black, letterSpacing: .5,fontSize: 14,fontWeight: FontWeight.bold)),
                    focusNode: _phoneNumberFocusNode,
                    onTap: _requestPhoneFocus,
                    decoration: InputDecoration(
                        errorText: showPhoneNumberError?phoneNumberError:null,
                        counter: Offstage(),
                        isDense: true,
                        enabled: enablePhoneNumberTextField,
                        prefixIcon:Padding(
                          padding: EdgeInsets.fromLTRB(16.0,_phoneNumberFocusNode.hasFocus ?4.5:1.0,_phoneNumberFocusNode.hasFocus ?0.0:10,0.0),
                          child:Text("+91 | ",style:GoogleFonts.openSans(textStyle: TextStyle(letterSpacing: .5,fontSize: 14,fontWeight: FontWeight.bold,
                          color: _phoneNumberFocusNode.hasFocus ?Colors.black : Colors.grey,)
                        ),),),
                        prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.fromLTRB(0.0,0.0,20.0,0.0),
                          child: !isValidOTP?Icon(NuniyoCustomIcons.mobile_number_black,size: 26.0,color: _phoneNumberFocusNode.hasFocus ?primaryColorOfApp : Colors.grey,):Padding(padding:EdgeInsets.only(right:2.5),child:Icon(Icons.check_circle,color:Colors.green,size: 30,)),
                        ),
                        labelText: _phoneNumberFocusNode.hasFocus ? 'Mobile Number' : 'Enter Mobile Number',
                        labelStyle: TextStyle(fontWeight: FontWeight.bold,
                          color: _phoneNumberFocusNode.hasFocus ?primaryColorOfApp : Colors.grey,
                        )
                    ),
                    onChanged: (_phoneNumber) async {
                      print(_phoneNumber.length);
                      phoneNumberString = _phoneNumber;
                      if (_phoneNumber.length >= 10 && isvalidphone(phoneNumberString)) {
                        showPhoneNumberError = false;
                        isPhoneNumberValid = true;
                        print(_phoneNumber);
                        phoneNumberString = _phoneNumber;
                        //Store Mobile Number in Shared Preferences
                        this.preferences?.setString(MOBILE_NUMBER_KEY, phoneNumberString);
                        print("Below Given is the Value From Shared Prefereneces");
                        print(this.preferences?.getString(MOBILE_NUMBER_KEY));
                        //isPhoneNumberValid = await ApiRepo().SendMobileNumber(_phoneNumber);
                        if(howManyTimesResendOTPPressed<=0){
                          isPhoneNumberValid = await LocalApiRepo().ReadLead(_phoneNumber);
                          howManyTimesResendOTPPressed ++;
                        }


                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        String otp= prefs.getString("MOBILE_OTP");
                        print("OTP INSIDE SHARED PREFERENCES :" + otp);

                        //Prefill OTP Feature

                        //_otpTextEditingController.text = otp;
                        //isValidOTP = await LocalApiRepo().VerifyOTP(phoneNumberString, _otpTextEditingController.text);
                        //showOTPErrorText= !isValidOTP;
                        //if(isValidOTP){
                          //enableResendOTPButtonm = false;
                          //enableOTPTextField = false;
                          //enablePhoneNumberTextField= false;


                        //}
                        //setState(() {});
                        ///

                        setState((){});
                      }
                      else{
                        if(phoneNumberString.length>=10){
                          isPhoneNumberValid = false;
                          showPhoneNumberError = true;
                          setState(() {
                          });
                        }
                      }
                    },
                  ),
                ),
                SizedBox(height: 10,),
                Flexible(
                    child: TextField(
                      onChanged: (value) async {
                        if(phoneNumberString.length<10 || !isvalidphone(phoneNumberString)){
                          showPhoneNumberError = true;
                          setState(() {

                          });
                          return;
                        }
                        if(value.length==6){
                          //isValidOTP = await ApiRepo().VerifyOTP(phoneNumberString, value);
                          isValidOTP = await LocalApiRepo().VerifyOTP(phoneNumberString, value);
                          showOTPErrorText= !isValidOTP;
                          setState(() {});
                          // if(value==OTPFromApi){
                          //   print("Correct OTP");
                          //   isValidOTP = true;
                          //   setState(() {});
                        }
                      },
                      maxLength: 6,
                      controller: _otpTextEditingController,
                      keyboardType: TextInputType.number,
                      obscureText: !ShowOTP,
                      cursorColor: primaryColorOfApp,
                      style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                      focusNode: _otpFocusNode,
                      onTap: _requestOtpFocus,
                      decoration: InputDecoration(
                        enabled: enableOTPTextField,
                          counter: Offstage(),
                          errorText: showOTPErrorText?"$OTPErrorText":null,
                          suffixIcon: Padding(
                            padding: EdgeInsets.fromLTRB(0.0,0.0,!ShowOTP?15.0:26.0,0.0),
                            child: !ShowOTP?IconButton(icon:Icon(Icons.remove_red_eye,size: 26.0,color: _otpFocusNode.hasFocus ?primaryColorOfApp : Colors.grey),onPressed: (){ShowOTP=!ShowOTP;setState(() {
                            });},):IconButton(onPressed: (){ShowOTP=!ShowOTP;setState(() {});},icon:Icon(NuniyoCustomIcons.mobile_otp_black,size: 12.0,color: _otpFocusNode.hasFocus ?primaryColorOfApp : Colors.grey,)),
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
                        child: Text("Resend OTP",style: GoogleFonts.openSans(textStyle: TextStyle(decoration: TextDecoration.underline,fontSize: 18,fontWeight: FontWeight.bold,color:enableResendOTPButtonm?primaryColorOfApp:Colors.black12, letterSpacing: .5),),),
                        onPressed: enableResendOTPButtonm ? () async {
                          if(phoneNumberString.length==10 && isvalidphone(phoneNumberString)){
                            enableResendOTPButtonm = false;
                            howManyTimesResendOTPPressed ++;
                            setState((){});
                            startTimer();
                            await LocalApiRepo().ReadLead(phoneNumberString);
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
                          child: Text("Referral Code ?",style: GoogleFonts.openSans(textStyle: TextStyle(decoration: TextDecoration.underline,fontSize: 16,fontWeight: FontWeight.bold,color:primaryColorOfApp, letterSpacing: .5),),),
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
                Row(
                  children: [
                    SizedBox(
                      height: 24.0,
                      width: 24.0,
                      child: Checkbox(
                        value: this.tncChecked,
                        checkColor: Colors.white,
                        activeColor: primaryColorOfApp,
                        fillColor: showTNCError?MaterialStateProperty.all(Colors.red):null,
                        onChanged: (value) {
                          setState(() {
                            this.tncChecked = value!;
                            if(tncChecked==true){
                              showTNCError = false;
                            }
                            print(tncChecked);
                          });
                        },
                      ),
                    ),
                    TextButton(child: Text("Terms & Conditions",textAlign:TextAlign.left,style: GoogleFonts.openSans(textStyle: TextStyle(decoration: TextDecoration.underline,fontSize: 12,fontWeight: FontWeight.bold,color:primaryColorOfApp, letterSpacing: .5),),),
                        onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => TermsAndConditions() ));
                        }
                    ),
                  ],
                ),
                Visibility(visible:showTNCError,child: Text("Please Check the Terms & Condition!",textAlign:TextAlign.left,style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:Colors.red, letterSpacing: .5),),),),
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
                    onPressed: !isValidOTP ? null : () async{
                      if(!tncChecked){
                        showTNCError = true;
                        setState(() {});
                        return;
                      }
                      if(this.preferences!.containsKey('COUNTRY')){
                        print("FETCHED LOCATION ARE IN SHARED PREFERENCE");
                        String ip_address = this.preferences!.getString("IP_ADDRESS");
                        String country = this.preferences!.getString("COUNTRY");
                        String city = this.preferences!.getString("CITY");
                        String state = this.preferences!.getString("STATE");
                        String longitude = this.preferences!.getString("LONGITUDE");
                        String latitude = this.preferences!.getString("LATITUDE");
                        print(ip_address);
                        print(country);
                        print(city);
                        print(state);
                        print(latitude);
                        print(latitude);
                        await ApiRepo().leadLocation(phoneNumberString, ip_address, city, country, state, latitude, longitude);
                      }
                      _phoneNumberTextEditingController.clear();
                      _otpTextEditingController.clear();
                      ContinueToStep();
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
    ), onWillPop: _onWillPop);
  }

  void startTimer() {
    var duration = interval;
    Timer.periodic(duration, (timer) {
      setState(() {
        print(timer.tick);
        currentSeconds = timer.tick;
        if (timer.tick >= _resendOTPIntervalTime){
          enableResendOTPButtonm = true;
          timer.cancel();
        }
      });
    });
  }

  bool _shouldResendOTPBTNbeVisible() {
    if(isValidOTP){
      return false;
    }
    else if(howManyTimesResendOTPPressed>0 && howManyTimesResendOTPPressed < 4 ){
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
    if(prefs.containsKey(STAGE_KEY)){
      String ThisStepId = prefs.getString(STAGE_KEY);
      print("YOU LEFT ON THIS PAGE LAST TIME"+ThisStepId);
      Navigator.pushNamed(context,ThisStepId);
    }
    else{
      print("WELCOME NEW USER");
      Navigator.pushNamed(context,'Email');
    }
  }

  Future<bool> _onWillPop() {
    return Future.value(false);
  }


  bool isvalidphone(String? phoneNo) {
    if (phoneNo == null) return false;
    phoneNo="+91"+phoneNo;
    final regExp = RegExp(r'(^(?:(?:\+|0{0,2})91(\s*[\-]\s*)?|[0]?)?[789]\d{9}$)');
    return regExp.hasMatch(phoneNo);
  }
}


