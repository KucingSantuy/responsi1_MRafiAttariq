import 'dart:convert';

import 'package:responsi1/helpers/api.dart';
import 'package:responsi1/helpers/api_url.dart';
import 'package:responsi1/model/buku.dart';

class BukuBloc {
  static Future<List<Buku>> getBuku() async {
    String apiUrl = ApiUrl.listBuku;
    var response = await Api().get(apiUrl);
    var jsonObj = json.decode(response.body);
    List<dynamic> listBuku = (jsonObj as Map<String, dynamic>)['data'];
    List<Buku> bukus = [];
    for (int i = 0; i < listBuku.length; i++) {
      bukus.add(Buku.fromJson(listBuku[i]));
    }
    return bukus;
  }

  static Future addBuku({Buku? buku}) async {
    String apiUrl = ApiUrl.create;
    var body = {
      "total_pages": buku!.totalPages.toString(),
      "paper_type": buku.paperType,
      "dimensions": buku.dimensions
    };
    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  static Future updateBuku({required Buku buku}) async {
    String apiUrl = ApiUrl.update(buku.id!);
    print(apiUrl);
    var body = {
      "total_pages": buku.totalPages.toString(),
      "paper_type": buku.paperType,
      "dimensions": buku.dimensions
    };
    print("Body : $body");
    var response = await Api().put(apiUrl, jsonEncode(body));
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  static Future<bool> deleteBuku({int? id}) async {
    String apiUrl = ApiUrl.delete(id!);
    var response = await Api().delete(apiUrl);
    var jsonObj = json.decode(response.body);
    return (jsonObj as Map<String, dynamic>)['status'];
  }
}
