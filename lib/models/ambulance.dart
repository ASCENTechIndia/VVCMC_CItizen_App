import 'package:xml/xml.dart';

class Ambulance {
  final int id;
  final String organization;
  final String address;
  final String phone1;
  final String phone2;
  final String mobile1;
  final String mobile2;

  Ambulance({
    required this.id,
    required this.organization,
    required this.address,
    required this.phone1,
    required this.phone2,
    required this.mobile1,
    required this.mobile2,
  });

  factory Ambulance.fromXML(XmlNode xml) {
    return Ambulance(
      id: int.parse(xml.findElements("Id").first.innerText),
      organization: xml.findElements("organisation_name").first.innerText,
      address: xml.findElements("address").first.innerText,
      phone1: xml.findElements("phone1").first.innerText,
      phone2: xml.findElements("phone2").first.innerText,
      mobile1: xml.findElements("mobile1").first.innerText,
      mobile2: xml.findElements("mobile2").first.innerText,
    );
  }
}
