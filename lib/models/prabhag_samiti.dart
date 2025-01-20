import 'package:xml/xml.dart';

class PrabhagSamiti {
  final String memberName;
  final String memberNameMar;
  final String prabhagSamitiName;
  final String prabhagSamitiNameMar;
  final String emailId;
  final String mobileNo;

  PrabhagSamiti({
    required this.memberName,
    required this.memberNameMar,
    required this.prabhagSamitiName,
    required this.prabhagSamitiNameMar,
    required this.emailId,
    required this.mobileNo,
  });

  factory PrabhagSamiti.fromXML(XmlNode xml) {
    return PrabhagSamiti(
      memberName: xml.findElements("membername").first.innerText,
      memberNameMar: xml.findElements("membernamemar").first.innerText,
      prabhagSamitiName: xml.findElements("prabhagsamitiname").first.innerText,
      prabhagSamitiNameMar: xml.findElements("prabhagsamitinamemar").first.innerText,
      emailId: xml.findElements("emailid").first.innerText,
      mobileNo: xml.findElements("mobileno").first.innerText,
    );
  }
}
