///Congrats Screen
import 'package:angel_broking_demo/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CongratsScreen extends StatefulWidget {
  const CongratsScreen({Key? key}) : super(key: key);

  @override
  _CongratsScreenState createState() => _CongratsScreenState();
}

class _CongratsScreenState extends State<CongratsScreen> {

  Color primaryColorOfApp = Color(0xff6A4EEE);

  @override
  void initState() {
    super.initState();
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
                WidgetHelper().DetailsTitle('Congratulations !'),
                Center(child: Image.asset("assets/images/congratulations.png")),
                SizedBox(height: 20,),
                Text("Your application is complete . After verification , you will recieve your login credentials on your e-mail.",style: GoogleFonts.openSans(
                  textStyle: TextStyle(color: Colors.black, letterSpacing: .5,fontSize: 16),
                ),),
                SizedBox(height: 20,),
                Container(
                  height: 250.0,
                  width: MediaQuery.of(context).size.width,
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
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10.0,30.0,0.0,0.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Username  :",textAlign: TextAlign.center,
                                        style: GoogleFonts.openSans(
                                          textStyle: TextStyle(color: Colors.black, letterSpacing: .5,fontSize: 16,fontWeight: FontWeight.bold),)
                                    ),
                                    Text(
                                        "Email Id  :",textAlign: TextAlign.center,
                                        style: GoogleFonts.openSans(
                                          textStyle: TextStyle(color: Colors.black, letterSpacing: .5,fontSize: 16,fontWeight: FontWeight.bold),)
                                    ),
                                    Text(
                                        "Margin  :",textAlign: TextAlign.center,
                                        style: GoogleFonts.openSans(
                                          textStyle: TextStyle(color: Colors.black, letterSpacing: .5,fontSize: 16,fontWeight: FontWeight.bold),)
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "0912010182018",textAlign: TextAlign.center,
                                        style: GoogleFonts.openSans(
                                          textStyle: TextStyle(color: Colors.black, letterSpacing: .5,fontSize: 16),)
                                    ),
                                    Text(
                                        "youremailid@gmail.com",textAlign: TextAlign.center,
                                        style: GoogleFonts.openSans(
                                          textStyle: TextStyle(color: Colors.black, letterSpacing: .5,fontSize: 16),)
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            "Rs.0.00",textAlign: TextAlign.center,
                                            style: GoogleFonts.openSans(
                                              textStyle: TextStyle(color: Colors.black, letterSpacing: .5,fontSize: 16),)
                                        ),
                                        SizedBox(width: 10,),
                                        Text(
                                            "Add Funds",textAlign: TextAlign.center,
                                            style: GoogleFonts.openSans(
                                              textStyle: TextStyle(decoration: TextDecoration.underline,color: primaryColorOfApp, letterSpacing: .5,fontSize: 16),)
                                        ),

                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 20,),
                            Container(
                              color: Colors.transparent,
                              height: 60,
                              width: MediaQuery.of(context).size.width,
                              child: FlatButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                onPressed: () {},
                                color: primaryColorOfApp,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        "Make Your First Trade :",textAlign:TextAlign.center,
                                        style: GoogleFonts.openSans(
                                          textStyle: TextStyle(color: Colors.white, letterSpacing: .5,fontSize: 16,fontWeight: FontWeight.bold),)
                                    ),
                                    Icon(Icons.arrow_right,color: Colors.white,size: 40.0,),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.transparent,
                      height: 60,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        onPressed: () {

                        },
                        color: primaryColorOfApp,
                        child: Text(
                            "Open F&O Account",textAlign: TextAlign.center,
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(color: Colors.white, letterSpacing: .5,fontSize: 16,fontWeight: FontWeight.bold),)
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      color: Colors.transparent,
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        onPressed: () {},
                        color: primaryColorOfApp,
                        child: Text(
                            "Open Commodity",textAlign:TextAlign.center,
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(color: Colors.white, letterSpacing: .5,fontSize: 16,fontWeight: FontWeight.bold),)
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      color: Colors.transparent,
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        onPressed: () {},
                        color: primaryColorOfApp,
                        child: Text(
                            "Add a Nominee",textAlign:TextAlign.center,
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(color: Colors.white, letterSpacing: .5,fontSize: 16,fontWeight: FontWeight.bold),)
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      color: Colors.transparent,
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        onPressed: () {},
                        color: primaryColorOfApp,
                        child: Text(
                            "View Form",textAlign:TextAlign.center,
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(color: Colors.white, letterSpacing: .5,fontSize: 16,fontWeight: FontWeight.bold),)
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}