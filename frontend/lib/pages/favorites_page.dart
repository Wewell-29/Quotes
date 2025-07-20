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
  String category = 'All';
  final cats = ['All', 'Love', 'Healing', 'Motivational', 'Inner-peace'];

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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: refresh,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Floating title, category filter, and refresh button
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Favorite Quotes',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink[700],
                          shadows: [
                            Shadow(
                              blurRadius: 4,
                              color: Colors.white70,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                      ),
                      // Category filter dropdown
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButton<String>(
                          isExpanded: false,
                          value: category,
                          dropdownColor: Colors.pink[50],
                          underline: SizedBox(),
                          items: cats
                              .map((c) => DropdownMenuItem(
                                    child: Text(c),
                                    value: c,
                                  ))
                              .toList(),
                          onChanged: (v) => setState(() => category = v!),
                        ),
                      ),
                    ],
                  ),
                ),

                // Grid of quote cards
                Expanded(
                  child: favorites.isEmpty
                      ? Center(
                          child: Text(
                            'No favorite quotes yet.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.pink[900],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 6,
                          padding: EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          childAspectRatio: 1.1, // slightly bigger cards
                          children: favorites
                              .where((q) => category == 'All' || q.category.toLowerCase() == category.toLowerCase())
                              .map((q) => QuoteCard(
                                    quote: q,
                                    onFavorite: () async {
                                      final updated =
                                          await ApiService.toggleFavorite(
                                              q.id, !q.isFavorite);
                                      if (updated != null &&
                                          !updated.isFavorite) {
                                        setState(() =>
                                            favorites.remove(q));
                                      }
                                    },
                                    onDelete: () async {
                                      await ApiService.deleteQuote(q.id);
                                      setState(() =>
                                          favorites.remove(q));
                                    },
                                    showDelete: false,
                                  ))
                              .toList(),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
