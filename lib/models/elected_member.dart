import 'package:shared_preferences/shared_preferences.dart';
import 'package:vvcmc_citizen_app/utils/get_it.dart';
import 'package:xml/xml.dart';

class ElectedMember {
  final String memberNameEn;
  final String memberNameMr;
  final String wardNoEn;
  final String wardNoMr;
  final String emailId;
  final String mobileNo;
  final prefs = getIt<SharedPreferences>();

  ElectedMember({
    required this.memberNameEn,
    required this.memberNameMr,
    required this.wardNoEn,
    required this.wardNoMr,
    required this.emailId,
    required this.mobileNo,
  });

  String get memberName {
    if (prefs.getString("locale") == "mr") return memberNameMr;
    return memberNameEn;
  }

  String get wardNo {
    if (prefs.getString("locale") == "mr") return wardNoMr;
    return wardNoEn;
  }

  factory ElectedMember.fromXML(XmlNode xml) {
    return ElectedMember(
      memberNameEn: xml.findElements("membername").first.innerText,
      memberNameMr: xml.findElements("membernamemar").first.innerText,
      wardNoEn: xml.findElements("wardno").first.innerText,
      wardNoMr: xml.findElements("wardnomar").first.innerText,
      emailId: xml.findElements("emailid").first.innerText,
      mobileNo: xml.findElements("mobileno").first.innerText,
    );
  }
}
