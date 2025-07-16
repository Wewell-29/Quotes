import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quotes.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiService {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000/api/quotes';
    } else {
      return 'http://10.0.2.2:3000/api/quotes';
    }
  }

  static Future<List<Quote>> fetchQuotes() async {
    final resp = await http.get(Uri.parse(baseUrl));
    return resp.statusCode == 200
        ? (json.decode(resp.body) as List).map((j) => Quote.fromJson(j)).toList()
        : [];
  }

  static Future<List<Quote>> fetchFavoriteQuotes() async {
    final resp = await http.get(Uri.parse(baseUrl + '/favorites'));
    return resp.statusCode == 200
        ? (json.decode(resp.body) as List).map((j) => Quote.fromJson(j)).toList()
        : [];
  }

  static Future<Quote?> addQuote(Quote q) async {
    final resp = await http.post(Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'}, body: json.encode(q.toJson()));
    return resp.statusCode == 200 ? Quote.fromJson(json.decode(resp.body)) : null;
  }

  static Future<bool> deleteQuote(String id) async {
    final resp = await http.delete(Uri.parse('${baseUrl}/$id'));
    return resp.statusCode == 200;
  }

  static Future<Quote?> toggleFavorite(String id, bool fav) async {
    final resp = await http.put(Uri.parse('${baseUrl}/$id/favorite'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'isFavorite': fav}));
    return resp.statusCode == 200 ? Quote.fromJson(json.decode(resp.body)) : null;
  }
}
