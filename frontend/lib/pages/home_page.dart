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
  final cats = ['All', 'love', 'healing', 'motivational', 'inner-peace'];

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
        appBar: AppBar(
          title: Text('Quotes'),
          actions: [
            IconButton(icon: Icon(Icons.refresh), onPressed: refresh),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(110),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(children: [
                TextField(
                  decoration: InputDecoration(
                      hintText: 'Search...', border: OutlineInputBorder()),
                  onChanged: (v) => setState(() => search = v),
                ),
                DropdownButton<String>(
                  value: category,
                  items: cats.map((c) => DropdownMenuItem(child: Text(c), value: c)).toList(),
                  onChanged: (v) => setState(() => category = v!),
                )
              ]),
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: refresh,
          child: ListView(
            children: quotes
                .where((q) =>
                    (category == 'All' || q.category == category) &&
                    (q.text.contains(search) || q.author.contains(search)))
                .map((q) => QuoteCard(
                      quote: q,
                      onFavorite: () async {
                        final updated = await ApiService.toggleFavorite(q.id, !q.isFavorite);
                        if (updated != null) setState(() {
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
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            final newQ = await Navigator.of(ctx).push(MaterialPageRoute(builder: (_) => AddQuotePage()));
            if (newQ != null) setState(() => quotes.insert(0, newQ));
          },
        ),
      );
}
