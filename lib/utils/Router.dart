import 'package:angel_broking_demo/nuniyo_screens/nuniyo_web_view.dart';
import 'package:angel_broking_demo/extra_demo_screens/web_view.dart';
import 'package:angel_broking_demo/nuniyo_screens/nuniyo_aadhar_kyc_screen.dart';
import 'package:angel_broking_demo/nuniyo_screens/nuniyo_bank_email_pan_validation_screen.dart';
import 'package:angel_broking_demo/nuniyo_screens/nuniyo_congrats_screen.dart';
import 'package:angel_broking_demo/nuniyo_screens/nuniyo_esign_screen.dart';
import 'package:angel_broking_demo/nuniyo_screens/nuniyo_mobile_validation_screen.dart';
import 'package:angel_broking_demo/nuniyo_screens/nuniyo_options_screen.dart';
import 'package:angel_broking_demo/nuniyo_screens/nuniyo_options_screen_two.dart';
import 'package:angel_broking_demo/nuniyo_screens/nuniyo_personal_details_screen.dart';
import 'package:angel_broking_demo/nuniyo_screens/nuniyo_splash_screen.dart';
import 'package:angel_broking_demo/nuniyo_screens/nuniyo_upload_documents_and_signature.dart';
import 'package:angel_broking_demo/nuniyo_screens/nuniyo_webcam_screen.dart';
import 'package:flutter/material.dart';

/*
1)contact
2)email
3)market segment
4)digiloc
5)personal
6) docupload
7) esign
8) application status
 */

class ScreenRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      //0
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      //1
      case '/mobilevalidationscreen':
        return MaterialPageRoute(builder: (_) => MobileValidationLoginScreen());
      //2
      case '/bankemailpanvalidationscreen':
        return MaterialPageRoute(builder: (_) => BankPanEmailValidationScreen());
      //3
      case '/optionsscreen':
        return MaterialPageRoute(builder: (_) => OptionsScreen());
      case '/optionsscreen2':
        return MaterialPageRoute(builder: (_) => OptionsScreenTwo());
      //4
      case '/aadharkycscreen':
        return MaterialPageRoute(builder: (_) => AadharKYCScreen());
      //5
      case '/personaldetailsscreen':
        return MaterialPageRoute(builder: (_) => PersonalDetailsScreen());
      //6
      case '/webcamscreen':
        return MaterialPageRoute(builder: (_) => WebCamScreen());
      //7
      case '/uploaddocumentscreen':
        return MaterialPageRoute(builder: (_) => UploadDocumentScreen());
      //8
      case '/esignscreen':
        return MaterialPageRoute(builder: (_) => EsignScreen());
      //9
      case '/congratsscreen':
        return MaterialPageRoute(builder: (_) => CongratsScreen());
      //EXTRA
      case '/webview':
        return MaterialPageRoute(builder: (_) => BrowserViewX());
    default:
      return MaterialPageRoute(builder: (_) => MobileValidationLoginScreen());
    }
  }
}