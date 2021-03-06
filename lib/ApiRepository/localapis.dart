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

import '../globals.dart';

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


  Future<void> SetMobileOTP(String otp) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("MOBILE_OTP",otp);
    print("Your OTP is :"+prefs.getString("MOBILE_OTP"));
  }

  Future<void> SetStageId(String stage_id) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(STAGE_KEY,stage_id);
    print("Your Stage id :"+prefs.getString(STAGE_KEY));
  }

  Future<void> SetJwtToken(String token) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(JWT_TOKEN_KEY,token);
    print("Your JWT is :"+prefs.getString(JWT_TOKEN_KEY));
  }

  Future<String> GetCurrentJWTToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jwt_token= prefs.getString(JWT_TOKEN_KEY);
    print("JWT STORED INSIDE SHARED PREFERENCES :" + jwt_token);
    return jwt_token;
  }

  Future<String> GetLeadId() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lead_id= prefs.getString(LEAD_ID_KEY);
    print("LEAD ID STORED INSIDE SHARED PREFERENCES :" + lead_id);
    return lead_id;
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

  Future<void> UpdateStage_Id() async{

    String jwt_token= await GetCurrentJWTToken();
    print("Calling UpdateStage_Id Using API"+jwt_token);

    String lead_id = await GetLeadId();
    print("Get UpdateStage_Id for Lead ID : "+lead_id);

    var headers = {
      'Authorization': 'Bearer $jwt_token',
      'Content-Type': 'application/json'
    };

    var request = http.Request('POST', Uri.parse('https://api.nuniyo.tech/api/lead/Update_StageId'));
    request.body = json.encode({
      "method_Name": "Update_Stage_Id",
      "org_Id": ORG_ID,
      "lead_Id": "$lead_id"
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
      String stage_id = valueMap["res_Output"][0]["stage_Id"];
      await SetStageId(stage_id);
    }
    else {
      print(response.reasonPhrase);
    }

  }

  ///Verify Bank Details
  Future<bool> verifyBankAccountLocal(String accountNo,String ifscNo) async{

    String jwt_token= await GetCurrentJWTToken();
    print("Calling Penny Drop Using API"+jwt_token);

    String lead_id = await GetLeadId();
    print("Get Penny Drop for Lead ID : "+lead_id);

    var headers = {
      'Authorization': 'Bearer $jwt_token',
      'Content-Type': 'application/json'
    };

    print("IFSC CODE"+ifscNo);
    print("Account No"+accountNo);
    print("Calling Penny Drop Using");

    var request = http.Request('POST', Uri.parse('$BASE_API_LINK_URL/api/bank/VerifyBankAccount'));
    request.body = json.encode({
      "org_Id": ORG_ID,
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

  Future<String> getIFSCDetails(String ifscCode) async{
    String jwt_token= await GetCurrentJWTToken();
    print("Calling IFSC DETAILS LOCAL Using API"+jwt_token);

    String lead_id = await GetLeadId();
    print("Get IFSC DETAILS LOCAL for Lead ID : "+lead_id);

    var headers = {
      'Authorization': 'Bearer $jwt_token',
      'Content-Type': 'application/json'
    };

    var request = http.Request('POST', Uri.parse('$BASE_API_LINK_URL/api/bank/GetIfscDetails'));
    request.body = json.encode({
      "ifsc": "$ifscCode"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String result = await response.stream.bytesToString();
      //GET IFSC DATA HERE
      print(result);
      if(result=="\"Not Found\"" || result =="Not Found"){
        return "Not Found";
      }
      else{
        return result;
      }
    }
    else {
      print(response.reasonPhrase);
      return "Not Found";
    }
  }

  Future<void> ConfirmIFSCDetailsLocal() async{}


  Future<Map<dynamic,dynamic>> GetPersonalDetails() async{
    Map valueMap = Map();
    String jwt_token= await GetCurrentJWTToken();
    print("Calling Get Personal Details Status Using API"+jwt_token);

    String lead_id = await GetLeadId();
    print("Get Personal Details for Lead ID : "+lead_id);

    var headers = {
      'Authorization': 'Bearer $jwt_token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('$BASE_API_LINK_URL/api/personal/Get_Personal_Details?Lead_Id=$lead_id'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String result = await response.stream.bytesToString();
      print(result);
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

  Future<bool> GetPanStatusLocal(String panCardNumber) async{
    String jwt_token= await GetCurrentJWTToken();
    print("Calling Get Pan Status Using API"+jwt_token);

    String lead_id = await GetLeadId();
    print("Get Pan Status for Lead ID : "+lead_id);

    var headers = {
      'Authorization': 'Bearer $jwt_token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('$BASE_API_LINK_URL/api/cvlkra/Get_PanStatus'));
    request.body = json.encode({
      "pan_No": "$panCardNumber",
      "lead_Id": "$lead_id",
      "org_Id": ORG_ID
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

      ///Save Pan Owner Name
      String result_description = valueMap["res_Output"][0]["result_Description"];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print("PAN OWNER NAME :"+result_description);
      prefs.setString("PAN_OWNER_NAME",result_description);


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

  Future<void> SolicitPANDetailsFetchALLKRALocal(String panCard,String dOB) async{
    String jwt_token= await GetCurrentJWTToken();
    print("Calling Solicit Pan Using API"+jwt_token);

    String lead_id = await GetLeadId();
    print("Solicit Pan for Lead ID : "+lead_id);

    var headers = {
      'Authorization': 'Bearer $jwt_token',
      'Content-Type': 'application/json'
    };

    var request = http.Request('POST', Uri.parse('$BASE_API_LINK_URL/api/cvlkra/SolicitPANDetailsFetchALLKRA'));
    request.body = json.encode({
      "lead_Id": "$lead_id",
      "paN_NO": "$panCard",
      "org_Id": ORG_ID,
      "date_Of_birth": "$dOB"
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

  Future<bool> DocumentUploadPANLocal(var imageP) async{



    List<int> _selectedFile = await imageP.readAsBytes();
    var request;
    if(kIsWeb){
      request = http.MultipartRequest('POST', Uri.parse('$BASE_API_LINK_URL/api/documentupload/Document_Upload_PAN'));
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

  Future<bool>Email_Status(String emailID) async{

    String jwt_token= await GetCurrentJWTToken();
    print("Calling Email Status Using API"+jwt_token);

    String lead_id = await GetLeadId();
    print("Email Status for Lead ID : "+lead_id.toString());

    var headers = {
      'Authorization': 'Bearer $jwt_token',
      'Content-Type': 'application/json'
    };

    var request = http.Request('POST', Uri.parse('$BASE_API_LINK_URL/api/email/Email_Status'));
    request.body = json.encode({
      "org_Id": ORG_ID,
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

  Future<bool> UpdateEmail(String emailId) async{
    String jwt_token= await GetCurrentJWTToken();
    print("Calling Update Email Using API"+jwt_token);

    String lead_id = await GetLeadId();
    print("Update Email Status for Lead ID : "+lead_id);

    var headers = {
      'Authorization': 'Bearer $jwt_token',
      'Content-Type': 'application/json'
    };

    var request = http.Request('POST', Uri.parse('$BASE_API_LINK_URL/api/email/Update_Email'));
    request.body = json.encode({
      "org_Id": ORG_ID,
      "lead_Id": "$lead_id",
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
    String jwt_token= await GetCurrentJWTToken();
    print("Calling Update IFSC SEARCH Using API"+jwt_token);

    String lead_id = await GetLeadId();
    print("IFSC Search for Lead ID : "+lead_id);

    var headers = {
      'Authorization': 'Bearer $jwt_token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('$BASE_API_LINK_URL/api/ifscmaster/IFSC_Master_Search'));
    request.body = json.encode({
      "bank": "$branchName",
      "ifsc": "string",
      "branch": "$branchLocation"
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
  Future<String> IPVOTPLocal() async{
    String jwt_token= await GetCurrentJWTToken();
    print("Calling IPVOTP LOCAL Using API"+jwt_token);

    String lead_id = await GetLeadId();
    print("IPVOTP LOCAL for Lead ID : "+lead_id);

    var headers = {
      'Authorization': 'Bearer $jwt_token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('$BASE_API_LINK_URL/api/in_person_verification/IPV_OTP'));
    request.body = json.encode({
      "lead_Id": "$lead_id",
      "method_Name": "IPV_OTP",
      "org_Id": ORG_ID
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String result = await response.stream.bytesToString();
      Map valueMap = jsonDecode(result);
      print(valueMap);
      print(result);
      return "valueMap";
    }
    else {
      print(response.reasonPhrase);
      return "valueMap";
    }
  }

  Future<void> VerifyIPVOTPLocal() async{}
  Future<void> SaveIPVVideoLocal() async{}

  Future<bool> ReadLead(String mobileNo) async{
    var headers = {
      "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        // Required for cookies, authorization headers with HTTPS
      //"Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      'Content-Type': 'application/json',
    };
    var request = http.Request('POST', Uri.parse('$BASE_API_LINK_URL/api/lead/Read_Lead'));
    request.body = json.encode({
      "mobile_No": "$mobileNo",
      "method_Name": "Check_Mobile_No",
      "org_Id": ORG_ID,
      "flow_Id": FLOW_ID,
      "current_Stage_Id": CURRENT_STAGE_ID
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

      String otp = valueMap["res_Output"][0]["stage_Id"];
      await SetMobileOTP(otp);

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

  Future<bool> VerifyOTP(String mobileNumber,String userEnteredOTP) async{
    var headers = {
      'Content-Type': 'application/json'
    };

    var request = http.Request('POST', Uri.parse('$BASE_API_LINK_URL/api/lead/Verify_OTP'));
    request.body = json.encode({
      "mobile_No": "$mobileNumber",
      "otp": "$userEnteredOTP",
      "method_Name": "Check_OTP",
      "org_Id": ORG_ID,
      "flow_Id": FLOW_ID,
      "current_Stage_Id": CURRENT_STAGE_ID
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String result = await response.stream.bytesToString();
      Map valueMap = jsonDecode(result);
      print(valueMap);
      print(result);
      int result_Id = valueMap["res_Output"][0]["result_Id"];
      //print("Your OTP IS VERIFIED OR NOT DEPENDS ON "+result_Id.toString());
      String stage_id = valueMap["res_Output"][0]["stage_Id"];
      String jwt_token = valueMap["res_Output"][0]["result_Description"];

      await SetStageId(stage_id);

      await SetJwtToken(jwt_token);

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

  Future<bool> NSDLeKYCPanAuthenticationLocal(String panCardNumber) async{
    String jwt_token= await GetCurrentJWTToken();
    print("Calling NSDL EKYC PAN Using API"+jwt_token);

    String lead_id = await GetLeadId();
    print("NSDL EKYC PAN for Lead ID : "+lead_id);

    var headers = {
      'Authorization': 'Bearer $jwt_token',
      'Content-Type': 'application/json'
    };

    var request = http.Request('POST', Uri.parse('$BASE_API_LINK_URL/api/nsdlpan/NSDLeKYCPanAuthentication'));
    request.body = json.encode({
      "pan_No": "$panCardNumber",
      "lead_Id": "$lead_id",
      "org_Id": ORG_ID,
      "method_Name": "NSDLeKYCPanAuthentication"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String result = await response.stream.bytesToString();
      Map valueMap = jsonDecode(result);
      print(valueMap);
      return true;
    }
    else {
      print(response.reasonPhrase);
      return false;
    }
  }

  Future<void> PanAuthenticationLocal() async{}

  Future<bool> PersonalDetailsLocal(String fatherName,String motherName,String income,String gender,String maritalStatus,String politicallyExposed,String occupation,String tradingExperience) async{
    String jwt_token= await GetCurrentJWTToken();
    print("Calling PERSONAL DETAILS  Using API KEY "+jwt_token);

    String lead_id = await GetLeadId();
    print("PERSONAL DETAILS for Lead ID : "+lead_id);

    var headers = {
      'Authorization': 'Bearer $jwt_token',
      'Content-Type': 'application/json'
    };

    var request = http.Request('POST', Uri.parse('$BASE_API_LINK_URL/api/personal/Personal_Details'));
    request.body = json.encode({
      "lead_Id": "$lead_id",
      "org_Id": globals.ORG_ID,
      "father_Name": "$fatherName",
      "mother_Name": "$motherName",
      "income": "$income",
      "gender": "$gender",
      "marital_Status": "$maritalStatus",
      "politically_Exposed": "$politicallyExposed",
      "occupation": "$occupation",
      "trading_Experience": "$tradingExperience",
      "education": "string"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String result = await response.stream.bytesToString();
      Map valueMap = jsonDecode(result);
      print(valueMap);
      int result_Id = valueMap["res_Output"][0]["result_Id"];
      print(result_Id);
      String stage_id = valueMap["res_Output"][0]["stage_Id"];
      await SetStageId(stage_id);
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

  Future<void> RazorPayStatusLocal(int amountPayed,String currency , String mobileNumber, String merchantTransactionID) async{
    String jwt_token= await GetCurrentJWTToken();
    print("Calling RAZOR PAY STATUS Using API"+jwt_token);

    String lead_id = await GetLeadId();
    print("RAZOR PAY STATUS for Lead ID : "+lead_id);

    var headers = {
      'Authorization': 'Bearer $jwt_token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('GET', Uri.parse('$BASE_API_LINK_URL/api/razorpay/RazorPayStatus'));
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