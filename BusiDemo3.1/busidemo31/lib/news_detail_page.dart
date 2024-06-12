import 'package:flutter/material.dart';
import 'package:busidemo31/news_database.dart';
import 'package:busidemo31/news_api.dart';

class NewsDetailPage extends StatelessWidget {
  final News? localNews;
  final CallingApi? apiNews;

  const NewsDetailPage({Key? key, this.localNews, this.apiNews}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final newsTitle = localNews?.title ?? apiNews?.title ?? 'News Detail';
    final newsImage = localNews?.image ?? apiNews?.image ?? '';
    final newsContent = localNews?.summary ?? apiNews?.contentSnippet ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(newsTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(newsImage, errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.broken_image);
            }),
            const SizedBox(height: 10, width: 30),
            Text(
              newsTitle,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              newsContent,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
