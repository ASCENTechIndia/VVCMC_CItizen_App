import 'package:shared_preferences/shared_preferences.dart';
import 'package:vvcmc_citizen_app/utils/get_it.dart';
import 'package:xml/xml.dart';

class PrabhagSamiti {
  final String memberNameEn;
  final String memberNameMr;
  final String prabhagSamitiNameEn;
  final String prabhagSamitiNameMr;
  final String emailId;
  final String mobileNo;
  final prefs = getIt<SharedPreferences>();

  PrabhagSamiti({
    required this.memberNameEn,
    required this.memberNameMr,
    required this.prabhagSamitiNameEn,
    required this.prabhagSamitiNameMr,
    required this.emailId,
    required this.mobileNo,
  });

  String get memberName {
    if (prefs.getString("locale") == "mr") return memberNameMr;
    return memberNameEn;
  }

  String get prabhagSamitiName {
    if (prefs.getString("locale") == "mr") return prabhagSamitiNameMr;
    return prabhagSamitiNameEn;
  }

  factory PrabhagSamiti.fromXML(XmlNode xml) {
    return PrabhagSamiti(
      memberNameEn: xml.findElements("membername").first.innerText,
      memberNameMr: xml.findElements("membernamemar").first.innerText,
      prabhagSamitiNameEn:
          xml.findElements("prabhagsamitiname").first.innerText,
      prabhagSamitiNameMr:
          xml.findElements("prabhagsamitinamemar").first.innerText,
      emailId: xml.findElements("emailid").first.innerText,
      mobileNo: xml.findElements("mobileno").first.innerText,
    );
  }
}
