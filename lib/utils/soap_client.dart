import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vvcmc_citizen_app/models/elected_member.dart';
import 'package:vvcmc_citizen_app/models/hospital.dart';
import 'package:vvcmc_citizen_app/models/mayor_message.dart';
import 'package:vvcmc_citizen_app/models/official_numbers.dart';
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
      print(xml.children);
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
      print(xml.children);
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
}
