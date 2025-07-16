import 'package:flutter/material.dart';
import '/models/quotes.dart';
import '../services/api_service.dart';

class AddQuotePage extends StatefulWidget {
  @override
  _AddQuotePageState createState() => _AddQuotePageState();
}

class _AddQuotePageState extends State<AddQuotePage> {
  final textC = TextEditingController(), authC = TextEditingController();
  String cat = 'love';
  @override
  Widget build(BuildContext ctx) => Scaffold(
        appBar: AppBar(title: Text('New Quote')),
        body: Padding(
          padding: EdgeInsets.all(12),
          child: Column(children: [
            TextField(controller: textC, decoration: InputDecoration(hintText: 'Quote')),
            SizedBox(height: 8),
            TextField(controller: authC, decoration: InputDecoration(hintText: 'Author')),
            SizedBox(height: 8),
            DropdownButton<String>(
                value: cat,
                items: ['love','healing','motivational','inner-peace']
                    .map((c) => DropdownMenuItem(child: Text(c), value: c))
                    .toList(),
                onChanged: (v) => setState(() => cat = v!)),
            Spacer(),
            ElevatedButton(
                child: Text('Submit'),
                onPressed: () async {
                  final q = Quote(id: '', text: textC.text, author: authC.text, category: cat);
                  final added = await ApiService.addQuote(q);
                  Navigator.of(ctx).pop(added);
                })
          ]),
        ),
      );
}
