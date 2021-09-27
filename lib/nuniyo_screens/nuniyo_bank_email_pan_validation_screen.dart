///Sign Up Page 1
import 'dart:async';
import 'dart:convert';
import 'package:angel_broking_demo/ApiRepository/apirepository.dart';
import 'package:angel_broking_demo/ApiRepository/localapis.dart';
import 'package:angel_broking_demo/utils/localstorage.dart';
import 'package:angel_broking_demo/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

/////Bank
class BankPanEmailValidationScreen extends StatefulWidget {
  const BankPanEmailValidationScreen({Key? key}) : super(key: key);

  @override
  _BankPanEmailValidationScreenState createState() =>
      _BankPanEmailValidationScreenState();
}

class _BankPanEmailValidationScreenState
    extends State<BankPanEmailValidationScreen> {
  TextEditingController _ifscCodeTextEditingController =
      TextEditingController();
  TextEditingController _bankTextEditingController = TextEditingController();
  TextEditingController _panTextEditingController = TextEditingController();
  TextEditingController _emailTextEditingController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  final interval = const Duration(seconds: 1);

  ///Dialog Box Text Field
  TextEditingController _ifscCodeDialogTextEditingController =
      TextEditingController();
  TextEditingController _branchLocationTextEditingController =
      TextEditingController();
  TextEditingController _branchNameTextEditingController =
      TextEditingController();

  String fullName = "KHAN ASHRAF SALIM";

  late FocusNode _branchNameTextFieldFocusNode,
      _branchLocationTextFieldFocusNode,
      _IFSCCode2TextFieldFocusNode;

  bool isValidIFSCCode = false;

  String emailErrorText = "Please Enter a valid Email...";
  bool showEmailErrorText = false;

  bool showIFSCErrorText = false;
  String ifscErrorText = "Please Enter a valid IFSC....";

  String panErrorText = "Please Enter a valid PAN Number...";
  bool showPANErrorText = false;

  final int _resendOTPIntervalTime = 3;

  int currentSeconds = 0;

  bool enableIFSCCodeTextField = true;

  Map IFSCMapList = {};

  bool showIFSCSearchResults = false;

  bool showBranchLocationErrorText = false;
  bool showBranchNameErrorText = false;

  String branchNameErrorText = "Please Enter a Valid Branch Name";
  String branchLocationErrorText = "Please Enter a Valid Branch Location";

  String BankAccountNumberErrorText = "Please Enter a Valid Bank Account Number";
  bool showBankAccountNumberErrorText = false;

  bool isValidBankAccount = false;

  void _requestBankNameTextFieldFocusNode() {
    setState(() {
      FocusScope.of(context).requestFocus(_branchNameTextFieldFocusNode);
    });
  }

  void _requestBranchNameFocusNode() {
    setState(() {
      FocusScope.of(context).requestFocus(_branchLocationTextFieldFocusNode);
    });
  }

  void _requestIFSCCode2TextFieldFocusNode() {
    setState(() {
      FocusScope.of(context).requestFocus(_IFSCCode2TextFieldFocusNode);
    });
  }

  _selectDate(BuildContext context) async {
    _requestDateTextFieldFocus();
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime(1996, 1),
        firstDate: DateTime(1920, 1),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        var date =
            "${picked.toLocal().day}-${picked.toLocal().month}-${picked.toLocal().year}";
        _dateController.text = date;
        print("WE SELECTED A DATE");
        postDateToDB();
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

  late FocusNode _emailTextFieldFocusNode,
      _dateTextFieldFocusNode,
      _panTextFieldFocusNode,
      _bankTextFieldFocusNode,
      _ifscTextFieldFocusNode;

  @override
  void initState() {
    super.initState();
    manageSteps();
    _branchNameTextFieldFocusNode = FocusNode();
    _branchLocationTextFieldFocusNode = FocusNode();
    _IFSCCode2TextFieldFocusNode = FocusNode();
    _emailTextFieldFocusNode = FocusNode();
    _panTextFieldFocusNode = FocusNode();
    _bankTextFieldFocusNode = FocusNode();
    _ifscTextFieldFocusNode = FocusNode();
    _dateTextFieldFocusNode = FocusNode();
  }

  void _requestEmailIdTextFieldFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(_emailTextFieldFocusNode);
    });
  }

  void _requestDateTextFieldFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(_dateTextFieldFocusNode);
    });
  }

  void _requestPanTextFieldFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(_panTextFieldFocusNode);
    });
  }

  void _requestBankTextFieldFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(_bankTextFieldFocusNode);
    });
  }

  void _requestIfscTextFieldFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(_ifscTextFieldFocusNode);
    });
  }

  Future<bool> _onWillPop() {
    return Future.value(false);
  }

  @override
  void dispose() {
    _branchNameTextFieldFocusNode.dispose();
    _branchLocationTextFieldFocusNode.dispose();
    _IFSCCode2TextFieldFocusNode.dispose();
    _emailTextFieldFocusNode.dispose();
    _bankTextFieldFocusNode.dispose();
    _ifscTextFieldFocusNode.dispose();
    _panTextFieldFocusNode.dispose();
    _dateTextFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            leading: Icon(
              Icons.ac_unit,
              color: Colors.black,
            ),
            title: Text(
              'Tech X Labs',
              style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                      color: Colors.black,
                      letterSpacing: .5,
                      fontWeight: FontWeight.bold)),
            ),
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
                    SizedBox(height: 30.0),
                    WidgetHelper().DetailsTitle('Let\'s get started'),
                    //SizedBox(height: 20,),
                    Flexible(
                        child: TextField(
                      cursorColor: primaryColorOfApp,
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Colors.black,
                              letterSpacing: .5,
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
                      focusNode: _emailTextFieldFocusNode,
                      controller: _emailTextEditingController,
                      onTap: _requestEmailIdTextFieldFocus,
                      decoration: InputDecoration(
                          counter: Offstage(),
                          suffixIcon: !showEmailErrorText
                              ? Icon(Icons.check_circle,
                              color: isValidInputForEmail
                                  ? Colors.green
                                  : Colors.transparent)
                              : Icon(Icons.error, color: Colors.red),
                          errorText: showEmailErrorText ? emailErrorText : null,
                          labelText: _emailTextFieldFocusNode.hasFocus
                              ? 'Email ID'
                              : 'Enter Email ID',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _emailTextFieldFocusNode.hasFocus
                                ? primaryColorOfApp
                                : Colors.grey,
                          )),
                      onChanged: (_emailID) async {
                        print(_emailID.length);
                        String pattern =
                            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                            r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                            r"{0,253}[a-zA-Z0-9])?)*$";
                        RegExp regex = new RegExp(pattern);
                        if (!regex.hasMatch(_emailID) || _emailID == null) {
                          print('Enter a valid email address');
                          isValidInputForEmail = false;
                        } else {
                          print("Noice Email");
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          //isValidInputForEmail = await ApiRepo().VerifyEmail(prefs.getString('PhoneNumber'), _emailID);
                          //Send Email ID to APi
                          isValidInputForEmail = await LocalApiRepo().Email_StatusLocal(_emailID);
                          showEmailErrorText = !isValidInputForEmail;
                          if (isValidInputForEmail) {
                            prefs.setString('EMAIL_ID', _emailID);
                            await LocalApiRepo().UpdateEmailLocal(_emailID);
                          }
                          setState(() {});
                        }
                      },
                    )),
                    SizedBox(
                      height: 10,
                    ),
                    Flexible(
                        child: TextField(
                        maxLength: 10,
                        onChanged: (_panNumber) async {
                        if (_panNumber.length >= 10) {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          String phoneNumber = await prefs.getString('PhoneNumber');
                          print(
                              "We are Fetching PAN Details For the Phone Number :" +
                                  phoneNumber +
                                  " and Email ID :");
                          //isValidInputForPan = await ApiRepo().VerifyPAN(phoneNumber, _panNumber);
                          isValidInputForPan = await LocalApiRepo().GetPanStatusLocal(_panNumber);

                          if (isValidInputForPan) {
                            prefs.setString("PAN_NO", _panNumber);
                          }
                          showPANErrorText = !isValidInputForPan;
                          setState(() {});
                        }
                      },
                      textCapitalization: TextCapitalization.characters,
                      controller: _panTextEditingController,
                      cursorColor: primaryColorOfApp,
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Colors.black,
                              letterSpacing: .5,
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
                      focusNode: _panTextFieldFocusNode,
                      onTap: _requestPanTextFieldFocus,
                      decoration: InputDecoration(
                          errorText: showPANErrorText ? panErrorText : null,
                          counter: Offstage(),
                          suffixIcon: !showPANErrorText
                              ? Icon(Icons.check_circle,
                              color: isValidInputForPan
                                  ? Colors.green
                                  : Colors.transparent)
                              : Icon(Icons.error, color: Colors.red),
                          labelText: _panTextFieldFocusNode.hasFocus
                              ? 'Enter PAN Number'
                              : 'Enter PAN Number',
                          labelStyle: TextStyle(
                            color: _panTextFieldFocusNode.hasFocus
                                ? primaryColorOfApp
                                : Colors.grey,
                          )),
                    )),
                    SizedBox(
                      height: 10,
                    ),
                    //DOB
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: GestureDetector(
                        onTap: () => _selectDate(context),
                        child: AbsorbPointer(
                          child: TextField(
                            cursorColor: primaryColorOfApp,
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    color: Colors.grey,
                                    letterSpacing: .5,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold)),
                            onTap: _requestDateTextFieldFocus,
                            decoration: InputDecoration(
                              labelText: _dateTextFieldFocusNode.hasFocus
                                  ? 'Enter DOB'
                                  : 'Enter DOB',
                              labelStyle: TextStyle(
                                color: _dateTextFieldFocusNode.hasFocus
                                    ? primaryColorOfApp
                                    : Colors.grey,
                              ),
                              hintText: 'DD/MM/YYYY',
                            ),
                            controller: _dateController,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Flexible(
                        child: TextField(
                      textCapitalization: TextCapitalization.characters,
                      controller: _bankTextEditingController,
                      onChanged: (value) async {
                        if(value.length>18 || value.length>9){
                          print("Verifying Bank Account");
                          isValidBankAccount = await LocalApiRepo().verifyBankAccountLocal(value, _ifscCodeTextEditingController.text.trim());
                          showBankAccountNumberErrorText = !isValidBankAccount;
                          setState((){});
                        }
                      },
                      cursorColor: primaryColorOfApp,
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Colors.black,
                              letterSpacing: .5,
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
                      focusNode: _bankTextFieldFocusNode,
                      onTap: _requestBankTextFieldFocus,
                      decoration: InputDecoration(
                          counter: Offstage(),
                          errorText: showBankAccountNumberErrorText ? "Enter a valid Bank A/C No." : null,
                          suffixIcon: !showBankAccountNumberErrorText
                              ? Icon(Icons.check_circle,
                              color: isValidBankAccount
                                  ? Colors.green
                                  : Colors.transparent)
                              : Icon(Icons.error, color: Colors.red),
                          labelText: _bankTextFieldFocusNode.hasFocus
                              ? 'Enter Bank A/C Number'
                              : 'Enter Bank A/C Number',
                          labelStyle: TextStyle(
                            color: _bankTextFieldFocusNode.hasFocus
                                ? primaryColorOfApp
                                : Colors.grey,
                          )),
                    )),
                    SizedBox(
                      height: 10,
                    ),
                    Flexible(
                        child: TextField(
                      maxLength: 11,
                      textCapitalization: TextCapitalization.characters,
                      controller: _ifscCodeTextEditingController,
                      cursorColor: ifscColorTextField(),
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Colors.black,
                              letterSpacing: .5,
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
                      focusNode: _ifscTextFieldFocusNode,
                      enabled: enableIFSCCodeTextField,
                      onTap: _requestIfscTextFieldFocus,
                      onChanged: (value) async {
                        setState(() {});
                        if (value.length == 11) {
                          String Ifsc_pattern = "^[A-Z]{4}0[A-Z0-9]{6}\$";
                          RegExp regex = new RegExp(Ifsc_pattern);
                          if (!regex.hasMatch(value) || value == null) {
                            print('Enter a valid IFSC CODE ');
                            isValidInputForEmail = false;
                            showIFSCErrorText = true;
                            setState(() {

                            });
                          } else {
                            showIFSCErrorText = false;
                            isValidInputForIFSC = true;
                            setState(() {});
                            //String response = await ApiRepo().isValidIFSC(value);
                            String response = await LocalApiRepo().getIFSCDetailsLocal(value);
                            if (response == "Not Found") {
                              print("IFSC CODE WRONG");
                              showIFSCErrorText = true;
                              isValidIFSCCode = false;
                              setState(() {});
                            } else {
                              showIFSCErrorText = false;
                              isValidIFSCCode = true;
                              print(response);
                              setState(() {});
                              Map valueMap = jsonDecode(response);
                              String _ifscCodeR = valueMap["IFSC"];
                              String _bankNameR = valueMap["BANK"];
                              String _addressR = valueMap["ADDRESS"];
                              openIFSCConfirmDialogBox(
                                  _ifscCodeR, _bankNameR, _addressR);
                            }
                          }
                        }
                      },
                      decoration: InputDecoration(
                          counter: Offstage(),
                          errorText: showIFSCErrorText ? "Enter a valid IFSC" : null,
                          suffixIcon: !showIFSCErrorText
                              ? Icon(Icons.check_circle,
                                  color: isValidIFSCCode
                                      ? Colors.green
                                      : Colors.transparent)
                              : Icon(Icons.error, color: Colors.red),
                          labelText: _ifscTextFieldFocusNode.hasFocus
                              ? 'Enter IFSC Number'
                              : 'Enter IFSC Number',
                          labelStyle: TextStyle(
                            color: _ifscTextFieldFocusNode.hasFocus
                                ? primaryColorOfApp
                                : Colors.grey,
                          )),
                    )),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.search,
                            color: primaryColorOfApp,
                            size: 18,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          TextButton(
                              onPressed: () {
                                openIFSCSearchDialogBox();
                              },
                              child: Text(
                                "Find Your IFSC Code",
                                style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColorOfApp,
                                      letterSpacing: .5),
                                ),
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //Demo Button
                    Container(
                      color: Colors.transparent,
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      child: FlatButton(
                        disabledColor: Color(0xffD2D0E1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        onPressed: !isValidIFSCCode
                            ? null
                            : () async {
                                isValidInputForBank = true;
                                isValidInputForPan = true;
                                isValidInputForEmail = true;
                                isValidInputForIFSC = true;

                                if (isValidInputForBank &&
                                    isValidInputForPan &&
                                    isValidInputForEmail &&
                                    isValidInputForIFSC) {
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
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Text("Please Wait",
                                                  style: GoogleFonts.openSans(
                                                    textStyle: TextStyle(
                                                        color: Colors.black,
                                                        letterSpacing: .5,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
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
                                  if (isBankValidatedSuccessfully &&
                                      isPanValidatedSuccessfully &&
                                      isEmailValidatedSuccessfully) {
                                    Navigator.pushNamed(
                                        context, '/optionsscreen');
                                  } else {
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
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Text(
                                                    "Please Wait ...",
                                                    style: GoogleFonts.openSans(
                                                      textStyle: TextStyle(
                                                          color: Colors.black,
                                                          letterSpacing: .5,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                    await Future.delayed(Duration(seconds: 1));
                                    Navigator.pop(context);
                                    ////////////////////////////FOR DEMO////////////////////
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setString(
                                        "DOB", _dateController.text);
                                    prefs.setString("BANK_AC_NO",
                                        _bankTextEditingController.text);
                                    Navigator.pushNamed(
                                        context, '/optionsscreen');
                                    ////////////
                                  }
                                }
                              },
                        color: primaryColorOfApp,
                        child: Text("Proceed",
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: .5,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        onWillPop: _onWillPop);
  }

  Color ifscColorTextField() {
    if (_ifscCodeTextEditingController.text.length == 11 && isValidIFSCCode) {
      return Colors.green;
    } else if (_ifscCodeTextEditingController.text.length == 11 &&
        !isValidIFSCCode) {
      return Colors.red;
    } else if (_ifscTextFieldFocusNode.hasFocus) {
      return primaryColorOfApp;
    } else {
      return Colors.grey;
    }
  }

  void openIFSCConfirmDialogBox(
      String _ifscCodeR, String _bankNameR, String _addressR) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            height: 450,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                child: Material(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(22.0, 0.0, 0, 0),
                    child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Confirm Bank Details",
                                    style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                          color: Colors.black,
                                          letterSpacing: .5,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    )),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0.0, 0.0, 10.0, 0.0),
                                  child: IconButton(
                                    icon: Icon(Icons.close),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Text("IFSC Code :",
                                  style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        letterSpacing: .5,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  )),
                              Text(_ifscCodeR,
                                  style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        letterSpacing: .5,
                                        fontSize: 18),
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text("Bank Name :",
                                  style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        letterSpacing: .5,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  )),
                              Text(_bankNameR,
                                  style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        letterSpacing: .5,
                                        fontSize: 18),
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Address :",
                                  style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        letterSpacing: .5,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  )),
                              Flexible(
                                child: Text(_addressR,
                                    style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                          color: Colors.black,
                                          letterSpacing: .5,
                                          fontSize: 18),
                                    )),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            color: Colors.transparent,
                            width: MediaQuery.of(context).size.width / 1.5,
                            height: 60,
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              onPressed: () {
                                isValidIFSCCode = true;
                                isValidInputForIFSC = true;
                                enableIFSCCodeTextField = false;
                                Navigator.pop(context);
                              },
                              color: primaryColorOfApp,
                              child: Text("Confirm",
                                  style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                        color: Colors.white,
                                        letterSpacing: .5,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            color: Colors.transparent,
                            width: MediaQuery.of(context).size.width / 1.5,
                            height: 60,
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              onPressed: () async {
                                Navigator.pop(context);
                                enableIFSCCodeTextField = true;
                                setState(() {});
                              },
                              color: Colors.black12,
                              child: Text("Cancel",
                                  style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                        color: Colors.white,
                                        letterSpacing: .5,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ),
                          ),
                          SizedBox(height: 20.0),
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center),
                  ),
                ),
              ),
            ),
            margin: EdgeInsets.only(bottom: 20, left: 12, right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  void openIFSCSearchDialogBox() {
    showDialog(
        barrierLabel: "Barrier",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return Align(
              alignment: Alignment.center,
              child: Container(
                height: 650,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                    child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(22.0, 0.0, 0.0, 10.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Material(
                                color: Colors.transparent,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Find Your IFSC Code",
                                        style: GoogleFonts.openSans(
                                          textStyle: TextStyle(
                                              color: Colors.black,
                                              letterSpacing: .5,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0.0, 0.0, 10.0, 0.0),
                                      child: IconButton(
                                        icon: Icon(Icons.close),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Column(children: <Widget>[
                            Material(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Container(
                                  height: 80,
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    cursorColor: primaryColorOfApp,
                                    style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                            color: Colors.black,
                                            letterSpacing: 0.5,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                    focusNode: _IFSCCode2TextFieldFocusNode,
                                    onTap: _requestIFSCCode2TextFieldFocusNode,
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.fromLTRB(
                                            25.0, 40.0, 0.0, 40.0),
                                        counter: Offstage(),
                                        labelText: _IFSCCode2TextFieldFocusNode
                                                .hasFocus
                                            ? 'Enter IFSC Code'
                                            : 'Enter IFSC Code',
                                        labelStyle: GoogleFonts.openSans(
                                            textStyle: TextStyle(
                                          fontSize: 14,
                                          letterSpacing: 0.5,
                                          color: _IFSCCode2TextFieldFocusNode
                                                  .hasFocus
                                              ? primaryColorOfApp
                                              : Colors.grey,
                                        ))),
                                  ),
                                ),
                              ),
                            ),
                            Material(
                              color: Colors.white,
                              child: Text("Or",
                                  style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        letterSpacing: .5,
                                        fontSize: 20),
                                  )),
                            ),
                            Material(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Container(
                                  height: 80,
                                  child: TextField(
                                    cursorColor: primaryColorOfApp,
                                    controller:
                                        _branchNameTextEditingController,
                                    style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                            color: Colors.black,
                                            letterSpacing: 0.5,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                    focusNode: _branchNameTextFieldFocusNode,
                                    onTap: _requestBankNameTextFieldFocusNode,
                                    decoration: InputDecoration(
                                        errorText: showBranchNameErrorText
                                            ? branchNameErrorText
                                            : null,
                                        contentPadding: EdgeInsets.fromLTRB(
                                            25.0, 40.0, 0.0, 40.0),
                                        counter: Offstage(),
                                        labelText: _branchNameTextFieldFocusNode
                                                .hasFocus
                                            ? 'Enter Bank Name'
                                            : 'Enter Bank Name',
                                        labelStyle: GoogleFonts.openSans(
                                            textStyle: TextStyle(
                                          fontSize: 14,
                                          letterSpacing: 0.5,
                                          color: _branchNameTextFieldFocusNode
                                                  .hasFocus
                                              ? primaryColorOfApp
                                              : Colors.grey,
                                        ))),
                                  ),
                                ),
                              ),
                            ),
                            Material(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Container(
                                  height: 80,
                                  child: TextField(
                                    cursorColor: primaryColorOfApp,
                                    controller:
                                        _branchLocationTextEditingController,
                                    style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                            color: Colors.black,
                                            letterSpacing: 0.5,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                    focusNode:
                                        _branchLocationTextFieldFocusNode,
                                    onTap: () {
                                      _requestBranchNameFocusNode;
                                    },
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.fromLTRB(
                                            25.0, 40.0, 0.0, 40.0),
                                        counter: Offstage(),
                                        errorText: showBranchLocationErrorText
                                            ? branchLocationErrorText
                                            : null,
                                        labelText:
                                            _branchLocationTextFieldFocusNode
                                                    .hasFocus
                                                ? 'Enter Branch Location'
                                                : 'Enter Branch Location',
                                        labelStyle: GoogleFonts.openSans(
                                            textStyle: TextStyle(
                                          fontSize: 14,
                                          letterSpacing: 0.5,
                                          color:
                                              _branchLocationTextFieldFocusNode
                                                      .hasFocus
                                                  ? primaryColorOfApp
                                                  : Colors.grey,
                                        ))),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 1.5,
                                color: Colors.transparent,
                                height: 60,
                                child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  onPressed: () async {
                                    if (_branchNameTextEditingController.text !=
                                            "" &&
                                        _branchNameTextEditingController.text !=
                                            "") {
                                      showBranchNameErrorText = false;
                                      showBranchLocationErrorText = false;
                                      //IFSCMapList = await ApiRepo().searchIFSCCodes(_branchNameTextEditingController.text.trim(), _branchLocationTextEditingController.text.trim());
                                      IFSCMapList = await LocalApiRepo().IFSCMasterSearchLocal(_branchNameTextEditingController.text.trim(), _branchLocationTextEditingController.text.trim());
                                      if (IFSCMapList["res_Output"].length >
                                          0) {
                                        showIFSCSearchResults = true;
                                        setState(() {});
                                      }
                                    } else {
                                      showBranchNameErrorText = true;
                                      showBranchLocationErrorText = true;
                                      setState(() {});
                                    }
                                  },
                                  color: primaryColorOfApp,
                                  child: Text("Search",
                                      style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                            color: Colors.white,
                                            letterSpacing: .5,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ),
                              ),
                            ),
                            ListViewOfIFSCCode(),
                          ], mainAxisAlignment: MainAxisAlignment.spaceEvenly)
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center),
                  ),
                ),
                margin: EdgeInsets.only(bottom: 20, left: 12, right: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            );
          });
        });
  }

  Future<void> manageSteps() async {
    String currentRouteName = '/bankemailpanvalidationscreen';
    await StoreLocal().StoreRouteNameToLocalStorage(currentRouteName);
    String routeName = await StoreLocal().getRouteNameFromLocalStorage();
    print("YOU ARE ON THIS STEP : "+routeName);
  }

  Widget ListViewOfIFSCCode() {
    if (IFSCMapList.isEmpty) {
      return Material(
        color: Colors.white,
        child: Container(
          height: 200,
        ),
      );
    } else {
      return Material(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("Search Results",
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color: Colors.black,
                            letterSpacing: .5,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      )),
                ),
                alignment: Alignment.centerLeft,
              ),
              for (int i = 0; i < IFSCMapList["res_Output"].length; i++)
                IFSCCard(
                    IFSCMapList["res_Output"][i]["branch"],
                    IFSCMapList["res_Output"][i]["address"],
                    IFSCMapList["res_Output"][i]["ifsc"])
            ],
          ),
        ),
      );
    }
  }

  IFSCCard(String BranchName, String Address, String IfscCode) {
    return GestureDetector(
      onTap: () async {
        Navigator.pop(context);
        _ifscCodeTextEditingController.text = IfscCode;
        String response = await ApiRepo().isValidIFSC(IfscCode);
        if (response == "Not Found") {
          print("IFSC CODE WRONG");
          showIFSCErrorText = true;
          isValidIFSCCode = false;
          setState(() {});
        } else {
          showIFSCErrorText = false;
          isValidIFSCCode = true;
          print(response);
          setState(() {});
          Map valueMap = jsonDecode(response);
          String _ifscCodeR = valueMap["IFSC"];
          String _bankNameR = valueMap["BANK"];
          String _addressR = valueMap["ADDRESS"];
          openIFSCConfirmDialogBox(
              _ifscCodeR, _bankNameR, _addressR);
        }
      },
      child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text("$BranchName",
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Colors.black,
                              letterSpacing: .5,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Address :",
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color: Colors.black,
                            letterSpacing: .5,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      )),
                  Flexible(
                    child: Text("$Address",
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Colors.black,
                              letterSpacing: .5,
                              fontSize: 18),
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text("IFSC Code :",
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color: Colors.black,
                            letterSpacing: .5,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      )),
                  Text("$IfscCode",
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color: Colors.black, letterSpacing: .5, fontSize: 18),
                      )),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                height: 1,
                color: Colors.black,
              ),
            ],
          )),
    );
  }

  void postDateToDB() async {
    //CALL KRA & SOLICIT FETCH
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String phoneNumber = prefs.getString("PhoneNumber");
    print("We fetched phone Number");
    print(phoneNumber);
    if(isValidInputForPan){
      await LocalApiRepo().SolicitLocal(_panTextEditingController.text, _dateController.text);
      await LocalApiRepo().KRALOCAL(_panTextEditingController.text, phoneNumber);
    }
  }
}
