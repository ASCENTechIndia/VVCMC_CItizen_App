import 'package:xml/xml.dart';

class Police {
  final int id;
  final String department;
  final String phone1;
  final String phone2;
  final String mobile1;
  final String mobile2;

  Police({
    required this.id,
    required this.department,
    required this.phone1,
    required this.phone2,
    required this.mobile1,
    required this.mobile2,
  });

  factory Police.fromXML(XmlNode xml) {
    return Police(
      id: int.parse(xml.findElements("DID").first.innerText),
      department: xml.findElements("department_details").first.innerText,
      phone1: xml.findElements("phone1").first.innerText,
      phone2: xml.findElements("phone2").first.innerText,
      mobile1: xml.findElements("mobile1").first.innerText,
      mobile2: xml.findElements("mobile2").first.innerText,
    );
  }
}
