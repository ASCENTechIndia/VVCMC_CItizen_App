import 'package:xml/xml.dart';

class Hospital {
  final int id;
  final String doctorName;
  final String address;
  final String type;
  final String phone1;
  final String phone2;
  final String mobile1;
  final String mobile2;

  Hospital({
    required this.id,
    required this.doctorName,
    required this.address,
    required this.type,
    required this.phone1,
    required this.phone2,
    required this.mobile1,
    required this.mobile2,
  });

  factory Hospital.fromXML(XmlNode xml) {
    return Hospital(
      id: int.parse(xml.findElements("HospitalID").first.innerText),
      doctorName: xml.findElements("doctor_name").first.innerText,
      address: xml.findElements("hospital_name_adr").first.innerText,
      type: xml.findElements("hospital_type").first.innerText,
      phone1: xml.findElements("phone1").first.innerText,
      phone2: xml.findElements("phone2").first.innerText,
      mobile1: xml.findElements("mobile1").first.innerText,
      mobile2: xml.findElements("mobile2").first.innerText,
    );
  }
}
