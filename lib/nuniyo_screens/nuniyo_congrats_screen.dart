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
                            "Add a Nominee",textAlign:TextAlign.center,
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(color: Colors.white, letterSpacing: .5,fontSize: 16,fontWeight: FontWeight.bold),)
                        ),
                      ),
                    ),
                    SizedBox(height: 30,),
                    ///Card Box
                    Container(
                      height: 250.0,
                      width: MediaQuery.of(context).size.width,
                      decoration: new BoxDecoration(
                      boxShadow: [ //background color of box
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 25.0, // soften the shadow
                          spreadRadius: 5.0, //extend the shadow
                        )
                      ],
                      ),
                      child: Container(
                        height: 80,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              ListTile(
                                minLeadingWidth: 0.0,
                                leading: Icon(Icons.person_outline_outlined),
                                title: Text("Lorem Ipsum",style: GoogleFonts.openSans(
                                  textStyle: TextStyle(color: Colors.black, letterSpacing: .5,fontSize: 14),
                                ),),
                              ),
                              Row(
                                children: [
                                  SizedBox(width:15.0),
                                  Icon(Icons.card_giftcard,color:Colors.grey),
                                  SizedBox(width:14.0),
                                  Text("Lorem Ipsum",style: GoogleFonts.openSans(
                                    textStyle: TextStyle(color: Colors.black, letterSpacing: .5,fontSize: 14),
                                  ),),
                                  SizedBox(width: 40,),
                                  Icon(Icons.male,color:Colors.grey),
                                  SizedBox(width:15.0),
                                  Text("Male",style: GoogleFonts.openSans(
                                    textStyle: TextStyle(color: Colors.black, letterSpacing: .5,fontSize: 14),
                                  ),),
                                ],
                              ),
                              ListTile(
                                minLeadingWidth: 0.0,
                                leading: Icon(Icons.message),
                                title: Text("Lorem Ipsum",style: GoogleFonts.openSans(
                                  textStyle: TextStyle(color: Colors.black, letterSpacing: .5,fontSize: 14),
                                ),),
                              ),
                              ListTile(
                                minLeadingWidth: 0.0,
                                leading: Icon(Icons.location_on),
                                title: Text("Lorem Ipsum",style: GoogleFonts.openSans(
                                  textStyle: TextStyle(color: Colors.black, letterSpacing: .5,fontSize: 14),
                                ),),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10,),
                          Text("Your PAN",style: GoogleFonts.openSans(
                            textStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, letterSpacing: .5,fontSize: 24),
                          ),),
                          SizedBox(height: 10,),
                          Text("HCAPK4256Y",style: GoogleFonts.openSans(
                            textStyle: TextStyle(color: Colors.black,letterSpacing: .5,fontSize: 20),
                          ),),
                          SizedBox(height: 10,),
                          Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",style: GoogleFonts.openSans(
                            textStyle: TextStyle(color: Colors.black,letterSpacing: .5,fontSize: 16),
                          ),),
                        ],
                      ),
                    ),
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
