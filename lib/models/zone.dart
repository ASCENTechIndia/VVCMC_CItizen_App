import 'package:xml/xml.dart';

class Zone {
  final int id;
  final String name;

  Zone({
    required this.id,
    required this.name,
  });

  factory Zone.fromXML(XmlNode xml) {
    return Zone(
      id: int.parse(xml.findElements("Id").first.innerText),
      name: xml.findElements("Name").first.innerText,
    );
  }
}
