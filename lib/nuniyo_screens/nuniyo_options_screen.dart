import 'package:angel_broking_demo/ApiRepository/apirepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OptionsScreen extends StatefulWidget {
  const OptionsScreen({Key? key}) : super(key: key);

  @override
  _OptionsScreenState createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen> {

  Color primaryColorOfApp = Color(0xff6A4EEE);

  bool checkedValue  = false;

  static const platform = const MethodChannel("razorpay_flutter");

  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.0,),
                    Row(
                      children: [
                        SizedBox(width: 10.0,),
                        Text("Account Opening is",textAlign:TextAlign.left, style:GoogleFonts.openSans(textStyle: TextStyle(color: Colors.black,fontSize: 22.0,letterSpacing: .5,fontWeight: FontWeight.bold)),),
                        Text(" FREE !",textAlign:TextAlign.left, style:GoogleFonts.openSans(textStyle: TextStyle(color: primaryColorOfApp,fontSize: 22.0,letterSpacing: .5,fontWeight: FontWeight.bold)),),
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
                Container(
                  height: 390,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: primaryColorOfApp,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(15))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: CheckboxListTile(
                                  title: Text("Equity",textAlign:TextAlign.left, style:GoogleFonts.openSans(textStyle: TextStyle(color: Colors.black,fontSize: 22.0,letterSpacing: .5,fontWeight: FontWeight.bold)),),
                                  value: checkedValue,
                                  onChanged: (newValue) {
                                    setState(() {
                                      checkedValue = newValue!;
                                    });
                                  },
                                  controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0.0,0.0,10.0,0.0),
                                child: Text("0₹",textAlign:TextAlign.left, style:GoogleFonts.openSans(textStyle: TextStyle(color: Colors.black,fontSize: 22.0,letterSpacing: .5,fontWeight: FontWeight.bold)),),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24.0,0.0,0.0,0.0),
                            child: Text("Buy and sell shares , mutual funds and derivatives on NSE and BSE",textAlign:TextAlign.left, style:GoogleFonts.openSans(textStyle: TextStyle(color: Colors.black,fontSize: 12.0,letterSpacing: .5)),),
                          ),
                          Column(
                            children: [
                              CheckboxListTile(
                                title: Text("Equity",textAlign:TextAlign.left, style:GoogleFonts.openSans(textStyle: TextStyle(color: Colors.black,fontSize: 18.0,letterSpacing: .5)),),
                                value: checkedValue,
                                onChanged: (newValue) {
                                  setState(() {
                                    checkedValue = newValue!;
                                  });
                                },
                                controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                              ),
                              CheckboxListTile(
                                title: Text("F&O",textAlign:TextAlign.left, style:GoogleFonts.openSans(textStyle: TextStyle(color: Colors.black,fontSize: 18.0,letterSpacing: .5)),),
                                value: checkedValue,
                                onChanged: (newValue) {
                                  setState(() {
                                    checkedValue = newValue!;
                                  });
                                },
                                controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                              ),
                              CheckboxListTile(
                                title: Text("Currency",textAlign:TextAlign.left, style:GoogleFonts.openSans(textStyle: TextStyle(color: Colors.black,fontSize: 18.0,letterSpacing: .5)),),
                                value: checkedValue,
                                onChanged: (newValue) {
                                  setState(() {
                                    checkedValue = newValue!;
                                  });
                                },
                                controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                              ),
                              CheckboxListTile(
                                title: Text("Commodities",textAlign:TextAlign.left, style:GoogleFonts.openSans(textStyle: TextStyle(color: Colors.black,fontSize: 18.0,letterSpacing: .5)),),
                                value: checkedValue,
                                onChanged: (newValue) {
                                  setState(() {
                                    checkedValue = newValue!;
                                  });
                                },
                                controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(25.0,10.0,0.0,0.0),
                            child: Row(
                              children: [
                                Text("₹ 20 ",textAlign:TextAlign.left, style:GoogleFonts.openSans(textStyle: TextStyle(color: Colors.black,fontSize: 20.0,letterSpacing: .5,fontWeight: FontWeight.bold))),
                                Flexible(child: Text("per order for F&O , Currency and Commodity.",maxLines:1 ,textAlign:TextAlign.left, style:GoogleFonts.openSans(textStyle: TextStyle(color: Colors.black,fontSize: 10.0,letterSpacing: .5)),)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ),
                SizedBox(height: 24.0,),
                Divider(
                  height: 20,
                  thickness: 2,
                  indent: 20,
                  endIndent: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Total",textAlign:TextAlign.left, style:GoogleFonts.openSans(textStyle: TextStyle(color:primaryColorOfApp,fontSize: 22.0,letterSpacing: .5,fontWeight: FontWeight.bold))),
                    Text("₹ 20 ",textAlign:TextAlign.left, style:GoogleFonts.openSans(textStyle: TextStyle(color:primaryColorOfApp,fontSize: 22.0,letterSpacing: .5,fontWeight: FontWeight.bold))),
                  ],
                ),
                Divider(
                  height: 20,
                  thickness: 2,
                  indent: 20,
                  endIndent: 20,
                ),
                SizedBox(height: 30,),
                Container(
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  height: 75,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    onPressed: () {
                      openCheckout();
                      Navigator.pushNamed(context, '/aadharkycscreen');
                    },
                    color: primaryColorOfApp,
                    child: Text(
                        "Pay 200₹",
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

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_3ItfhafvOz0Kkx',
      'amount': 20000,
      'name': 'Nuniyo.',
      'description': 'Stock Trading',
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: "SUCCESS: " + response.paymentId!, toastLength: Toast.LENGTH_SHORT);
    PostPayment(response.paymentId.toString());
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: "ERROR: " + response.code.toString() + " - " + response.message!, toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "EXTERNAL_WALLET: " + response.walletName!, toastLength: Toast.LENGTH_SHORT);
  }

  Future<void> PostPayment(String paymentID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String phoneNumber = await prefs.getString('PhoneNumber');
    ApiRepo().OnPaymentSuccessPostToDatabase(200, phoneNumber,paymentID);
  }

}
