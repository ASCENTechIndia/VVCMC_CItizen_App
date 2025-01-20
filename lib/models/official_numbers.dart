import 'package:xml/xml.dart';

class OfficialNumbers {
  final String memberName;
  final String memberNameMar;
  final String designation;
  final String designationMar;
  final String wardName;
  final String emailId;
  final String mobileNo;

  OfficialNumbers({
    required this.memberName,
    required this.memberNameMar,
    required this.designation,
    required this.designationMar,
    required this.wardName,
    required this.emailId,
    required this.mobileNo,
  });

  factory OfficialNumbers.fromXML(XmlNode xml) {
    return OfficialNumbers(
      memberName: xml.findElements("membername").first.innerText,
      memberNameMar: xml.findElements("membernamemar").first.innerText,
      designation: xml.findElements("designation").first.innerText,
      designationMar: xml.findElements("designationmar").first.innerText,
      wardName: xml.findElements("wardname").first.innerText,
      emailId: xml.findElements("emailid").first.innerText,
      mobileNo: xml.findElements("mobileno").first.innerText,
    );
  }
}
