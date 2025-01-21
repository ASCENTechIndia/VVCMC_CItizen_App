import 'package:xml/xml.dart';

class GovernmentOffice {
  final int id;
  final String name;
  final String address;
  final String phone1;
  final String phone2;
  final String mobile1;
  final String mobile2;

  GovernmentOffice({
    required this.id,
    required this.name,
    required this.address,
    required this.phone1,
    required this.phone2,
    required this.mobile1,
    required this.mobile2,
  });

  factory GovernmentOffice.fromXML(XmlNode xml) {
    return GovernmentOffice(
      id: int.parse(xml.findElements("OID").first.innerText),
      name: xml.findElements("Officename").first.innerText,
      address: xml.findElements("address").first.innerText,
      phone1: xml.findElements("phone1").first.innerText,
      phone2: xml.findElements("phone2").first.innerText,
      mobile1: xml.findElements("mobile1").first.innerText,
      mobile2: xml.findElements("mobile2").first.innerText,
    );
  }
}
