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

  /// NOTE : (Make Sure DOT NET BACKEND IS RUNNING ON LOCALHOST)

  //BASE URL : When Run In Android Emulators
  //final String BASE_API_URL = 'https://10.0.2.2:5001';

  //BASE URL : When Run In Web
  final String BASE_API_URL = 'https://localhost:5001';

  final String BASE_API_URL_2 = 'http://localhost:44333';

  final String BASE_API_URL_3 = 'http://localhost:44330';

  final String BASE_API_LINK_URL = 'https://api.nuniyo.tech';

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
    var request = http.Request('POST', Uri.parse('https://api.nuniyo.tech/api/lead/Verify_OTP'));
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
      print("YOUR JWT TOKEN :"+result_Description);
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

  Future<void> EKYCPanAuthenticationNSDL(String panCardNumber) async {
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('$BASE_API_URL_3/api/NsdlPan/NSDLeKYCPanAuthentication'));
    request.body = json.encode({
      "pan_no": panCardNumber,
      "full_name": "",
      "date_of_birth": ""
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

  Future<void> CVLKRAGetPanStatus(String panCardNumber) async{
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('$BASE_API_URL_3/v1/api/cvlkra/Get_PanStatus'));
    request.body = json.encode({
      "pan_No": panCardNumber,
      "method_Name": "Get_PanStatus"
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

  Future<void> VerifyEmail(String JWTToken , String phoneNumber , String emailID) async{
    var headers = {
      'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI4Nzc5NTU5ODk4IiwiZXhwIjoxNjMwOTQwOTQ5fQ.PLvorGG52kPNVxFf6z6dHaTX__uCipHgbkePZSyW5EI',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://api.nuniyo.tech/api/email/Email_Status'));
    request.body = json.encode({
      "mobile_No": "8779559898",
      "email": "ashrafksalim1@gmail.com",
      "method_Name": ""
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


  ///Mobile Validation API
  Future<String> fetchOTP(String phoneNumber) async {
    var request = http.Request('POST', Uri.parse(BASE_API_URL+'/api/Lead/Read_Lead'));

    request.body = json.encode({
      "mobile_No": phoneNumber,
      "method_Name": "Check_Mobile_No"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String result = await response.stream.bytesToString();
      Map valueMap = jsonDecode(result);
      print(result);
      result = valueMap["result_Extra_Key"];
      print("Your OTP IS"+valueMap["result_Extra_Key"]);
      return result;
    }
    else {
      print(response.reasonPhrase);
      return "";
    }
  }

  //Email Validation API
  Future<void> fetchEmailOTP(String emailID) async {
    var request = http.Request('POST', Uri.parse('$BASE_API_URL/api/EmailAuthentication/EmailAuthentication'));
    request.body = json.encode({
      "send_Email": emailID,
      "user_Token": "sssss"
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
    var request = http.Request('GET', Uri.parse('https://ifsc.razorpay.com/BARB0DBGHTW'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
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