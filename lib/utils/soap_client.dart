import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vvcmc_citizen_app/models/ambulance.dart';
import 'package:vvcmc_citizen_app/models/blood_bank.dart';
import 'package:vvcmc_citizen_app/models/bus_schedule.dart';
import 'package:vvcmc_citizen_app/models/complaint_details.dart';
import 'package:vvcmc_citizen_app/models/complaint_status.dart';
import 'package:vvcmc_citizen_app/models/complaint_type.dart';
import 'package:vvcmc_citizen_app/models/department.dart';
import 'package:vvcmc_citizen_app/models/elected_member.dart';
import 'package:vvcmc_citizen_app/models/eye_bank.dart';
import 'package:vvcmc_citizen_app/models/fire_brigade.dart';
import 'package:vvcmc_citizen_app/models/government_office.dart';
import 'package:vvcmc_citizen_app/models/hospital.dart';
import 'package:vvcmc_citizen_app/models/mayor_message.dart';
import 'package:vvcmc_citizen_app/models/official_numbers.dart';
import 'package:vvcmc_citizen_app/models/police.dart';
import 'package:vvcmc_citizen_app/models/prabhag.dart';
import 'package:vvcmc_citizen_app/models/prabhag_samiti.dart';
import 'package:vvcmc_citizen_app/models/property_tax_details.dart';
import 'package:vvcmc_citizen_app/models/ward.dart';
import 'package:vvcmc_citizen_app/models/water_tax_details.dart';
import 'package:vvcmc_citizen_app/models/zone.dart';
import 'package:xml/xml.dart';

class SoapClient {
  final SharedPreferences prefs;
  final String url;
  final String soapAction;
  final String host;

  SoapClient({
    required this.prefs,
    this.url = "http://www.onlinevvcmc.in/VVCMCPersonaliseApp/Service.svc",
    this.soapAction = "http://tempuri.org/IService/",
    this.host = "www.onlinevvcmc.in",
  });

  String generateSoapEnvelope(String methodName, Map<String, String> params) {
    StringBuffer body = StringBuffer();

    body.write(
        '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">');
    body.write("<soapenv:Header/>");
    body.write("<soapenv:Body>");
    body.write("<tem:$methodName>");
    params.forEach((key, value) {
      body.write("<tem:$key>$value</tem:$key>");
    });
    body.write("</tem:$methodName>");
    body.write("</soapenv:Body>");
    body.write("</soapenv:Envelope>");
    return body.toString();
  }

  Future<List<XmlElement?>> post(
    String methodName,
    Map<String, String> params,
  ) async {
    String soapEnvelope = generateSoapEnvelope(methodName, params);
    int contentLength = utf8.encode(soapEnvelope).length;
    var headers = {
      "Content-Type": "text/xml",
      "Content-Length": contentLength.toString(),
      "SOAPAction": soapAction + methodName,
      "Host": host,
    };
    try {
      log(soapEnvelope);
      var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: soapEnvelope,
      );
      log(response.body);
      if (response.statusCode == 200) {
        String xmlString =
            response.body.replaceAll("&lt;", "<").replaceAll("&gt;", ">");
        XmlElement? responseHeader;
        XmlElement? responseDetails;
        RegExp headerRegex =
            RegExp(r'<ResponseHeader>(.*?)</ResponseHeader>', dotAll: true);
        var header = headerRegex.firstMatch(xmlString);
        if (header != null) {
          responseHeader = XmlDocument.parse(header.group(0)!).rootElement;
        }
        log("$responseHeader");
        RegExp detailsRegex =
            RegExp(r'<ResponseDetails>(.*?)</ResponseDetails>', dotAll: true);
        var details = detailsRegex.firstMatch(xmlString);
        if (details != null) {
          responseDetails = XmlDocument.parse(details.group(0)!).rootElement;
        }
        return [responseHeader, responseDetails];
      } else {
        log("Error: ${response.statusCode}");
        log("Error: ${response.body}");
      }
    } catch (e) {
      log("Request failed: $e");
      rethrow;
    }
    return [];
/*
    try {
      log(soapEnvelope);
      var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: soapEnvelope,
      );
      log(response.body);
      if (response.statusCode == 200) {
        String xmlString =
            response.body.replaceAll("&lt;", "<").replaceAll("&gt;", ">");
        var document = XmlDocument.parse(xmlString);
        var responseHeader =
            document.rootElement.findAllElements("ResponseHeader").first;
        log(responseHeader);
        var responseDetails =
            document.rootElement.findAllElements("ResponseDetails").first;
        return [responseHeader, responseDetails];
      } else {
        log("Error: ${response.statusCode}");
        log("Error: ${response.body}");
      }
    } catch (e) {
      log("Request failed: $e");
      rethrow;
    }
    return [];
*/
  }

  Future<List<ElectedMember>> getElectedMembers() async {
    try {
      final [header, body] = await post("GetElectedMembers", {});
      if (body == null) return [];
      List<ElectedMember> electedMembers = [];
      for (var child in body.children) {
        if (child.children.isNotEmpty) {
          electedMembers.add(ElectedMember.fromXML(child));
        }
      }
      return electedMembers;
    } catch (error) {
      log("$error");
      rethrow;
    }
  }

  Future<List<PrabhagSamiti>> getPrabhagSamiti() async {
    try {
      final [header, body] = await post("GetPrabhagSamiti", {});
      if (body == null) return [];
      List<PrabhagSamiti> prabhagSamiti = [];
      for (var child in body.children) {
        if (child.children.isNotEmpty) {
          prabhagSamiti.add(PrabhagSamiti.fromXML(child));
        }
      }
      return prabhagSamiti;
    } catch (error) {
      log("$error");
      rethrow;
    }
  }

  Future<List<OfficialNumbers>> getOfficialNumbers() async {
    try {
      final [header, body] = await post("GetOfficialNumbers", {});
      if (body == null) return [];
      List<OfficialNumbers> officialNumbers = [];
      for (var child in body.children) {
        if (child.children.isNotEmpty) {
          officialNumbers.add(OfficialNumbers.fromXML(child));
        }
      }
      return officialNumbers;
    } catch (error) {
      log("$error");
      rethrow;
    }
  }

  Future<MayorMessage?> getMayorMessage() async {
    try {
      final [header, body] = await post("GetMayorMessage", {});
      if (body == null) return null;
      MayorMessage? mayorMessage;
      for (var child in body.children) {
        if (child.children.isNotEmpty) {
          mayorMessage = MayorMessage.fromXML(child);
        }
      }
      return mayorMessage;
    } catch (error) {
      log("$error");
      rethrow;
    }
  }

  Future<List<Hospital>> getHospitals() async {
    try {
      final [header, body] = await post("GetHospitalList", {});
      if (body == null) return [];
      List<Hospital> hospitals = [];
      for (var child in body.children) {
        if (child.children.isNotEmpty) {
          hospitals.add(Hospital.fromXML(child));
        }
      }
      return hospitals;
    } catch (error) {
      log("$error");
      rethrow;
    }
  }

  Future<List<Ambulance>> getAmbulance() async {
    try {
      final [header, body] = await post("GetAmbulanceList", {});
      if (body == null) return [];
      List<Ambulance> ambulances = [];
      for (var child in body.children) {
        if (child.children.isNotEmpty) {
          ambulances.add(Ambulance.fromXML(child));
        }
      }
      return ambulances;
    } catch (error) {
      log("$error");
      rethrow;
    }
  }

  Future<List<Police>> getPolice() async {
    try {
      final [header, body] = await post("GetPoliceDepartmentList", {});
      if (body == null) return [];
      List<Police> police = [];
      for (var child in body.children) {
        if (child.children.isNotEmpty) {
          police.add(Police.fromXML(child));
        }
      }
      return police;
    } catch (error) {
      log("$error");
      rethrow;
    }
  }

  Future<List<FireBrigade>> getFireBrigades() async {
    try {
      final [header, body] = await post("GetFireBrigadeList", {});
      if (body == null) return [];
      List<FireBrigade> fireBrigades = [];
      for (var child in body.children) {
        if (child.children.isNotEmpty) {
          fireBrigades.add(FireBrigade.fromXML(child));
        }
      }
      return fireBrigades;
    } catch (error) {
      log("$error");
      rethrow;
    }
  }

  Future<List<BloodBank>> getBloodBanks() async {
    try {
      final [header, body] = await post("GetBloodBankList", {});
      if (body == null) return [];
      List<BloodBank> bloodBanks = [];
      for (var child in body.children) {
        if (child.children.isNotEmpty) {
          bloodBanks.add(BloodBank.fromXML(child));
        }
      }
      return bloodBanks;
    } catch (error) {
      log("$error");
      rethrow;
    }
  }

  Future<List<EyeBank>> getEyeBanks() async {
    try {
      final [header, body] = await post("GetEyeBankList", {});
      if (body == null) return [];
      List<EyeBank> eyeBanks = [];
      for (var child in body.children) {
        if (child.children.isNotEmpty) {
          eyeBanks.add(EyeBank.fromXML(child));
        }
      }
      return eyeBanks;
    } catch (error) {
      log("$error");
      rethrow;
    }
  }

  Future<List<GovernmentOffice>> getGovernmentOffices() async {
    try {
      final [header, body] = await post("GetGovernmentOfficesList", {});
      if (body == null) return [];
      List<GovernmentOffice> governmentOffices = [];
      for (var child in body.children) {
        if (child.children.isNotEmpty) {
          governmentOffices.add(GovernmentOffice.fromXML(child));
        }
      }
      return governmentOffices;
    } catch (error) {
      log("$error");
      rethrow;
    }
  }

  Future<List<String>> getGallery() async {
    try {
      final [header, body] = await post("GetGallery", {});
      if (body == null) return [];
      List<String> gallery = [];
      for (var child in body.children) {
        if (child.children.isNotEmpty) {
          gallery.add(child.findElements("imageurl").first.innerText);
        }
      }
      return gallery;
    } catch (error) {
      log("$error");
      rethrow;
    }
  }

  Future<PropertyTaxDetails?> getPropertyTax(String propertyNo) async {
    try {
      final [header, body] =
          await post("GetHouseTaxDetailsAtom", {"PropertyNo": propertyNo});
      if (header == null) return null;
      if (body == null) return null;
      PropertyTaxDetails? tax;
      tax = PropertyTaxDetails.fromXML(header, body);
      return tax;
    } catch (error) {
      log("$error");
      rethrow;
    }
  }

  Future<List<Zone>> getZones() async {
    try {
      final [header, body] = await post("GetZoneList", {});
      if (body == null) return [];
      List<Zone> zones = [];
      for (var child in body.children) {
        if (child.children.isNotEmpty) {
          zones.add(Zone.fromXML(child));
        }
      }
      return zones;
    } catch (error) {
      log("$error");
      rethrow;
    }
  }

  Future<List<Ward>> getWards(int zoneId) async {
    try {
      final [header, body] =
          await post("GetWardList", {"ZoneId": zoneId.toString()});
      if (body == null) return [];
      List<Ward> wards = [];
      for (var child in body.children) {
        if (child.children.isNotEmpty) {
          wards.add(Ward.fromXML(child));
        }
      }
      return wards;
    } catch (error) {
      log("$error");
      rethrow;
    }
  }

  Future<WaterTaxDetails?> getWaterTaxDetails(
    int? zoneId,
    int? wardId,
    String taxNo,
  ) async {
    try {
      final [header, body] = await post(
        "GetWaterTaxDetailsAtom",
        {
          "ZoneId": zoneId.toString(),
          "WardNo": wardId.toString(),
          "ConnectionNo": taxNo,
        },
      );
      if (body == null) return null;
      WaterTaxDetails? tax;
      tax = WaterTaxDetails.fromXML(body);
      return tax;
    } catch (error) {
      log("$error");
      rethrow;
    }
  }

  Future<List<Prabhag>> getPrabhags() async {
    try {
      final [headerEn, bodyEn] = await post("GetPrabhagList", {});
      final [headerMr, bodyMr] = await post("GetPrabhagListMAR", {});
      if (bodyEn == null || bodyMr == null) return [];
      List<Prabhag> prabhags = [];
      var minLength = bodyEn.children.length < bodyMr.children.length
          ? bodyEn.children.length
          : bodyMr.children.length;
      for (int i = 0; i < minLength; i++) {
        var childEn = bodyEn.children[i];
        var childMr = bodyMr.children[i];

        if (childEn.children.isNotEmpty && childMr.children.isNotEmpty) {
          prabhags.add(Prabhag.fromXML(childEn, childMr));
        }
      }
      return prabhags;
    } catch (error) {
      log("$error");
      rethrow;
    }
  }

  Future<List<Department>> getDepartments() async {
    try {
      final [headerEn, bodyEn] = await post("GetCRMDepartmentList", {});
      final [headerMr, bodyMr] = await post("GetCRMDepartmentListMAR", {});
      if (bodyEn == null || bodyMr == null) return [];
      List<Department> departments = [];
      var minLength = bodyEn.children.length < bodyMr.children.length
          ? bodyEn.children.length
          : bodyMr.children.length;
      for (int i = 0; i < minLength; i++) {
        var childEn = bodyEn.children[i];
        var childMr = bodyMr.children[i];

        if (childEn.children.isNotEmpty && childMr.children.isNotEmpty) {
          departments.add(Department.fromXML(childEn, childMr));
        }
      }
      return departments;
    } catch (error) {
      log("$error");
      rethrow;
    }
  }

  Future<List<ComplaintType>> getComplaintTypes(int deptId) async {
    try {
      final [header, body] = await post(
          "GetCRMComplaintSubTypeDeptwise", {"DeptId": deptId.toString()});
      if (body == null) return [];
      List<ComplaintType> complaintTypes = [];
      for (var child in body.children) {
        if (child.children.isNotEmpty) {
          complaintTypes.add(ComplaintType.fromXML(child));
        }
      }
      return complaintTypes;
    } catch (error) {
      log("$error");
      rethrow;
    }
  }

  Future<bool> register(
    String firstName,
    String lastName,
    String email,
    String mobile,
    String aadharNo,
    String bloodGroup,
  ) async {
    try {
      final [header, body] = await post(
        "Registration",
        {
          "FirstName": firstName,
          "LastName": lastName,
          "Email": email,
          "MobileNo": mobile,
          "AdharNo": aadharNo,
          "BloodGroup": bloodGroup,
        },
      );
      log("$header");
      if (header == null) return false;
      log(header.findElements("SuccessCode").first.innerText);
      return header.findElements("SuccessCode").first.innerText == "9999";
    } catch (error) {
      log("$error");
      rethrow;
    }
  }

  Future<bool> verifyOTP(
    String mobile,
    String otp,
  ) async {
    try {
      final [header, body] = await post(
        "VerifyOTP",
        {
          "MobileNo": mobile,
          "OTP": otp,
        },
      );
      if (header == null) return false;
      return header.findElements("SuccessCode").first.innerText == "9999";
    } catch (error) {
      log("$error");
      rethrow;
    }
  }

  Future<bool> submitCitizenFeedback(
    String username,
    String mobNo,
    String area,
    String landmark,
    String address,
    bool opt1,
    bool opt2,
    bool opt3,
    bool opt4,
    bool opt5,
    bool opt6,
    bool opt7,
  ) async {
    try {
      final [header, body] = await post(
        "CitizenFeedback",
        {
          "_Username": username,
          "_mobno": mobNo,
          "_area": area,
          "_landmark": landmark,
          "_address": address,
          "_opt1": opt1 ? "Y" : "N",
          "_opt1_Image": "",
          "_opt2": opt2 ? "Y" : "N",
          "_dustbintype": "0",
          "_noofdustbin": "0",
          "_opt3": opt3 ? "Y" : "N",
          "_opt3comm": "",
          "_opt4": opt4 ? "Y" : "N",
          "_opt4comm": "",
          "_opt5": opt5 ? "Y" : "N",
          "_opt5comm": "",
          "_opt6": opt6 ? "Y" : "N",
          "_opt6comm": "",
          "_opt7": opt7 ? "Y" : "N",
          "_opt7comm": "",
        },
      );
      if (header == null) return false;
      log(header.findElements("SuccessCode").first.innerText);
      return header.findElements("SuccessCode").first.innerText == "9999";
    } catch (error) {
      log("$error");
      return false;
    }
  }

  Future<bool> registerComplaint(
    String departmentId,
    String customerName,
    String mobileNo,
    String complaint,
    File? image,
    String email,
    String location,
    String prabhagId,
    String address,
    String subject,
  ) async {
    try {
      String encodedImage = "";
      if (image != null) encodedImage = base64Encode(await image.readAsBytes());
      final [header, body] = await post(
        "RegisterComplaint_subject",
        {
          "DepartmentId": departmentId,
          "ComplaintSubTypeId": "-1",
          "CustomerName": customerName,
          "MobileNo": mobileNo,
          "Complaint": complaint,
          "Image": encodedImage,
          "Email": email,
          "Location": location,
          "PrabhagID": prabhagId,
          "Address": address,
          "subject": subject,
        },
      );
      if (header == null) return false;
      log(header.findElements("SuccessCode").first.innerText);
      return header.findElements("SuccessCode").first.innerText == "9999";
    } catch (error) {
      log("$error");
      return false;
    }
  }

  Future<String?> getSession(
    String mobile,
    String email,
  ) async {
    try {
      final [header, body] = await post(
        "GetVclickSessionID",
        {
          "MobileNo": mobile,
          "Email": email,
        },
      );
      if (body == null) return null;
      return body.findElements("UniqueId").first.innerText;
    } catch (error) {
      log("$error");
      return null;
    }
  }

  Future<List<String>> getNotifications() async {
    try {
      final [header, body] = await post("GetVclicknotification", {});
      if (header == null) return [];
      log("${header.findElements("SuccessMessage").first.innerText.split("#")}");
      return header.findElements("SuccessMessage").first.innerText.split("#");
    } catch (error) {
      log("$error");
      rethrow;
    }
  }

  Future<bool> updateUserDetails(
    String firstName,
    String lastName,
    String email,
    String mobile,
    String aadharNo,
    String bloodGroup,
  ) async {
    try {
      final [header, body] = await post(
        "UpdateUserDetails",
        {
          "FirstName": firstName,
          "LastName": lastName,
          "Email": email,
          "MobileNo": mobile,
          "AdharNo": aadharNo,
          "BloodGroup": bloodGroup,
        },
      );
      if (header == null) return false;
      log(header.findElements("SuccessCode").first.innerText);
      return header.findElements("SuccessCode").first.innerText == "9999";
    } catch (error) {
      log("$error");
      return false;
    }
  }

  Future<bool> storeUserDetails(String mobile) async {
    try {
      final [header, body] = await post(
        "GetUserDetails",
        {
          "MobileNo": mobile,
        },
      );
      log("HEADER: $header");
      if (header == null) return false;
      await Future.wait([
        prefs.setString(
          "firstName",
          header.findElements("FirstName").first.innerText,
        ),
        prefs.setString(
          "lastName",
          header.findElements("LastName").first.innerText,
        ),
        prefs.setString(
            "mobile", header.findElements("Mobile").first.innerText),
        prefs.setString("email", header.findElements("Email").first.innerText),
        prefs.setString("aadhar", header.findElements("Adhar").first.innerText),
        prefs.setString(
          "bloodGroup",
          header.findElements("BloodGroup").first.innerText,
        ),
      ]);
      return true;
    } catch (error) {
      log("$error");
      return false;
    }
  }

  Future<List<ComplaintStatus>> getComplaintStatus() async {
    try {
      final [header, body] = await post("ComplaintStatus", {
        "MobileNo": prefs.getString("mobile")!,
        "ComplaintNo": "",
      });
      if (body == null) return [];
      List<ComplaintStatus> complaintStatus = [];
      for (var child in body.children) {
        if (child.children.isNotEmpty) {
          complaintStatus.add(ComplaintStatus.fromXML(child));
        }
      }
      return complaintStatus;
    } catch (error) {
      log("$error");
      rethrow;
    }
  }

  Future<List<ComplaintDetails>> getComplaintDetails(String complaintNo) async {
    try {
      final [header, body] = await post("ComplaintNoDetails", {
        "ComplaintNo": complaintNo,
      });
      if (body == null) return [];
      List<ComplaintDetails> complaintDetails = [];
      for (var child in body.children) {
        if (child.children.isNotEmpty) {
          complaintDetails.add(ComplaintDetails.fromXML(child));
        }
      }
      return complaintDetails;
    } catch (error) {
      log("$error");
      rethrow;
    }
  }

  Future<List<BusSchedule>> getBusSchedule() async {
    try {
      final [header, body] = await post("GetBusScheduleList", {});
      if (body == null) return [];
      List<BusSchedule> busSchedule = [];
      for (var child in body.children) {
        if (child.children.isNotEmpty) {
          busSchedule.add(BusSchedule.fromXML(child));
        }
      }
      log("$busSchedule");
      return busSchedule;
    } catch (error) {
      log("$error");
      rethrow;
    }
  }

  Future<List<BusSchedule>> getBusScheduleFromTo(String from, String to) async {
    try {
      final [header, body] =
          await post("GetBusScheduleFromTo", {"rFrom": from, "rTo": to});
      if (header == null) return [];
      if (header.findElements("SuccessCode").first.innerText != "9999")
        return [];
      if (body == null) return [];
      log("$body");
      List<BusSchedule> busSchedule = [];
      for (var child in body.children) {
        if (child.children.isNotEmpty) {
          busSchedule.add(BusSchedule.fromXML(child));
        }
      }
      log("$busSchedule");
      return busSchedule;
    } catch (error) {
      log("$error");
      rethrow;
    }
  }
}
