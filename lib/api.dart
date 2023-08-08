import 'dart:convert';

import 'package:http/http.dart' as http;

Future<List<Frame>?> fetchData() async {
  const url = 'https://weather.madsoft.cz/api/get';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    final a = List<Frame>.from(jsonData
        .map((item) => Frame(label: item["label"], url: item["url"]))
        .toList());
    return a;
  }
  return null;
}

class Frame {
  Frame({required this.label, required this.url});
  String label, url;
}
