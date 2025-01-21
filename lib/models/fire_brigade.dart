import 'package:xml/xml.dart';

class FireBrigade {
  final int id;
  final String department;
  final String type;
  final String phone1;
  final String phone2;
  final String mobile1;
  final String mobile2;

  FireBrigade({
    required this.id,
    required this.department,
    required this.type,
    required this.phone1,
    required this.phone2,
    required this.mobile1,
    required this.mobile2,
  });

  factory FireBrigade.fromXML(XmlNode xml) {
    return FireBrigade(
      id: int.parse(xml.findElements("FBID").first.innerText),
      department: xml.findElements("FB_Department").first.innerText,
      type: xml.findElements("FB_Type").first.innerText,
      phone1: xml.findElements("phone1").first.innerText,
      phone2: xml.findElements("phone2").first.innerText,
      mobile1: xml.findElements("mobile1").first.innerText,
      mobile2: xml.findElements("mobile2").first.innerText,
    );
  }
}
