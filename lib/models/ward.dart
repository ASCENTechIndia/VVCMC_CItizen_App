import 'package:xml/xml.dart';

class Ward {
  final int id;
  final String name;

  Ward({
    required this.id,
    required this.name,
  });

  factory Ward.fromXML(XmlNode xml) {
    return Ward(
      id: int.parse(xml.findElements("Id").first.innerText),
      name: xml.findElements("Name").first.innerText,
    );
  }
}
