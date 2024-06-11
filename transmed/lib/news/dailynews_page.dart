import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'fetch.dart';
import 'json_data.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:transmed/decoration/words.dart';
import 'package:url_launcher/url_launcher.dart';

class DailyNews extends StatefulWidget {
  const DailyNews({super.key});

  @override
  State<DailyNews> createState() => _DailyNewsState();
}

class _DailyNewsState extends State<DailyNews>
    with SingleTickerProviderStateMixin {
  late Future<News> futureNews;
  Offset offset = Offset.zero;
  final dateFormatter = DateFormat('yyyy/MM/dd');
  late DateTime selectedDate = DateTime.now();
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  void _presentDatePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    setState(() {
      if (pickedDate != null) {
        selectedDate = pickedDate;
        debugPrint(dateFormatter.format(selectedDate));
        futureNews = fetchNews(dateFormatter.format(selectedDate));
        // _age = DateTime.now().year - pickedDate.year;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    futureNews = fetchNews(dateFormatter.format(selectedDate));

    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this, // 使用 vsync
    )..repeat(reverse: true);

    _animation = Tween<Offset>(
      begin: const Offset(0, -0.1),
      end: const Offset(0, 0.1),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _launchUrl(String url) async {
    Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: FutureBuilder<News>(
              future: futureNews,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      TextButton(
                        onPressed: () {
                          _launchUrl(snapshot.data!.link);
                        },
                        child: HollowText(
                          text: snapshot.data!.title
                              .replaceAll(RegExp(r"\s+"), "\n"),
                          size: 23,
                          hollowColor: Colors.white,
                          strokeColor: Colors.black,
                          strokeWidth: 3,
                        ),
                      ),
                      const Divider(),
                      Row(
                        children: [
                          Flexible(
                            child: Html(
                                data:
                                    'publication Date:\n${snapshot.data!.pubdate}'),
                          ),
                          Flexible(
                            child: Html(
                                data:
                                    'Modification Date:\n${snapshot.data!.moddate}'),
                          ),
                        ],
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Html(data: snapshot.data!.body),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  debugPrint('${snapshot.error}');
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SlideTransition(
                        position: _animation,
                        child: const Text(
                          'Unable to fetch data.\nPlease try again later.',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 59, 16, 16),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const SpinKitFadingCircle(
                        color: Colors.red,
                        size: 50.0,
                      ),
                    ],
                  );
                }

                // By default, show a loading spinner.
                return const SpinKitCircle(
                  color: Colors.blue,
                  size: 50.0,
                );
              },
            ),
          ),
          Positioned(
            left: offset.dx,
            top: offset.dy,
            child: GestureDetector(
              onPanUpdate: (d) =>
                  setState(() => offset += Offset(d.delta.dx, d.delta.dy)),
              child: FloatingActionButton(
                onPressed: _presentDatePicker,
                backgroundColor: Colors.orange,
                child: const Icon(Icons.date_range_rounded),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
