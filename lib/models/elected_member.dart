import 'package:xml/xml.dart';

class ElectedMember {
  final String memberName;
  final String memberNameMar;
  final String wardNo;
  final String wardNoMar;
  final String emailId;
  final String mobileNo;

  ElectedMember({
    required this.memberName,
    required this.memberNameMar,
    required this.wardNo,
    required this.wardNoMar,
    required this.emailId,
    required this.mobileNo,
  });

  factory ElectedMember.fromXML(XmlNode xml) {
    return ElectedMember(
      memberName: xml.findElements("membername").first.innerText,
      memberNameMar: xml.findElements("membernamemar").first.innerText,
      wardNo: xml.findElements("wardno").first.innerText,
      wardNoMar: xml.findElements("wardnomar").first.innerText,
      emailId: xml.findElements("emailid").first.innerText,
      mobileNo: xml.findElements("mobileno").first.innerText,
    );
  }
}
