class GoogleBook {
  final String title;
  final String edition;
  final String description;
  final String subtitle;
  final String publisher;
  final String publishedDate; // always yyyy-MM-dd
  final String authors;
  final String firstAuthor;
  final String isbn;
  final String thumbnail;
  final String copies;
  final String price;
  final String? previewLink;
  final String? infoLink;
  final String? pdfDownloadLink;
  final bool isAddedToServer;
  GoogleBook({
    required this.title,
    required this.edition,
    required this.subtitle,
    required this.thumbnail,
    required this.firstAuthor,
    required this.publisher,
    required this.authors,
    required this.publishedDate,
    required this.description,
    required this.isbn,
    required this.copies,
    required this.price,
    this.previewLink,
    this.infoLink,
    this.pdfDownloadLink,
    this.isAddedToServer = false,
  });

  // Helper to normalize the date
  static String formatPublishedDate(String rawDate) {
    try {
      // Only year
      if (RegExp(r'^\d{4}$').hasMatch(rawDate)) {
        return "$rawDate-01-01";
      }
      // Year + month
      if (RegExp(r'^\d{4}-\d{2}$').hasMatch(rawDate)) {
        return "$rawDate-01";
      }
      // Full date
      if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(rawDate)) {
        return rawDate;
      }
      // Fallback to today
      return DateTime.now().toIso8601String().split("T")[0];
    } catch (e) {
      return DateTime.now().toIso8601String().split("T")[0];
    }
  }

  factory GoogleBook.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] ?? {};
    final authorsList = List<String>.from(volumeInfo['authors'] ?? []);
    final authorsString = authorsList.isNotEmpty ? authorsList.join(", ") : "Unknown Author";
    final firstAuthor = authorsList.isNotEmpty ? authorsList[0] : "Unknown Author";
    final accessInfo = json['accessInfo'] ?? {};
    final identifiers = volumeInfo['industryIdentifiers'] ?? [];
    final previewLink = volumeInfo['previewLink'];
    final infoLink = volumeInfo['infoLink'];

    final pdfDownloadLink =
        accessInfo['pdf']?['downloadLink'] ??
            accessInfo['webReaderLink'];
    String isbnString = "N/A";
    if (identifiers.isNotEmpty) {
      isbnString = identifiers.firstWhere(
            (id) => id['type'] == 'ISBN_13',
        orElse: () => identifiers[0],
      )['identifier'].toString();
    }

    final rawDate = volumeInfo['publishedDate'] ?? "";
    final normalizedDate = formatPublishedDate(rawDate);

    return GoogleBook(
      title: volumeInfo['title'] ?? "Unknown Title",
      publisher: volumeInfo['publisher'] ?? "Unknown Publisher",
      edition: volumeInfo['printType'] ?? "N/A",
      authors: authorsString,
      firstAuthor: firstAuthor,
      copies: (volumeInfo['copies'] ?? "0").toString(),
      price: (volumeInfo['price'] ?? "0").toString(),
      description: volumeInfo['description'] ?? "No Description Available",
      isbn: isbnString,
      publishedDate: normalizedDate, // use normalized date
      subtitle: volumeInfo['subtitle'] ?? "",
      thumbnail: (volumeInfo['imageLinks']?['thumbnail'] ?? "")
          .toString().replaceFirst('http:', 'https:'),
      previewLink: previewLink,
      infoLink: infoLink,
      pdfDownloadLink: pdfDownloadLink,
      isAddedToServer: false,
    );
  }
}