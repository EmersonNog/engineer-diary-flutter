import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Future<Map<String, dynamic>> getWeatherData(DateTime selectedDate) async {
  final String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
  const String apiKey = '5cabedb34f924e29b22132554242102';
  const String city = 'Teresina';
  final String apiUrl =
      'http://api.weatherapi.com/v1/history.json?key=$apiKey&q=$city&dt=$formattedDate';

  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);

    final String weatherDescription =
        data['forecast']['forecastday'][0]['day']['condition']['text'];

    final double rainfall =
        data['forecast']['forecastday'][0]['day']['totalprecip_mm'];

    final double temperatureCelsius =
        data['forecast']['forecastday'][0]['day']['avgtemp_c'];

    String weatherCondition = 'DESCONHECIDO';

    if (weatherDescription.toLowerCase().contains('rain') || rainfall > 0.0) {
      weatherCondition = 'CHUVOSO';
    } else if (weatherDescription.toLowerCase().contains('cloud')) {
      weatherCondition = 'NUBLADO';
    } else {
      weatherCondition = 'ENSOLARADO';
    }

    return {
      'weatherCondition': weatherCondition,
      'rainfall': rainfall,
      'temperatureCelsius': temperatureCelsius,
    };
  } else {
    throw Exception('Falha ao carregar os dados do clima e pluviômetria.');
  }
}
