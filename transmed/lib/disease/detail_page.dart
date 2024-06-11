import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as html_dom;

class DiseaseDetail extends StatefulWidget {
  const DiseaseDetail(
      {super.key, required this.title, required this.fullsummary});

  final String title;
  final String fullsummary;

  @override
  State<DiseaseDetail> createState() => _DiseaseDetailState();
}

class _DiseaseDetailState extends State<DiseaseDetail> {
  @override
  Widget build(BuildContext context) {
    String parseHtmlString(String htmlString) {
      final document = html_parser.parse(htmlString);
      final String parsedString =
          html_dom.DocumentFragment.html(document.body!.text).text!;
      return parsedString;
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          //这是图标长按会出现的提示信息，返回按钮这么常用，应该不需要吧
          //tooltip: '返回上一页',
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
            //_nextPage(-1);
          },
        ),
        title: Text(
          parseHtmlString(widget.title),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: (widget.title.length < 23)
                ? 23
                : (widget.title.length < 28)
                    ? 20
                    : 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Html(data: widget.fullsummary),
          ],
        ),
      ),
    );
  }
}
