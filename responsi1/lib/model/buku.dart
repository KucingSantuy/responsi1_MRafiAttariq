class Buku {
  int? id;
  int? totalPages;
  String? paperType;
  String? dimensions;

  Buku({
    this.id,
    this.totalPages,
    this.paperType,
    this.dimensions,
  });

  factory Buku.fromJson(Map<String, dynamic> json) {
    return Buku(
      id: json['id'],
      totalPages: json['total_pages'],
      paperType: json['paper_type'],
      dimensions: json['dimensions'],
    );
  }
}
