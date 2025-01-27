import 'package:xml/xml.dart';

class ComplaintType {
  final int id;
  final String name;

  ComplaintType({
    required this.id,
    required this.name,
  });

  factory ComplaintType.fromXML(XmlNode xml) {
    return ComplaintType(
      id: int.parse(xml.findElements("Id").first.innerText),
      name: xml.findElements("Name").first.innerText,
    );
  }
}
