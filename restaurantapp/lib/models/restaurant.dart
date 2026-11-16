// Model data restaurant dari API Dicoding.
// Satu class dipakai untuk list, detail, dan favorit (Hive).

class Restaurant {
  String id;
  String name;
  String description;
  String city;
  String address;
  String pictureId;
  double rating;
  //ini menu dan kategori dijaiin list
  List<String> categories;
  List<String> foods;
  List<String> drinks;
  List<Review> reviews;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    required this.rating,
    //ini tu dijadiin const [] biar ga error, karna isinya jg ntar kan ga pasti
    this.categories = const [],
    this.foods = const [],
    this.drinks = const [],
    this.reviews = const [],
  });

  // Link gambar: small / medium / large
  String get imageUrl =>
      'https://restaurant-api.dicoding.dev/images/medium/$pictureId';

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    final menus = json['menus'] as Map<String, dynamic>?;

    return Restaurant(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      city: json['city'] ?? '',
      address: json['address'] ?? '',
      pictureId: json['pictureId'] ?? '',
      // Sesuai soal: rating bisa int atau double, jadi pakai num lalu toDouble
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      categories: _namaList(json['categories']),
      foods: _namaList(menus?['foods']),
      drinks: _namaList(menus?['drinks']),
      // mengubah daftar review mentah dari JSON API menjadi daftar objek Dart (List<Review>) yang siap dipakai di UI.
      reviews: (json['customerReviews'] as List? ?? [])
          .map((e) => Review.fromJson(e))
          .toList(),
    );
  }

  // Data yang disimpan ke database lokal (cukup untuk tampil di list favorit)
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'city': city,
    'address': address,
    'pictureId': pictureId,
    'rating': rating,
  };

  // API mengirim [{"name": "Italia"}, ...] -> diubah jadi ["Italia", ...]
  static List<String> _namaList(dynamic data) {
    if (data is! List) return [];
    return data.map((e) => e['name'].toString()).toList();
  }
}

class Review {
  String name;
  String review;
  String date;

  Review({required this.name, required this.review, required this.date});

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    name: json['name'] ?? '',
    review: json['review'] ?? '',
    date: json['date'] ?? '',
  );
}
