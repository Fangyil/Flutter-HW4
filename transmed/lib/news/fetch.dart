import 'dart:convert';
import 'package:http/http.dart' as http;
import 'json_data.dart';

Future<News> fetchNews(date) async {
  final response =
      await http.get(Uri.parse('https://www.hpa.gov.tw/wf/newsapi.ashx?startdate=$date&enddate=$date'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    // debugPrint('${response.stream.bytesToString()}');
    final jsonresponse = json.decode(response.body);
    return News.fromJson(jsonresponse[0] as Map<String, dynamic>);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load news');
  }
}
