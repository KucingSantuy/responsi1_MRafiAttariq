class ApiUrl {
  static const String baseUrl = 'http://103.196.155.42/api'; // ip responsi
  static const String baseUrlBuku = baseUrl + '/buku';
  static const String registrasi = baseUrl + '/registrasi';
  static const String login = baseUrl + '/login';
  static const String listBuku = baseUrlBuku + '/jumlah_halaman';
  static const String create = baseUrlBuku + '/jumlah_halaman';
  static String update(int id) {
    return baseUrlBuku + '/jumlah_halaman/' + id.toString() + '/update';
  }

  static String show(int id) {
    return baseUrlBuku + '/jumlah_halaman/' + id.toString();
  }

  static String delete(int id) {
    return baseUrlBuku + '/jumlah_halaman/' + id.toString() + '/delete';
  }
}
