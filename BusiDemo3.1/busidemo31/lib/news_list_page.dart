import 'package:flutter/material.dart';
import 'package:busidemo31/news_database.dart';
import 'package:busidemo31/news_detail_page.dart';
import 'package:busidemo31/add_news_page.dart';
import 'package:busidemo31/login_page.dart';
import 'package:busidemo31/user.dart';
import 'package:busidemo31/api_service.dart';
import 'package:busidemo31/news_api.dart'; // Import CallingApi

class NewsListPage extends StatefulWidget {
  const NewsListPage({super.key});

  @override
  _NewsListPageState createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  List<dynamic> newsList = [];
  String selectedCategory = 'News';
  User? loggedInUser;
  final apiService =
      ApiService(baseUrl: 'https://berita-indo-api-next.vercel.app'); // API URL

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  void _fetchNews() async {
    try {
      final apiNews = await apiService.fetchNews();
      final dbNews = await NewsDatabase.instance.fetchNews(selectedCategory);
      setState(() {
        newsList = [
          ...apiNews.map((news) => CallingApi.fromJson(news)).toList(),
          ...dbNews,
        ];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load news: ${e.toString()}")),
      );
    }
  }

  void _handleLogin(User user) {
    setState(() {
      loggedInUser = user;
    });
  }

  void _logout() {
    setState(() {
      loggedInUser = null;
    });
  }

  void _changeCategory(String category) {
    setState(() {
      selectedCategory = category;
      _fetchNews();
    });
  }

  void _deleteNews(int id) async {
    await NewsDatabase.instance.deleteNews(id);
    _fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BUSI"),
        actions: [
          if (loggedInUser == null) // Jika belum login
            IconButton(
              icon: const Icon(Icons.login),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(onLogin: _handleLogin),
                  ),
                );
              },
            )
          else // Jika sudah login
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == "logout") {
                  _logout(); // Tombol logout
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: "logout",
                  child: Text("Logout"),
                ),
              ],
              child: Row(
                children: [
                  Text(loggedInUser!.username), // Nama pengguna
                  if (loggedInUser!.lastLoginLocation != null)
                    Text(
                      " (${loggedInUser!.lastLoginLocation})", // Lokasi login
                      style: const TextStyle(fontSize: 12),
                    ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          PopupMenuButton<String>(
            onSelected: _changeCategory,
            itemBuilder: (context) {
              return ["News", "Recruitment", "Training"].map((category) {
                return PopupMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNewsPage(),
            ),
          );
          _fetchNews(); // Fetch news again after adding new news
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: newsList.length,
        itemBuilder: (context, index) {
          final news = newsList[index];
          final String id = news is News
              ? news.id.toString()
              : news.link; // Gunakan 'link' jika 'id' tidak tersedia

          // Periksa apakah berita dari kategori yang dipilih
          final bool isCategoryMatched =
              news is News ? news.category == selectedCategory : true;

          // Jika kategori berita cocok dengan yang dipilih, tampilkan
          if (isCategoryMatched) {
            return Dismissible(
              key: Key(id), // Gunakan 'id' atau 'link' sebagai kunci
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                if (news is News) {
                  _deleteNews(news.id!);
                }
              },
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 16),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        if (news is CallingApi) {
                          return NewsDetailPage(apiNews: news);
                        } else if (news is News) {
                          return NewsDetailPage(localNews: news);
                        } else {
                          return Container(); // Handle other cases if needed
                        }
                      },
                    ),
                  );
                },
                child: ListTile(
                  leading: Image.network(
                    news is CallingApi ? news.image : (news as News).image,
                  ), // Mengambil gambar kecil
                  title: Text(
                    news is CallingApi ? news.title : (news as News).title,
                  ),
                  subtitle: Text(
                    news is CallingApi
                        ? news.contentSnippet
                        : (news as News).summary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddNewsPage(news: news),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          } else {
            // Jika berita tidak dari kategori yang dipilih, return widget kosong
            return SizedBox.shrink();
          }
        },
      ),
    );
  }
}
