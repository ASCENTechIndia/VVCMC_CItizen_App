import 'package:shared_preferences/shared_preferences.dart';
import 'package:vvcmc_citizen_app/utils/get_it.dart';
import 'package:xml/xml.dart';

class MayorMessage {
  final String mayorNameEn;
  final String mayorNameMar;
  final String mayorMessageEn;
  final String mayorMessageMar;
  final String imageUrl;
  final prefs = getIt<SharedPreferences>();

  MayorMessage({
    required this.mayorNameEn,
    required this.mayorNameMar,
    required this.mayorMessageEn,
    required this.mayorMessageMar,
    required this.imageUrl,
  });

  String get mayorName {
    if (prefs.getString("locale") == "mr") return mayorNameMar;
    return mayorNameEn;
  }

  String get mayorMessage {
    if (prefs.getString("locale") == "mr") return mayorMessageMar;
    return mayorMessageEn;
  }

  factory MayorMessage.fromXML(XmlNode xml) {
    return MayorMessage(
      mayorNameEn: xml.findElements("mayorname").first.innerText,
      mayorNameMar: xml.findElements("mayornamemar").first.innerText,
      mayorMessageEn: xml.findElements("mayormessageeng").first.innerText,
      mayorMessageMar: xml.findElements("mayormessagemar").first.innerText,
      imageUrl: xml.findElements("imageurl").first.innerText,
    );
  }
}
