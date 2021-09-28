/*This class file consists of calls to API Endpoints*/
import 'dart:io';
import 'package:angel_broking_demo/globals.dart' as globals;
import 'package:angel_broking_demo/utils/localstorage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalApiRepo {

  var headers = {
    'Content-Type': 'application/json'
  };

  //BASE URL : When Run In Android Emulators
  //final String BASE_API_URL = 'https://10.0.2.2:5001';

  //BASE URL : When Run In Web
  String API_TOKEN = "";

  final String BASE_WEB_URL = 'http://localhost:44330';

  final String BASE_API_LINK_URL = 'https://api.nuniyo.tech';

  final String BASE_ANDROID_EMULATOR_URL = "https://10.0.2.2:44330";

  SharedPreferences? preferences;


  Future<String> GetCurrentJWTToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String JWT_TOKEN= prefs.getString('API_TOKEN');
    print("AWT STORED INSIDE SHARED PREFERENCES :" + JWT_TOKEN);
    return JWT_TOKEN;
  }


  //////////LOCAL BACKEND APIS TO BIND
  Future<bool> PostPersonalDetailsLOCAL(String phoneNumber , String fatherName, String motherName , String income,String gender,String maritial_Status,
      String politicalExposed , String occupation , String tradingExperience , String education) async{

    var headers = {
      'Content-Type': 'application/json',
    };

    var request = http.Request('POST', Uri.parse('http://localhost:44330/v1/api/personal/Personal_Details'));
    request.body = json.encode({
      "mobile_No": phoneNumber,
      "father_Name": fatherName,
      "mother_Name": motherName,
      "income": income,
      "gender": gender,
      "marital_Status": maritial_Status,
      "politically_Exposed": politicalExposed,
      "occupation": occupation,
      "trading_Experience": tradingExperience,
      "education": education
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      String result = await response.stream.bytesToString();
      Map valueMap = jsonDecode(result);
      print(valueMap);
      int result_Id = valueMap["res_Output"]["result_Id"];
      print(result_Id);
      print(valueMap["res_Output"][0]["lead_Id"]);
      await StoreLocal().StoreLeadIdToLocalStorage(valueMap["res_Output"][0]["lead_Id"]);
      print("LEAD ID SAVED LOCALLY IS :"+await StoreLocal().getLeadIdFromLocalStorage().toString());
      if(result_Id == 1){
        return true;
      }
      return false;
    }
    else {
      print(response.reasonPhrase);
      return false;
    }
  }


  Future<void> KRALOCAL(String panNumber,String phoneNumber) async{
    print("Calling KRA LOCAL USING");
    print(panNumber);
    print(phoneNumber);

    String JWT_TOKEN= await GetCurrentJWTToken();
    print("Calling Verify PAN Using API"+JWT_TOKEN);
    var headers = {
      'Authorization': 'Bearer $JWT_TOKEN',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('http://localhost:44330/api/cvlkra/Get_PanStatus'));
    request.body = json.encode({
      "pan_No": panNumber,
      "mobile_No": phoneNumber
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print("KRA LOCAL");
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future<void> SolicitLocal(String panNumber,String dOB) async{
    print("Calling Solicit LOCAL USING");
    print(panNumber);
    print(dOB);

    String JWT_TOKEN= await GetCurrentJWTToken();
    print("Calling Verify SOLICIT Using API"+JWT_TOKEN);
    var headers = {
      'Authorization': 'Bearer $JWT_TOKEN',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('http://localhost:44330/api/cvlkra/SolicitPANDetailsFetchALLKRA'));
    request.body = json.encode({
      "apP_PAN_NO": "HCAPK4259Q",
      "apP_DOB_INCORP": "31-03-2000"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print("SOLICIT LOCAL");
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }

  }

  Future<void> postStageIDLocal() async{
    String JWT_TOKEN= await GetCurrentJWTToken();
    print("Calling Stage ID Using API"+JWT_TOKEN);
    var headers = {
      'Authorization': 'Bearer $JWT_TOKEN',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('http://localhost:44330/v1/api/lead/Update_StageId'));
    request.body = json.encode({
      "stageId": 1,
      "mobile_No": "8268405887"
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

  ///Verify Bank Details

  Future<bool> verifyBankAccountLocal(String accountNo,String ifscNo) async{
    print("IFSC CODE"+ifscNo);
    print("Account No"+accountNo);

    String lead_id = await StoreLocal().getLeadIdFromLocalStorage();
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('http://localhost:44330/v1/api/bank/VerifyBankAccount'));
    request.body = json.encode({
      "org_Id": "S001",
      "lead_Id": "$lead_id",
      "beneficiary_account_no": "$accountNo",
      "beneficiary_ifsc": "$ifscNo"
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
      print("RESULT ID : "+result_Id.toString());
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

  Future<String> getIFSCDetailsLocal(String ifscCode) async{
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('http://localhost:44330/v1/api/bank/GetIfscDetails'));
    request.body = json.encode({
      "ifsc": "$ifscCode"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String result = await response.stream.bytesToString();
      //GET IFSC DATA HERE
      print(result);
      return result;
    }
    else {
      print(response.reasonPhrase);
      return "Not Found";
    }
  }

  Future<void> ConfirmIFSCDetailsLocal() async{}

  Future<bool> GetPanStatusLocal(String panCardNumber) async{
    String lead_id = await StoreLocal().getLeadIdFromLocalStorage();
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('http://localhost:44330/v1/api/cvlkra/Get_PanStatus'));
    request.body = json.encode({
      "pan_No": "$panCardNumber",
      "lead_Id": "$lead_id",
      "org_Id": "S001"
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

  Future<void> SolicitPANDetailsFetchALLKRALocal(String panCard) async{
    String lead_id = await StoreLocal().getLeadIdFromLocalStorage();
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('http://localhost:44330/v1/api/cvlkra/SolicitPANDetailsFetchALLKRA'));
    request.body = json.encode({
      "lead_Id": "$lead_id",
      "paN_NO": "$panCard",
      "org_Id": "S001",
      "date_Of_birth": "31-03-2000"
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

  Future<void> InsertUpdateKYCRecordLocal() async{}
  Future<void> GenerateCodeChallengeLocal() async{}
  Future<void> VerifyDigiLockerAccountLocal() async{}
  Future<void> GetAuthorizationCodeLocal() async{}
  Future<void> DocumentUploadLocal() async{}

  Future<bool> DocumentUploadPANLocal(String imagePath,var imageP) async{
    List<int> _selectedFile = await imageP.readAsBytes();
    var request;
    if(kIsWeb){
      request = http.MultipartRequest('POST', Uri.parse(BASE_API_LINK_URL+'/api/DocumentOCR/OCR'));
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

  Future<void> DocumentUploadSignatureLocal() async{}

  Future<bool>Email_StatusLocal(String emailID) async{
    String lead_id = await StoreLocal().getLeadIdFromLocalStorage().toString();
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('http://localhost:44330/v1/api/email/Email_Status'));
    request.body = json.encode({
      "org_Id": "S001",
      "lead_Id": "$lead_id",
      "email": "$emailID",
      "method_Name": "Email_Status"
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

  Future<bool> UpdateEmailLocal(String emailId) async{
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('http://localhost:44330/v1/api/email/Update_Email'));
    request.body = json.encode({
      "org_Id": "S001",
      "lead_Id": "T001211000006",
      "email": "$emailId",
      "method_Name": "Update_Email"
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
      print(result_Id);
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

  Future<Map<dynamic,dynamic>> IFSCMasterSearchLocal(String branchName , String branchLocation) async{
    Map valueMap = Map();
    var headers = {
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
      String result = await response.stream.bytesToString();
      valueMap = jsonDecode(result);
      print(valueMap);
      print(result);
      return valueMap;
    }
    else {
      print(response.reasonPhrase);
      return valueMap;
    }

  }
  Future<void> IPVOTPLocal() async{}
  Future<void> VerifyIPVOTPLocal() async{}
  Future<void> SaveIPVVideoLocal() async{}

  Future<bool> ReadLeadLocal(String mobileNo) async{
    var headers = {
      "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        // Required for cookies, authorization headers with HTTPS
      //"Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      'Content-Type': 'application/json',
    };
    var request = http.Request('POST', Uri.parse('http://localhost:44330/v1/api/lead/Read_Lead'));
    request.body = json.encode({
      "mobile_No": "$mobileNo",
      "method_Name": "Check_Mobile_No",
      "org_Id": "S001",
      "flow_Id": "M001001",
      "current_Stage_Id": "C002001"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String result = await response.stream.bytesToString();
      Map valueMap = jsonDecode(result);
      print(valueMap);
      print(result);
      int result_Id = valueMap["res_Output"][0]["result_Id"];
      print(result_Id);
      String lead_id = valueMap["res_Output"][0]["lead_Id"];
      print(lead_id);
      await StoreLocal().StoreLeadIdToLocalStorage(lead_id);
      String savedLead = await StoreLocal().getLeadIdFromLocalStorage();
      print("LEAD ID SAVED LOCALLY IS :"+savedLead);

      if(result_Id == 1){
        return true;
      }
      return false;
    }
    else {
      print(response.reasonPhrase);
      return false;
    }
  }


  Future<bool> VerifyOTPLocal(String mobileNumber,String userEnteredOTP) async{
    var headers = {
      'Content-Type': 'application/json'
    };

    var request = http.Request('POST', Uri.parse('http://localhost:44330/v1/api/lead/Verify_OTP'));
    request.body = json.encode({
      "mobile_No": "$mobileNumber",
      "otp": "$userEnteredOTP",
      "method_Name": "Check_OTP",
      "org_Id": "S001",
      "flow_Id": "M001001",
      "current_Stage_Id": "715439"
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String result = await response.stream.bytesToString();
      Map valueMap = jsonDecode(result);
      print(valueMap);
      print(result);
      int result_Id = valueMap["res_Output"][0]["result_Id"];
      //String result_Description = valueMap["res_Output"][0]["result_Description"];
      print("Your OTP IS VERIFIED OR NOT DEPENDS ON "+result_Id.toString());
      //API_TOKEN = result_Description;
      //SharedPreferences prefs = await SharedPreferences.getInstance();
      //await prefs.setString("API_TOKEN", API_TOKEN);
      //print("YOUR JWT TOKEN :"+API_TOKEN);
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

  Future<void> LeadLocationLocal() async{}

  Future<void> UpdateStageIdLocal() async{}

  Future<void> NSDLeKYCPanAuthenticationLocal() async{
    String lead_id = await StoreLocal().getLeadIdFromLocalStorage();
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('http://localhost:44330/v1/api/PanAuthenticationController/PanAuthentication'));
    request.body = json.encode({
      "pan_No": "HCAPk4259Q",
      "lead_Id": "T001211000006",
      "org_Id": "S001",
      "method_Name": "NSDLeKYCPanAuthentication"
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
  Future<void> PanAuthenticationLocal() async{}
  Future<void> PersonalDetailsLocal() async{}

  Future<void> RazorPayStatusLocal(int amountPayed,String currency , String mobileNumber, String merchantTransactionID) async{
    var headers = {
      'Content-Type': 'text/plain'
    };
    var request = http.Request('GET', Uri.parse('http://localhost:44330/v1/api/razorpay/RazorPayStatus'));
    request.body = '''{\r\n  "inr": 0,\r\n  "currency": "string",\r\n  "mobile_No": "string",\r\n  "merchantTransactionId": "string"\r\n}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }
  }
}