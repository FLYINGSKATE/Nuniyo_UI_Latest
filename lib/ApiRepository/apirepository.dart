/*This class file consists of calls to API Endpoints*/
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiRepo {

  var headers = {
    'Content-Type': 'application/json'
  };

  //BASE URL : When Run In Android Emulators
  //final String BASE_API_URL = 'https://10.0.2.2:5001';

  //BASE URL : When Run In Web
  final String BASE_API_URL = 'https://localhost:5001';

  String API_TOKEN = "";

  final String BASE_API_URL_2 = 'http://localhost:44333';

  final String BASE_API_URL_3 = 'http://localhost:44330';

  final String BASE_API_LINK_URL = 'https://api.nuniyo.tech';

  SharedPreferences? preferences;

  //Send Mobile Number to Database
  Future<bool> SendMobileNumber(String phoneNumber) async {
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('$BASE_API_LINK_URL/api/lead/Read_Lead'));
    request.body = json.encode({
      "mobile_No": phoneNumber,
      "method_Name": "Check_Mobile_No"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return true;
    }
    else {
      print(response.reasonPhrase);
      return false;
    }
  }

  Future<bool> VerifyOTP(String phoneNumber,String userEnteredOTP) async{
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('$BASE_API_LINK_URL/api/lead/Verify_OTP'));
    request.body = json.encode({
      "mobile_No": phoneNumber,
      "otp": userEnteredOTP,
      "method_Name": "Check_OTP"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String result = await response.stream.bytesToString();
      Map valueMap = jsonDecode(result);
      print(valueMap);
      print(result);
      int result_Id = valueMap["res_Output"][0]["result_Id"];
      String result_Description = valueMap["res_Output"][0]["result_Description"];
      print("Your OTP IS VERIFIED OR NOT DEPENDS ON "+result_Id.toString());
      API_TOKEN = result_Description;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("API_TOKEN", API_TOKEN);
      print("YOUR JWT TOKEN :"+API_TOKEN);
      if(result_Id==1){
        return true;
      }
      else{
        return false;
      }
    }
    else {
      print(response.reasonPhrase);
      return false;
    }
  }

  Future<void> CVLKRAGetPanStatus(String panCardNumber) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String awt_Token= prefs.getString('API_TOKEN');
    print(panCardNumber);
    print("AWT STORED INSIDE SHARED PREFERENCES :" + prefs.getString('API_TOKEN'));
    print("AWT STORED INSIDE SHARED PREFERENCES :" + awt_Token);
    print("Calling Verify PAN KRA Using API"+awt_Token);
    var headers = {
      'Authorization': 'Bearer $awt_Token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('$BASE_API_LINK_URL/api/cvlkra/Get_PanStatus'));
    request.body = json.encode({
      "pan_No": panCardNumber,
      "method_Name": "Get_PanStatus"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String result = await response.stream.bytesToString();
      print(result);
      Map valueMap = jsonDecode(result);
      print(valueMap);
      print(result);
      int result_Id = valueMap["res_Output"][0]["result_Id"];
      print("STATUS : "+result_Id.toString());
      if(result_Id==1){
        return;
      }
      else{
        return;
      }
    }
    else {
      print(response.reasonPhrase);
      return;
    }

  }

  Future<bool> PostPersonalDetails(String phoneNumber , String fatherName, String motherName , String income,String gender,String maritial_Status,
      String politicalExposed , String occupation , String tradingExperience , String education) async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String awt_Token= prefs.getString('API_TOKEN');

    print("AWT STORED INSIDE SHARED PREFERENCES :" + prefs.getString('API_TOKEN'));
    print("AWT STORED INSIDE SHARED PREFERENCES :" + awt_Token);
    print("Posting Personal Details Using API :"+awt_Token);

    var headers = {
      'Authorization': 'Bearer $awt_Token',
      'Content-Type': 'application/json'
    };

    var request = http.Request('POST', Uri.parse('http://localhost:44330/v1/api/personal/Personal_Details'));

    request.body = json.encode({
      "mobile_No": phoneNumber,
      "father_Name": fatherName,
      "mother_Name": motherName,
      "income": income,
      "gender": gender,
      "marital_Status": maritial_Status,
      "politicalExposed": politicalExposed,
      "occupation": occupation,
      "trading_Experience": tradingExperience,
      "education": education
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return true;
    }
    else {
      print(response.reasonPhrase);
      return false;
    }
  }

  Future<void> OnPaymentSuccessPostToDatabase(int paymentPrice, String phoneNumber,String paymentID) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String awt_Token= prefs.getString('API_TOKEN');
    print(paymentID);
    print("AWT STORED INSIDE SHARED PREFERENCES :" + prefs.getString('API_TOKEN'));
    print("AWT STORED INSIDE SHARED PREFERENCES :" + awt_Token);
    print("Calling POST PAYMENT SUCCESS Using API"+awt_Token);
    var headers = {
      'Authorization': 'Bearer $awt_Token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('$BASE_API_LINK_URL/api/RazorPay/RazorPayStatus'));
    request.body = json.encode({
      "inr": paymentPrice,
      "currency": "INR",
      "mobile_No": phoneNumber,
      "merchantTransactionId": paymentID
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future<bool> VerifyEmail(String phoneNumber , String emailID) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String awt_Token= prefs.getString('API_TOKEN');
    print("AWT STORED INSIDE SHARED PREFERENCES :" + prefs.getString('API_TOKEN'));
    print("AWT STORED INSIDE SHARED PREFERENCES :" + awt_Token);
    print("Calling Verify Email Using API"+awt_Token);
    var headers = {
      'Authorization': 'Bearer $awt_Token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('$BASE_API_LINK_URL/api/email/Email_Status'));
    request.body = json.encode({
      "mobile_No": phoneNumber,
      "email": emailID,
      "method_Name": ""
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String result = await response.stream.bytesToString();
      print(result);
      Map valueMap = jsonDecode(result);
      print(valueMap);
      print(result);
      int status = valueMap["status"];
      print("STATUS : "+status.toString());
      if(status==200){
        return true;
      }
      else{
        return false;
      }
    }
    else {
      print(response.reasonPhrase);
      return false;
    }
  }

  Future<bool> VerifyPAN(String phoneNumber , String panNumber) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String awt_Token= prefs.getString('API_TOKEN');
    print(panNumber);
    print("AWT STORED INSIDE SHARED PREFERENCES :" + prefs.getString('API_TOKEN'));
    print("AWT STORED INSIDE SHARED PREFERENCES :" + awt_Token);
    print("Calling Verify PAN Using API"+awt_Token);
    var headers = {
      'Authorization': 'Bearer $awt_Token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('$BASE_API_LINK_URL/api/NsdlPan/NSDLeKYCPanAuthentication'));
    request.body = json.encode({
      "pan_No": panNumber,
      "mobile_No": phoneNumber,
      "method_Name": "PAN_details"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String result = await response.stream.bytesToString();
      print(result);
      Map valueMap = jsonDecode(result);
      print(valueMap);
      print(result);
      int result_Id = valueMap["res_Output"][0]["result_Id"];
      print("STATUS : "+result_Id.toString());
      if(result_Id==1){
        return true;
      }
      else{
        return false;
      }
    }
    else {
      print(response.reasonPhrase);
      return false;
    }
  }

  ///Bank Validation API - NEW
  Future<bool> fetchIsBankValid(String bankAccountNumber,String ifscCode) async {
    var request = http.Request('POST', Uri.parse('$BASE_API_URL/VerifyBankAccount?beneficiary_account_no=$bankAccountNumber&beneficiary_ifsc=$ifscCode'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return true;
    }
    else {
      print(response.reasonPhrase);
      return false;
    }
  }

  ///PAN Validation API
  Future<bool> fetchIsPanValid(String fullName,String dOB,String panNumber) async {
    fullName = fullName.replaceAll(' ', '%20');
    var request = http.Request('POST', Uri.parse(
        '$BASE_API_URL/PanAuthentication?'
            'pan_no=$panNumber&full_name=$fullName&date_of_birth=$dOB'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String result = await response.stream.bytesToString();
      Map valueMap = jsonDecode(result);
      print(result);
      if (valueMap["is_pan_dob_valid"] && valueMap["name_matched"]) {
        print("YOUR PAN CARD IS VALID");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        fullName = fullName.replaceAll('%20',' ');
        await prefs.setString('full_name', fullName);
        print("Full Name Has Been Set To :" + prefs.getString('full_name'));
        return true;
      }
      else {
        print("Something went wrong");
        return false;
      }
    }
    else {
      print(response.reasonPhrase);
      return false;
    }
  }

  ///OCR Validation API
  Future<bool> PanOCRValidation(String imagePath,var imageP) async{
    List<int> _selectedFile = await imageP.readAsBytes();
    var request;
    if(kIsWeb){
      request = http.MultipartRequest('POST', Uri.parse(BASE_API_URL+'/api/DocumentOCR/OCR'));
      request.files.add(await http.MultipartFile.fromBytes('front_part', _selectedFile,
          contentType: new MediaType('application', 'octet-stream'),
          filename: "file_up"));
      request.headers.addAll(headers);
    }
    else{
      request = http.MultipartRequest('POST', Uri.parse('http://localhost:44300/api/user/login/OCR'));
      request.headers.addAll(headers);
    }

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return true;
    }
    else {
      print(response.reasonPhrase);
      return false;
    }
  }

  ///Digital Pad Signature Upload API - (INCOMPLETE)
  Future<bool> DigitalSignatureUploadAPI(String imagePath,var imageP) async{
    List<int> _selectedFile = await imageP.readAsBytes();
    var request;
    if(kIsWeb){
      request = http.MultipartRequest('POST', Uri.parse(BASE_API_URL+'/api/DocumentOCR/OCR'));
      request.files.add(await http.MultipartFile.fromBytes('front_part', _selectedFile,
          contentType: new MediaType('application', 'octet-stream'),
          filename: "file_up"));
      request.headers.addAll(headers);
    }
    else{
      request = http.MultipartRequest('POST', Uri.parse('http://localhost:44300/api/user/login/OCR'));
      request.headers.addAll(headers);
    }

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return true;
    }
    else {
      print(response.reasonPhrase);
      return false;
    }
  }

  Future<void> searchIFSCCodes() async{
    var headers = {
      'Authorization': 'Bearer',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('http://localhost:44330/v1/api/ifscmaster/IFSC_Master_Search'));
    request.body = json.encode({
      "bank": "icici",
      "ifsc": "string",
      "branch": "andheri"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future<String> isValidIFSC(String ifscCode) async{
    var request = http.Request('GET', Uri.parse('https://ifsc.razorpay.com/$ifscCode'));
    //var request = http.Request('GET', Uri.parse('https://ifsc.razorpay.com/BARB0DBGHTW'));
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String result = await response.stream.bytesToString();
      return result;
    }
    else {
      print(response.reasonPhrase);
      return "Not Found";
    }
  }

  ///////////////OLD FUNCTIONS////////////////
    //request.body = json.encode({
    //  "pan_no": "HCAPK4259Q",
    //  "full_name": "KHAN ASHRAF SALIM",
    //  "date_of_birth": "31-03-2000"
    //});
    ///BANK AND PAN : 39981374255
    ///IFSC :SBIN0003671
///
/// //OLD ONE Bank Validation API
//   /*Future<bool> fetchIsBankValid(String bankAccountNumber,String ifscCode) async {
//
//     var request = http.Request('POST', Uri.parse(
//         '$BASE_API_URL/VerifyBankAccount?beneficiary_account_no=$bankAccountNumber&beneficiary_ifsc=$ifscCode'));
//
//     request.headers.addAll(headers);
//
//     http.StreamedResponse response = await request.send();
//
//     if (response.statusCode == 200) {
//       String result = await response.stream.bytesToString();
//       Map valueMap = jsonDecode(result);
//       print(result);
//       if(valueMap["verified"]){
//         print("YOUR BANK IS VALIDATED");
//         return true;
//       }
//       else{
//         print("Something went wrong");
//         return false;
//       }
//     }
//     else {
//       print(response.reasonPhrase);
//       return false;
//     }
//   }*/

}