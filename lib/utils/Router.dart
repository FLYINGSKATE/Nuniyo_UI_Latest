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

class ScreenRouter {

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      //1
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      //2
      case '/mobilevalidationscreen':
        return MaterialPageRoute(builder: (_) => MobileValidationLoginScreen());
      //3
      case '/bankemailpanvalidationscreen':
        return MaterialPageRoute(builder: (_) => BankPanEmailValidationScreen());
      //4
      case '/personaldetailsscreen':
        return MaterialPageRoute(builder: (_) => PersonalDetailsScreen());
      //5
      case '/optionsscreen':
        return MaterialPageRoute(builder: (_) => OptionsScreen());
      //6
      case '/aadharkycscreen':
        return MaterialPageRoute(builder: (_) => AadharKYCScreen());
      //7
      case '/webcamscreen':
        return MaterialPageRoute(builder: (_) => WebCamScreen());
      //8
      case '/uploaddocumentscreen':
        return MaterialPageRoute(builder: (_) => UploadDocumentScreen());
      //9
      case '/esignscreen':
        return MaterialPageRoute(builder: (_) => EsignScreen());
      //extra
      case '/optionsscreen2':
        return MaterialPageRoute(builder: (_) => OptionsScreenTwo());
      //10
      case '/congratsscreen':
        return MaterialPageRoute(builder: (_) => CongratsScreen());
    default:
      return MaterialPageRoute(builder: (_) => MobileValidationLoginScreen());
    }
  }
}