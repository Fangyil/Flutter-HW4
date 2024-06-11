import 'package:http/http.dart' as http;
import 'xml_data.dart';
import 'package:xml/xml.dart';

Future<List<DiseaseTiles>> fetchDiseaseTiles(String searchTerm) async {
  var url = Uri.parse(
      'https://wsearch.nlm.nih.gov/ws/query?db=healthTopics&term=$searchTerm');
  var response = await http.get(url);

  if (response.statusCode == 200) {
    var document = XmlDocument.parse(response.body);
    var tiles = <DiseaseTiles>[];

    // 解析XML並創建DiseaseTiles列表
    var results = document.findAllElements('document');
    for (var result in results) {
      var title = result
          .findElements('content')
          .firstWhere((element) => element.getAttribute('name') == 'title')
          .text;
      var fullsummary = result
          .findElements('content')
          .firstWhere(
              (element) => element.getAttribute('name') == 'FullSummary')
          .text;
      var snippet = result
          .findElements('content')
          .firstWhere((element) => element.getAttribute('name') == 'snippet')
          .text;

      var tile = DiseaseTiles(
          title: title, fullsummary: fullsummary, snippet: snippet);
      tiles.add(tile);
    }

    return tiles;
  } else {
    throw Exception('Failed to load tracks');
  }
}
