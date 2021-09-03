///Sign Up Page 1
import 'package:angel_broking_demo/ApiRepository/apirepository.dart';
import 'package:angel_broking_demo/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/////Bank
class BankPanEmailValidationScreen extends StatefulWidget {
  const BankPanEmailValidationScreen({Key? key}) : super(key: key);

  @override
  _BankPanEmailValidationScreenState createState() => _BankPanEmailValidationScreenState();
}

class _BankPanEmailValidationScreenState extends State<BankPanEmailValidationScreen> {

  TextEditingController _ifscCodeTextEditingController = TextEditingController();
  TextEditingController _bankTextEditingController = TextEditingController();
  TextEditingController _panTextEditingController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  String fullName = "KHAN ASHRAF SALIM";

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime(1920, 1),
        firstDate: DateTime(1920, 1),
        lastDate: DateTime(2002));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        var date =
            "${picked.toLocal().day}-${picked.toLocal().month}-${picked.toLocal().year}";
        _dateController.text = date;
      });
  }

  DateTime selectedDate = DateTime.now();

  bool isPanValidatedSuccessfully = false;
  bool isBankValidatedSuccessfully = false;
  bool isEmailValidatedSuccessfully = false;


  bool isValidInputForPan = false;
  bool isValidInputForBank = false;
  bool isValidInputForIFSC = false;
  bool isValidInputForEmail = false;

  Color primaryColorOfApp = Color(0xff6A4EEE);

  late FocusNode _emailTextFieldFocusNode,_otpTextFieldFocusNode,_dateTextFieldFocusNode,_panTextFieldFocusNode,_bankTextFieldFocusNode,_ifscTextFieldFocusNode;

  @override
  void initState() {
    super.initState();
    _emailTextFieldFocusNode = FocusNode();
    _otpTextFieldFocusNode = FocusNode();
    _panTextFieldFocusNode = FocusNode();
    _bankTextFieldFocusNode = FocusNode();
    _ifscTextFieldFocusNode = FocusNode();
    _dateTextFieldFocusNode = FocusNode();
  }

  void _requestEmailIdTextFieldFocus(){
    setState(() {
      FocusScope.of(context).requestFocus(_emailTextFieldFocusNode);
    });
  }

  void _requestDateTextFieldFocus(){
    setState(() {
      FocusScope.of(context).requestFocus(_dateTextFieldFocusNode);
    });
  }

  void _requestPanTextFieldFocus(){
    setState(() {
      FocusScope.of(context).requestFocus(_panTextFieldFocusNode);
    });
  }

  void _requestBankTextFieldFocus(){
    setState(() {
      FocusScope.of(context).requestFocus(_bankTextFieldFocusNode);
    });
  }

  void _requestIfscTextFieldFocus(){
    setState(() {
      FocusScope.of(context).requestFocus(_ifscTextFieldFocusNode);
    });
  }

  void _requestOtpTextFieldFocus(){
    setState(() {
      FocusScope.of(context).requestFocus(_otpTextFieldFocusNode);
    });
  }

  @override
  void dispose() {
    _emailTextFieldFocusNode.dispose();
    _otpTextFieldFocusNode.dispose();
    _bankTextFieldFocusNode.dispose();
    _ifscTextFieldFocusNode.dispose();
    _panTextFieldFocusNode.dispose();
    _dateTextFieldFocusNode.dispose();
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
                SizedBox(height:30.0),
                WidgetHelper().DetailsTitle('Let\'s get started'),
                //SizedBox(height: 20,),
                Flexible(
                    child: TextField(
                      cursorColor: primaryColorOfApp,
                      style :GoogleFonts.openSans(textStyle: TextStyle(color: Colors.black, letterSpacing: .5,fontSize: 14,fontWeight: FontWeight.bold)),
                      focusNode: _emailTextFieldFocusNode,
                      onTap: _requestEmailIdTextFieldFocus,
                      decoration: InputDecoration(
                        counter: Offstage(),
                        labelText: _emailTextFieldFocusNode.hasFocus ? 'Email ID' : 'Enter Email ID',
                          labelStyle: TextStyle(fontWeight: FontWeight.bold,
                              color: _emailTextFieldFocusNode.hasFocus ?primaryColorOfApp : Colors.grey,
                          )
                      ),
                      onChanged: (_emailID) async {
                        print(_emailID.length);
                        String pattern =
                            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                            r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                            r"{0,253}[a-zA-Z0-9])?)*$";
                        RegExp regex = new RegExp(pattern);
                        if (!regex.hasMatch(_emailID) || _emailID == null){
                          print('Enter a valid email address');
                          isValidInputForEmail = false;
                        }
                        else {
                          print("Noice Email");
                          isValidInputForEmail=true;
                          //Send Email ID to APi
                        }
                      },
                    )
                ),
                SizedBox(height: 10,),
                Flexible(
                    child: TextField(
                      maxLength: 4,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      cursorColor: primaryColorOfApp,
                      style: GoogleFonts.openSans(textStyle: TextStyle(color: Colors.black, letterSpacing: 3,fontSize: 14,fontWeight: FontWeight.bold)),
                      focusNode: _otpTextFieldFocusNode,
                      onTap: _requestOtpTextFieldFocus,
                      decoration: InputDecoration(
                          counter: Offstage(),
                          labelText: _otpTextFieldFocusNode.hasFocus ? 'OTP' : 'Enter OTP',
                          labelStyle: GoogleFonts.openSans(textStyle:TextStyle(fontSize: 14,letterSpacing: 0.5,
                            color: _otpTextFieldFocusNode.hasFocus ?primaryColorOfApp : Colors.grey,
                          ))
                      ),
                    )
                ),
                Visibility(
                  visible: false,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () {  },
                        child: Text(
                            "Resend OTP",style: GoogleFonts.openSans(
                          textStyle: TextStyle(decoration: TextDecoration.underline,fontSize: 18,fontWeight: FontWeight.bold,color: primaryColorOfApp, letterSpacing: .5),
                    ),),),
                  ),
                ),
                SizedBox(height: 10,),
                Flexible(
                    child: TextField(
                      maxLength: 10,
                      textCapitalization: TextCapitalization.characters,
                      controller: _panTextEditingController,
                      cursorColor: primaryColorOfApp,
                      style: GoogleFonts.openSans(textStyle: TextStyle(color: Colors.black, letterSpacing: .5,fontSize: 14,fontWeight: FontWeight.bold)),
                      focusNode: _panTextFieldFocusNode,
                      onTap: _requestPanTextFieldFocus,
                      decoration: InputDecoration(
                        counter: Offstage(),
                          labelText: _panTextFieldFocusNode.hasFocus ? 'Enter PAN Number' : 'Enter PAN Number',
                          labelStyle: TextStyle(
                            color: _panTextFieldFocusNode.hasFocus ?primaryColorOfApp : Colors.grey,
                          )
                      ),
                    )
                ),
                SizedBox(height: 10,),
                //DOB
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextField(
                        cursorColor: primaryColorOfApp,
                        style: GoogleFonts.openSans(textStyle: TextStyle(color: Colors.grey, letterSpacing: .5,fontSize: 14,fontWeight: FontWeight.bold)),
                        onTap: _requestDateTextFieldFocus,
                        decoration: InputDecoration(
                          labelText: _dateTextFieldFocusNode.hasFocus ? 'Enter DOB' : 'Enter DOB',
                          labelStyle: TextStyle(
                            color: _dateTextFieldFocusNode.hasFocus ?primaryColorOfApp : Colors.grey,
                          ),
                          hintText: 'DD/MM/YYYY',
                        ),
                        controller: _dateController,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Flexible(
                    child: TextField(
                      textCapitalization: TextCapitalization.characters,
                      controller: _bankTextEditingController,
                      cursorColor: primaryColorOfApp,
                      style: GoogleFonts.openSans(textStyle: TextStyle(color: Colors.black, letterSpacing: .5,fontSize: 14,fontWeight: FontWeight.bold)),
                      focusNode: _bankTextFieldFocusNode,
                      onTap: _requestBankTextFieldFocus,
                      decoration: InputDecoration(
                          counter: Offstage(),
                          labelText: _bankTextFieldFocusNode.hasFocus ? 'Enter Bank A/C Number' : 'Enter Bank A/C Number',
                          labelStyle: TextStyle(
                            color: _bankTextFieldFocusNode.hasFocus ?primaryColorOfApp : Colors.grey,
                          )
                      ),
                    )
                ),
                SizedBox(height: 10,),
                Flexible(
                    child: TextField(
                      maxLength: 12,
                      textCapitalization: TextCapitalization.characters,
                      controller: _ifscCodeTextEditingController,
                      cursorColor: primaryColorOfApp,
                      style: GoogleFonts.openSans(textStyle: TextStyle(color: Colors.black, letterSpacing: .5,fontSize: 14,fontWeight: FontWeight.bold)),
                      focusNode: _ifscTextFieldFocusNode,
                      onTap: _requestIfscTextFieldFocus,
                      decoration: InputDecoration(
                          counter: Offstage(),
                          labelText: _ifscTextFieldFocusNode.hasFocus ? 'Enter IFSC Number' : 'Enter IFSC Number',
                          labelStyle: TextStyle(
                            color: _ifscTextFieldFocusNode.hasFocus ?primaryColorOfApp : Colors.grey,
                          )
                      ),
                    )
                ),
                SizedBox(height: 20,),
                //Demo Button
                Container(
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    onPressed: () async {

                      isValidInputForBank = true;
                      isValidInputForPan = true;
                      isValidInputForEmail = true;
                      isValidInputForIFSC = true;

                      if(isValidInputForBank&&isValidInputForPan&&isValidInputForEmail&&isValidInputForIFSC){
                        //Show Success and Move to next screen in some seconds
                        showDialog(
                          context: context, // <-----
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return Dialog(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(width: 20,),
                                    Text(
                                        "Please Wait",
                                        style: GoogleFonts.openSans(
                                          textStyle: TextStyle(color: Colors.black, letterSpacing: .5,fontSize: 16,fontWeight: FontWeight.bold),)
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                        //isBankValidatedSuccessfully = await ApiRepo().fetchIsBankValid(bankAccountNumber, ifscCode);
                        //isPanValidatedSuccessfully = await ApiRepo().fetchIsPanValid(fullName, dOB, panNumber);
                        //isEmailValidatedSuccessfully = await ApiRepo().fetchEmailOTP(emailID);
                        await Future.delayed(Duration(seconds: 1));
                        if(isBankValidatedSuccessfully&&isPanValidatedSuccessfully&&isEmailValidatedSuccessfully){
                          Navigator.pushNamed(context, '/personaldetailsscreen');
                        }
                        else{
                          Navigator.pop(context);
                          //Show error in a dialog box and then wait for 1 seconds and let user try again
                          showDialog(
                            context: context, // <-----
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return Dialog(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.error),
                                      SizedBox(width: 20,),
                                      Text(
                                          "Something went wrong , \n Please Try Again",
                                          style: GoogleFonts.openSans(
                                            textStyle: TextStyle(color: Colors.black, letterSpacing: .5,fontSize: 16,fontWeight: FontWeight.bold),)
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                          await Future.delayed(Duration(seconds: 1));
                          Navigator.pop(context);
                        }

                      }
                    },
                    color: primaryColorOfApp,
                    child: Text(
                        "Proceed",
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(color: Colors.white, letterSpacing: .5,fontSize: 16,fontWeight: FontWeight.bold),)
                    ),
                  ),
                ),
                //Real Button
                /*Container(
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    onPressed: () async {
                      isBankValidatedSuccessfully = await ApiRepo().fetchIsBankValid(_bankTextEditingController.text.trim(), _ifscCodeTextEditingController.text.trim());
                      if(isBankValidatedSuccessfully){
                        isBankValidatedSuccessfully = true;
                        setState(() {});
                      }
                      isPanValidatedSuccessfully = await ApiRepo().fetchIsPanValid(fullName, _dateController.text, _panTextEditingController.text);
                      if(isPanValidatedSuccessfully && isBankValidatedSuccessfully){
                        Navigator.pushNamed(context, '/UploadDocumentScreen');
                      }
                    },
                    color: primaryColorOfApp,
                    child: Text(
                      "Proceed",
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(color: Colors.white, letterSpacing: .5,fontSize: 16,fontWeight: FontWeight.bold),)
                    ),
                  ),
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
