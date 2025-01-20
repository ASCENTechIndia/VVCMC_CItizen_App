import 'package:intl/intl.dart';

class Temperature {
  final String location;
  final String updateTime;
  final String description;
  final double temp;
  final double tempMin;
  final double tempMax;
  final String sunrise;
  final String sunset;
  final double wind;
  final int pressure;
  final int humidity;

  Temperature({
    required this.location,
    required this.description,
    required this.updateTime,
    required this.temp,
    required this.tempMin,
    required this.tempMax,
    required this.sunrise,
    required this.sunset,
    required this.wind,
    required this.pressure,
    required this.humidity,
  });

  factory Temperature.fromMap(map) {
    return Temperature(
      location: '${map["name"]}, ${map["sys"]["country"]}',
      updateTime:
          'Updated at: ${DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.now())}',
      description: map["weather"][0]["description"].toUpperCase(),
      temp: map["main"]["temp"],
      tempMin: map["main"]["temp_min"],
      tempMax: map["main"]["temp_max"],
      sunrise: DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(map["sys"]["sunrise"] * 1000)),
      sunset: DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(map["sys"]["sunset"] * 1000)),
      wind: map["wind"]["speed"],
      pressure: map["main"]["pressure"],
      humidity: map["main"]["humidity"],
    );
  }
}
