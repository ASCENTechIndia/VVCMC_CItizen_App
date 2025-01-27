import 'package:xml/xml.dart';

class Prabhag {
  final int id;
  final String name;

  Prabhag({
    required this.id,
    required this.name,
  });

  factory Prabhag.fromXML(XmlNode xml) {
    return Prabhag(
      id: int.parse(xml.findElements("Id").first.innerText),
      name: xml.findElements("PrabhagName").first.innerText,
    );
  }
}
