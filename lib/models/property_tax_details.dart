import 'package:vvcmc_citizen_app/models/property_tax.dart';
import 'package:xml/xml.dart';

class PropertyTaxDetails {
  final String billNo;
  final String name;
  final String address;
  final String roomNo;
  final String propertyNo;
  final bool allowPayment;
  final List<PropertyTax> taxes;

  PropertyTaxDetails({
    required this.billNo,
    required this.name,
    required this.address,
    required this.roomNo,
    required this.propertyNo,
    required this.allowPayment,
    required this.taxes,
  });

  factory PropertyTaxDetails.fromXML(XmlNode header, XmlNode body) {
    List<PropertyTax> taxes = [];
    for (var child in body.children) {
      if (child.children.isNotEmpty) {
        taxes.add(PropertyTax.fromXML(child));
      }
    }
    print(taxes);
    return PropertyTaxDetails(
      billNo: header.findElements("BillNo").first.innerText,
      name: header.findElements("Name").first.innerText,
      address: header.findElements("Address").first.innerText,
      roomNo: header.findElements("RoomNo").first.innerText,
      propertyNo: header.findElements("PropertyNo").first.innerText,
      allowPayment: header.findElements("AllowPayment").first.innerText == "Y",
      taxes: taxes,
    );
  }
}
