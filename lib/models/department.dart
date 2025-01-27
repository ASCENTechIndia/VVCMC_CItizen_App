import 'package:xml/xml.dart';

class Department {
  final int id;
  final String name;

  Department({
    required this.id,
    required this.name,
  });

  factory Department.fromXML(XmlNode xml) {
    return Department(
      id: int.parse(xml.findElements("Id").first.innerText),
      name: xml.findElements("Name").first.innerText,
    );
  }
}
