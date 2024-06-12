class CallingApi {
  final String title;
  final String link;
  final String contentSnippet; // Properti contentSnippet ditambahkan
  final String isoDate;
  final String image;

  CallingApi({
    required this.title,
    required this.link,
    required this.contentSnippet,
    required this.isoDate,
    required this.image,
  });

  // Metode untuk membuat instance News dari JSON
  factory CallingApi.fromJson(Map<String, dynamic> json) {
    return CallingApi(
      title: json['title'],
      link: json['link'],
      contentSnippet: json['contentSnippet'], // Mengambil nilai dari JSON
      isoDate: json['isoDate'],
      image: json['image']['small'], // Mengambil nilai dari JSON
    );
  }
}
