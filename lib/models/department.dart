import 'package:shared_preferences/shared_preferences.dart';
import 'package:vvcmc_citizen_app/utils/get_it.dart';
import 'package:xml/xml.dart';

class Department {
  final int id;
  final String nameEn;
  final String nameMr;
  final prefs = getIt<SharedPreferences>();

  Department({
    required this.id,
    required this.nameEn,
    required this.nameMr,
  });

  String get name {
    if (prefs.getString("locale") == "mr") return nameMr;
    return nameEn;
  }

  factory Department.fromXML(XmlNode xmlEn, XmlNode xmlMr) {
    return Department(
      id: int.parse(xmlEn.findElements("Id").first.innerText),
      nameEn: xmlEn.findElements("Name").first.innerText,
      nameMr: xmlMr.findElements("Name").first.innerText,
    );
  }
}
