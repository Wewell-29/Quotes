import 'package:flutter/material.dart';
import '../models/quotes.dart';
import '../services/api_service.dart';
import '../widgets/quote_card.dart';
import 'add_quote_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Quote> quotes = [];
  String category = 'All', search = '';
  final cats = ['All', 'Love', 'Healing', 'Motivational', 'Inner-peace'];

  @override
  void initState() {
    super.initState();
    refresh();
  }

  Future<void> refresh() async {
    final list = await ApiService.fetchQuotes();
    setState(() {
      quotes = list ?? [];
    });
  }

  @override
  Widget build(BuildContext ctx) => Scaffold(
      body: Stack(
        children: [
          Container(
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
                  children: [
                    // Title and Refresh Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Quotes',
                            style: TextStyle(
                              fontSize: 32,
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
                          IconButton(
                            icon: Icon(Icons.refresh, color: Colors.pink),
                            onPressed: refresh,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),

                    // Search and Category Row
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Search...',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 12),
                                ),
                                onChanged: (v) => setState(() => search = v),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: DropdownButton<String>(
                                isExpanded: true,
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
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16),

                    // Quote Grid
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 6,
                        mainAxisSpacing: 6,
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        childAspectRatio: 1.1, // slightly bigger cards
                        children: quotes
                            .where((q) =>
                                (category == 'All' || q.category.toLowerCase() == category.toLowerCase()) &&
                                (q.text.contains(search) || q.author.contains(search)))
                            .map((q) => QuoteCard(
                                  quote: q,
                                  onFavorite: () async {
                                    final updated = await ApiService.toggleFavorite(
                                        q.id, !q.isFavorite);
                                    if (updated != null)
                                      setState(() {
                                        q.isFavorite = updated.isFavorite;
                                      });
                                  },
                                  onDelete: () async {
                                    await ApiService.deleteQuote(q.id);
                                    setState(() => quotes.remove(q));
                                  },
                                ))
                            .toList(),
                      ),
                    ),

                    // ...existing code...
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 24,
            right: 24,
            child: FloatingActionButton(
              backgroundColor: Colors.pinkAccent,
              child: Icon(Icons.add),
              onPressed: () async {
                final newQ = await Navigator.of(ctx)
                    .push(MaterialPageRoute(builder: (_) => AddQuotePage()));
                if (newQ != null) setState(() => quotes.insert(0, newQ));
              },
            ),
          ),
        ],
      ),
    );
}
