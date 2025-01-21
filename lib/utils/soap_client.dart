import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vvcmc_citizen_app/models/ambulance.dart';
import 'package:vvcmc_citizen_app/models/blood_bank.dart';
import 'package:vvcmc_citizen_app/models/elected_member.dart';
import 'package:vvcmc_citizen_app/models/eye_bank.dart';
import 'package:vvcmc_citizen_app/models/fire_brigade.dart';
import 'package:vvcmc_citizen_app/models/government_office.dart';
import 'package:vvcmc_citizen_app/models/hospital.dart';
import 'package:vvcmc_citizen_app/models/mayor_message.dart';
import 'package:vvcmc_citizen_app/models/official_numbers.dart';
import 'package:vvcmc_citizen_app/models/police.dart';
import 'package:vvcmc_citizen_app/models/prabhag_samiti.dart';
import 'package:xml/xml.dart';

class SoapClient {
  final String url;
  final String soapAction;
  final String host;

  SoapClient({
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

  Future<XmlElement?> post(
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
      var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: soapEnvelope,
      );

      if (response.statusCode == 200) {
        String xmlString =
            response.body.replaceAll("&lt;", "<").replaceAll("&gt;", ">");
        var document = XmlDocument.parse(xmlString);
        var responseHeader =
            document.rootElement.findAllElements("ResponseHeader").first;
        var responseDetails =
            document.rootElement.findAllElements("ResponseDetails").first;
        if (responseHeader
                .findElements("SuccessCode")
                .first
                .firstChild!
                .value ==
            "9999") {
          return responseDetails;
        }
      } else {
        print("Error: ${response.statusCode}");
        print("Error: ${response.body}");
      }
    } catch (e) {
      print("Request failed: $e");
    }
    return null;
  }

  Future<List<ElectedMember>> getElectedMembers() async {
    try {
      final xml = await post("GetElectedMembers", {});
      if (xml == null) return [];
      List<ElectedMember> electedMembers = [];
      for (var child in xml.children) {
        if (child.children.isNotEmpty) {
          electedMembers.add(ElectedMember.fromXML(child));
        }
      }
      return electedMembers;
    } catch (error) {
      print(error);
      return [];
    }
  }

  Future<List<PrabhagSamiti>> getPrabhagSamiti() async {
    try {
      final xml = await post("GetPrabhagSamiti", {});
      if (xml == null) return [];
      List<PrabhagSamiti> prabhagSamiti = [];
      for (var child in xml.children) {
        if (child.children.isNotEmpty) {
          prabhagSamiti.add(PrabhagSamiti.fromXML(child));
        }
      }
      return prabhagSamiti;
    } catch (error) {
      print(error);
      return [];
    }
  }

  Future<List<OfficialNumbers>> getOfficialNumbers() async {
    try {
      final xml = await post("GetOfficialNumbers", {});
      if (xml == null) return [];
      List<OfficialNumbers> officialNumbers = [];
      for (var child in xml.children) {
        if (child.children.isNotEmpty) {
          officialNumbers.add(OfficialNumbers.fromXML(child));
        }
      }
      return officialNumbers;
    } catch (error) {
      print(error);
      return [];
    }
  }

  Future<MayorMessage?> getMayorMessage() async {
    try {
      final xml = await post("GetMayorMessage", {});
      if (xml == null) return null;
      MayorMessage? mayorMessage;
      for (var child in xml.children) {
        if (child.children.isNotEmpty) {
          mayorMessage = MayorMessage.fromXML(child);
        }
      }
      return mayorMessage;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<List<Hospital>> getHospitals() async {
    try {
      final xml = await post("GetHospitalList", {});
      if (xml == null) return [];
      List<Hospital> hospitals = [];
      for (var child in xml.children) {
        if (child.children.isNotEmpty) {
          hospitals.add(Hospital.fromXML(child));
        }
      }
      return hospitals;
    } catch (error) {
      print(error);
      return [];
    }
  }

  Future<List<Ambulance>> getAmbulance() async {
    try {
      final xml = await post("GetAmbulanceList", {});
      if (xml == null) return [];
      List<Ambulance> ambulances = [];
      for (var child in xml.children) {
        if (child.children.isNotEmpty) {
          ambulances.add(Ambulance.fromXML(child));
        }
      }
      return ambulances;
    } catch (error) {
      print(error);
      return [];
    }
  }

  Future<List<Police>> getPolice() async {
    try {
      final xml = await post("GetPoliceDepartmentList", {});
      if (xml == null) return [];
      List<Police> police = [];
      for (var child in xml.children) {
        if (child.children.isNotEmpty) {
          police.add(Police.fromXML(child));
        }
      }
      return police;
    } catch (error) {
      print(error);
      return [];
    }
  }

  Future<List<FireBrigade>> getFireBrigades() async {
    try {
      final xml = await post("GetFireBrigadeList", {});
      if (xml == null) return [];
      List<FireBrigade> fireBrigades = [];
      for (var child in xml.children) {
        if (child.children.isNotEmpty) {
          fireBrigades.add(FireBrigade.fromXML(child));
        }
      }
      return fireBrigades;
    } catch (error) {
      print(error);
      return [];
    }
  }

  Future<List<BloodBank>> getBloodBanks() async {
    try {
      final xml = await post("GetBloodBankList", {});
      if (xml == null) return [];
      List<BloodBank> bloodBanks = [];
      for (var child in xml.children) {
        if (child.children.isNotEmpty) {
          bloodBanks.add(BloodBank.fromXML(child));
        }
      }
      return bloodBanks;
    } catch (error) {
      print(error);
      return [];
    }
  }

  Future<List<EyeBank>> getEyeBanks() async {
    try {
      final xml = await post("GetEyeBankList", {});
      if (xml == null) return [];
      List<EyeBank> eyeBanks = [];
      for (var child in xml.children) {
        if (child.children.isNotEmpty) {
          eyeBanks.add(EyeBank.fromXML(child));
        }
      }
      return eyeBanks;
    } catch (error) {
      print(error);
      return [];
    }
  }

  Future<List<GovernmentOffice>> getGovernmentOffices() async {
    try {
      final xml = await post("GetGovernmentOfficesList", {});
      if (xml == null) return [];
      List<GovernmentOffice> governmentOffices = [];
      for (var child in xml.children) {
        if (child.children.isNotEmpty) {
          governmentOffices.add(GovernmentOffice.fromXML(child));
        }
      }
      return governmentOffices;
    } catch (error) {
      print(error);
      return [];
    }
  }

  Future<List<String>> getGallery() async {
    try {
      final xml = await post("GetGallery", {});
      if (xml == null) return [];
      print(xml.children);
      List<String> gallery = [];
      for (var child in xml.children) {
        if (child.children.isNotEmpty) {
          gallery.add(child.findElements("imageurl").first.innerText);
        }
      }
      return gallery;
    } catch (error) {
      print(error);
      return [];
    }
  }
}
