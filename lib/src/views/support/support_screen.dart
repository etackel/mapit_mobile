import 'package:flutter/material.dart';

import '../../constants/faq_data.dart';
import '../../models/FAQ.dart';

class SupportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQ'),
      ),
      body: SafeArea(
        top: true,
        bottom: true,
        child: Column(
          children: [
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: faqs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return FAQTile(faq: faqs[index]);
                },
              ),
            ),
          ],
        ),
      )
    );
  }
}

class FAQTile extends StatefulWidget {
  final FAQ faq;

  FAQTile({required this.faq});

  @override
  _FAQTileState createState() => _FAQTileState();
}

class _FAQTileState extends State<FAQTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _expanded = !_expanded;
        });
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.faq.question,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_expanded)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(widget.faq.answer),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
