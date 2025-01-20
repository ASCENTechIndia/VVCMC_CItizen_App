import 'package:xml/xml.dart';

class MayorMessage {
  final String mayorName;
  final String mayorNameMar;
  final String mayorMessage;
  final String mayorMessageMar;
  final String imageUrl;

  MayorMessage({
    required this.mayorName,
    required this.mayorNameMar,
    required this.mayorMessage,
    required this.mayorMessageMar,
    required this.imageUrl,
  });

  factory MayorMessage.fromXML(XmlNode xml) {
    return MayorMessage(
      mayorName: xml.findElements("mayorname").first.innerText,
      mayorNameMar: xml.findElements("mayornamemar").first.innerText,
      mayorMessage: xml.findElements("mayormessageeng").first.innerText,
      mayorMessageMar: xml.findElements("mayormessagemar").first.innerText,
      imageUrl: xml.findElements("imageurl").first.innerText,
    );
  }
}
