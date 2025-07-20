import 'package:flutter/material.dart';
import '../models/quotes.dart';

class QuoteCard extends StatelessWidget {
  final Quote quote;
  final VoidCallback onFavorite;
  final VoidCallback onDelete;
  final bool showDelete; // ✅ New optional parameter

  const QuoteCard({
    required this.quote,
    required this.onFavorite,
    required this.onDelete,
    this.showDelete = true, // ✅ Default to true
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onLongPress: () async {
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Delete Quote'),
              content: Text('Are you sure you want to delete this quote?'),
              actions: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                TextButton(
                  child: Text('Delete', style: TextStyle(color: Colors.red)),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            ),
          );
          if (confirmed == true) onDelete();
        },
        child: Card(
          color: Colors.pink[50]?.withOpacity(0.6), // more transparent
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // rounded edges
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Text(
                        '"${quote.text}"',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 3, 3, 3),
                        ),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 6,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '- ${quote.author} • ${quote.category}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: const Color.fromARGB(255, 88, 88, 88),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        quote.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                      ),
                      onPressed: onFavorite,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
