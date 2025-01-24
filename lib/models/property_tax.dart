import 'package:xml/xml.dart';

class PropertyTax {
  final String name;
  final String previous;
  final String current;
  final String total;

  bool get isEmpty {
    return name.isEmpty && previous.isEmpty && current.isEmpty && total.isEmpty;
  }
  
  PropertyTax({
    required this.name,
    required this.previous,
    required this.current,
    required this.total,
  });

  factory PropertyTax.fromXML(XmlNode xml) {
    return PropertyTax(
      name: xml.findElements("TaxName").first.innerText,
      previous: xml.findElements("Previous").first.innerText,
      current: xml.findElements("Current").first.innerText,
      total: xml.findElements("Total").first.innerText,
    );
  }
}
