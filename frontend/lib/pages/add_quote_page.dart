import 'package:flutter/material.dart';
import '/models/quotes.dart';
import '../services/api_service.dart';

class AddQuotePage extends StatefulWidget {
  @override
  _AddQuotePageState createState() => _AddQuotePageState();
}

class _AddQuotePageState extends State<AddQuotePage> {
  final textC = TextEditingController(), authC = TextEditingController();
  String cat = 'Love';
  @override
  Widget build(BuildContext ctx) => Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Card(
                color: Colors.pink[50]?.withOpacity(0.6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Title styled like Home page
                      Text(
                        'Add a New Quote',
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
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: textC,
                        decoration: InputDecoration(
                          hintText: 'Quote',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        ),
                        maxLines: 3,
                      ),
                      SizedBox(height: 12),
                      TextField(
                        controller: authC,
                        decoration: InputDecoration(
                          hintText: 'Author',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        ),
                      ),
                      SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: cat,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        ),
                        items: ['Love','Healing','Motivational','Inner-peace']
                            .map((c) => DropdownMenuItem(child: Text(c), value: c))
                            .toList(),
                        onChanged: (v) => setState(() => cat = v!),
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text('Submit', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                        onPressed: () async {
                          final q = Quote(id: '', text: textC.text, author: authC.text, category: cat.toLowerCase());
                          final added = await ApiService.addQuote(q);
                          Navigator.of(ctx).pop(added);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
