import 'package:xml/xml.dart';

class BusSchedule {
  final String routeNo;
  final String from;
  final String to;
  final String stages;
  final String startTime;
  final String endTime;
  final String frequency;

  BusSchedule({
    required this.routeNo,
    required this.from,
    required this.to,
    required this.stages,
    required this.startTime,
    required this.endTime,
    required this.frequency,
  });

  factory BusSchedule.fromXML(XmlNode xml) {
    return BusSchedule(
      routeNo: xml.findElements("rno").first.innerText,
      from: xml.findElements("rfrom").first.innerText,
      to: xml.findElements("rto").first.innerText,
      stages: xml.findElements("stages").first.innerText,
      startTime: xml.findElements("start_time").first.innerText,
      endTime: xml.findElements("end_time").first.innerText,
      frequency: xml.findElements("frequency").first.innerText,
    );
  }
}
