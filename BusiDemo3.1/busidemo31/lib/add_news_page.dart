import 'package:flutter/material.dart';
import 'package:busidemo31/news_database.dart';

class AddNewsPage extends StatefulWidget {
  final News? news;

  const AddNewsPage({super.key, this.news});

  @override
  _AddNewsPageState createState() => _AddNewsPageState();
}

class _AddNewsPageState extends State<AddNewsPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  String _selectedCategory = 'News';

  @override
  void initState() {
    super.initState();
    if (widget.news != null) {
      _titleController.text = widget.news!.title;
      _summaryController.text = widget.news!.summary;
      _imageController.text = widget.news!.image;
      _selectedCategory = widget.news!.category;
    }
  }

  void _saveNews() async {
    final title = _titleController.text;
    final summary = _summaryController.text;
    final image = _imageController.text;
    final category = _selectedCategory;

    final news = News(
      id: widget.news?.id, // Ensure the id is passed for update
      title: title,
      summary: summary,
      image: image,
      category: category,
    );

    if (widget.news == null) {
      await NewsDatabase.instance.insertNews(news);
    } else {
      await NewsDatabase.instance.updateNews(news);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add News'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _summaryController,
              decoration: const InputDecoration(labelText: 'Summary'),
            ),
            TextField(
              controller: _imageController,
              decoration: const InputDecoration(labelText: 'Image URL'),
            ),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(labelText: 'Category'),
              items: ['News', 'Recruitment', 'Training']
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveNews,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
