import 'package:flutter/material.dart';
import '../models/quotes.dart';

class QuoteCard extends StatelessWidget {
  final Quote quote;
  final VoidCallback onFavorite;
  final VoidCallback onDelete;

  const QuoteCard({
    required this.quote,
    required this.onFavorite,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext _) => Card(
        child: ListTile(
          title: Text('"${quote.text}"'),
          subtitle: Text('- ${quote.author} • ${quote.category}'),
          leading: IconButton(
            icon:
                Icon(quote.isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.red),
            onPressed: onFavorite,
          ),
          trailing: IconButton(icon: Icon(Icons.delete), onPressed: onDelete),
        ),
      );
}
