import 'package:web_scraper/web_scraper.dart';

Future<String> fetchUVIndex() async {
  final webScraper = WebScraper('https://weather.com');
  if (await webScraper.loadWebPage(
      '/tr-TR/weather/hourbyhour/l/34661e431fa4c3c2614f842c86d6a7b362d02990e224984c613648d53ee4da0f')) {
    final elements = webScraper.getElement(
        'span[data-testid="UVIndexValue"].DetailsTable--value--2YD0-', []);
    if (elements.isNotEmpty) {
      return elements[0]['title'];
    }
  }
  throw Exception('UV index not found');
}
