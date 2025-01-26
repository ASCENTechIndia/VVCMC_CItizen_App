import 'package:xml/xml.dart';

class WaterTaxDetails {
  final String name;
  final String roadName;
  final String previousBillAmount;
  final String currentBillAmount;
  final String total;
  final bool allowPayment;

  WaterTaxDetails({
    required this.name,
    required this.roadName,
    required this.previousBillAmount,
    required this.currentBillAmount,
    required this.total,
    required this.allowPayment,
  });

  factory WaterTaxDetails.fromXML(XmlNode body) {
    return WaterTaxDetails(
      name: body.findElements("Name").first.innerText,
      roadName: body.findElements("RoadName").first.innerText,
      previousBillAmount:
          body.findElements("PreviousBillAmount").first.innerText,
      currentBillAmount: body.findElements("CurrentBillAmount").first.innerText,
      total: (int.parse(
                  body.findElements("PreviousBillAmount").first.innerText) +
              int.parse(body.findElements("CurrentBillAmount").first.innerText))
          .toString(),
      allowPayment: body.findElements("AllowPayment").first.innerText == "Y",
    );
  }
}
