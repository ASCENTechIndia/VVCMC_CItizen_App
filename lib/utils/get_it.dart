import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vvcmc_citizen_app/utils/soap_client.dart';
import 'package:vvcmc_citizen_app/utils/rest_client.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  final prefs = await SharedPreferences.getInstance();

  getIt.registerSingleton<SoapClient>(SoapClient());
  getIt.registerSingleton<RestClient>(RestClient());
  getIt.registerSingleton<SharedPreferences>(prefs);
}
