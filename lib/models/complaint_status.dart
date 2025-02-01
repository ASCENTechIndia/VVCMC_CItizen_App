import 'package:xml/xml.dart';

class ComplaintStatus {
  final String complaintNo;
  final String custNo;
  final String complaint;
  final String status;
  final String type;
  final String subType;
  final String date;

  ComplaintStatus({
    required this.complaintNo,
    required this.custNo,
    required this.complaint,
    required this.status,
    required this.type,
    required this.subType,
    required this.date,
  });

  factory ComplaintStatus.fromXML(XmlNode xml) {
    return ComplaintStatus(
      complaintNo: xml.findElements("CMPLNO").first.innerText,
      custNo: xml.findElements("CUSTCNTNO").first.innerText,
      complaint: xml.findElements("COMPLAINT").first.innerText,
      status: xml.findElements("STATUS").first.innerText,
      type: xml.findElements("COMPLAINTTYPE").first.innerText,
      subType: xml.findElements("complaintsubtype").first.innerText,
      date: xml.findElements("CMPLREGDATE").first.innerText,
    );
  }
}
