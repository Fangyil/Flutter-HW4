class News {
  final String title;
  final String body;
  final String link;
  // final String attach;
  final String pubdate;
  final String moddate;

  const News({
    required this.title,
    required this.body,
    required this.link,
    // required this.attach,
    required this.pubdate,
    required this.moddate,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        '標題': String title,
        '內容': String body,
        '連結網址': String link,
        // '附加檔案': String attach,
        '發布日期': String pubdate,
        '修改日期': String moddate,
      } =>
        News(
          title: title,
          body: body,
          // attach: attach,
          link: link,
          pubdate: pubdate,
          moddate: moddate,
        ),
      _ => throw const FormatException('Failed to load News.'),
    };
  }
}