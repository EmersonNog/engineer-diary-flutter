import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> getWeatherData() async {
  const String apiKey = 'af002c4c741cf2dbbb790ec5047df93e';
  const String city = 'Teresina'; // Florianópolis normalmente é chuvoso; Teresina normalmente é ensolarado
  const String apiUrl =
      'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey';

  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);

    final String weatherDescription = data['weather'][0]['description'];

    final double rainfall = data['rain'] != null ? data['rain']['1h'] : 0.0;

    final double temperatureKelvin = data['main']['temp'];
    final double temperatureCelsius = temperatureKelvin - 272.15 ;

    String weatherCondition = 'DESCONHECIDO';

    if (weatherDescription.toLowerCase().contains('rain') || rainfall > 0.0) {
      weatherCondition = 'CHUVOSO';
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
