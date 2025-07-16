import 'package:flutter/material.dart';
import '../models/quotes.dart';
import '../services/api_service.dart';
import '../widgets/quote_card.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Quote> favorites = [];

  @override
  void initState() {
    super.initState();
    refresh();
  }

  Future<void> refresh() async {
    final list = await ApiService.fetchFavoriteQuotes();
    setState(() {
      favorites = list ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Quotes'),
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: refresh),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: favorites.isEmpty
            ? Center(child: Text('No favorite quotes yet.'))
            : ListView(
                children: favorites
                    .map((q) => QuoteCard(
                          quote: q,
                          onFavorite: () async {
                            final updated = await ApiService.toggleFavorite(q.id, !q.isFavorite);
                            if (updated != null && !updated.isFavorite) {
                              setState(() => favorites.remove(q));
                            }
                          },
                          onDelete: () async {
                            await ApiService.deleteQuote(q.id);
                            setState(() => favorites.remove(q));
                          },
                        ))
                    .toList(),
              ),
      ),
    );
  }
}
