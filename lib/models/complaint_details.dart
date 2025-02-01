import 'package:xml/xml.dart';

class ComplaintDetails {
  final String username;
  final String date;
  final String status;
  final String action;
  final String remark;

  ComplaintDetails({
    required this.username,
    required this.date,
    required this.status,
    required this.action,
    required this.remark,
  });

  factory ComplaintDetails.fromXML(XmlNode xml) {
    return ComplaintDetails(
      username: xml.findElements("username").first.innerText,
      date: xml.findElements("complregdate").first.innerText,
      status: xml.findElements("status").first.innerText,
      action: xml.findElements("action").first.innerText,
      remark: xml.findElements("remark").first.innerText,
    );
  }
}
