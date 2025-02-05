import 'package:shared_preferences/shared_preferences.dart';
import 'package:vvcmc_citizen_app/utils/get_it.dart';
import 'package:xml/xml.dart';

class OfficialNumbers {
  final String memberNameEn;
  final String memberNameMr;
  final String designationEn;
  final String designationMr;
  final String wardName;
  final String emailId;
  final String mobileNo;
  final prefs = getIt<SharedPreferences>();

  OfficialNumbers({
    required this.memberNameEn,
    required this.memberNameMr,
    required this.designationEn,
    required this.designationMr,
    required this.wardName,
    required this.emailId,
    required this.mobileNo,
  });

  String get memberName {
    if (prefs.getString("locale") == "mr") return memberNameMr;
    return memberNameEn;
  }

  String get designation {
    if (prefs.getString("locale") == "mr") return designationMr;
    return designationEn;
  }

  factory OfficialNumbers.fromXML(XmlNode xml) {
    return OfficialNumbers(
      memberNameEn: xml.findElements("membername").first.innerText,
      memberNameMr: xml.findElements("membernamemar").first.innerText,
      designationEn: xml.findElements("designation").first.innerText,
      designationMr: xml.findElements("designationmar").first.innerText,
      wardName: xml.findElements("wardname").first.innerText,
      emailId: xml.findElements("emailid").first.innerText,
      mobileNo: xml.findElements("mobileno").first.innerText,
    );
  }
}
