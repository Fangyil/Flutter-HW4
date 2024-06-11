import 'package:flutter/material.dart';
import 'xml_data.dart';
import 'fetch.dart';
import 'detail_page.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as html_dom;

class AllDisease extends StatefulWidget {
  const AllDisease({super.key});

  @override
  State<AllDisease> createState() => _AllDiseaseState();
}

class _AllDiseaseState extends State<AllDisease> {
  Future<List<DiseaseTiles>>? futureDiseaseTiles;
  String searchTerm = '';

  @override
  void initState() {
    futureDiseaseTiles = fetchDiseaseTiles(searchTerm);
    super.initState();
  }

  Future<void> refresh() async {
    setState(() {
      futureDiseaseTiles = fetchDiseaseTiles(searchTerm);
    });
    await futureDiseaseTiles;
  }

  @override
  Widget build(BuildContext context) {
    String parseHtmlString(String htmlString) {
      final document = html_parser.parse(htmlString);
      final String parsedString =
          html_dom.DocumentFragment.html(document.body!.text).text!;
      return parsedString;
    }

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchAnchor(
              builder: (context, controller) {
                return SearchBar(
                  leading: const Icon(Icons.search),
                  controller: controller,
                  hintText: 'Search disease',
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) {
                    setState(() {
                      searchTerm = value;
                      futureDiseaseTiles = fetchDiseaseTiles(searchTerm);
                    });
                  },
                );
              },
              suggestionsBuilder:
                  (BuildContext context, SearchController controller) {
                return [];
              },
            ),
          ),
          Expanded(
            child: Center(
              child: FutureBuilder<List<DiseaseTiles>>(
                future: futureDiseaseTiles,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasData) {
                    var diseases = snapshot.data!;
                    if (diseases.isEmpty) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GiffyDialog.image(
                            Image.network(
                              "https://raw.githubusercontent.com/Shashank02051997/FancyGifDialog-Android/master/GIF's/gif14.gif",
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                            title: const Text(
                              'No results found.',
                              textAlign: TextAlign.center,
                            ),
                            content: const Text(
                              'Please re-enter the query content.',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: refresh,
                      child: ListView.builder(
                        itemCount: diseases.length,
                        itemBuilder: (context, index) {
                          var disease = diseases[index];
                          return Card.outlined(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DiseaseDetail(
                                              title: disease.title,
                                              fullsummary: disease.fullsummary,
                                            )));
                              },
                              child: ListTile(
                                title:
                                    // Html(data: disease.title),
                                    Text(
                                  parseHtmlString(disease.title),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Html(data: disease.snippet),
                                    // Text(
                                    //   maxLines: 4,
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('hasError ${snapshot.error}');
                  }
                  if (searchTerm.isEmpty) {
                    return const SizedBox();
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
