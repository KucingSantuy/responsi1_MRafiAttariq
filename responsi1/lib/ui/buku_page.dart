import 'package:responsi1/bloc/buku_bloc.dart';
import 'package:responsi1/bloc/logout_bloc.dart';
import 'package:responsi1/model/buku.dart';
import 'package:responsi1/ui/buku_detail.dart';
import 'package:responsi1/ui/buku_form.dart';
import 'package:responsi1/ui/login_page.dart';
import 'package:responsi1/widget/success_dialog.dart';
import 'package:flutter/material.dart';

class BukuPage extends StatefulWidget {
  const BukuPage({Key? key}) : super(key: key);
  @override
  _BukuPageState createState() => _BukuPageState();
}

class _BukuPageState extends State<BukuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Buku'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: const Icon(Icons.add, size: 26.0),
              onTap: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BukuForm()));
              },
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Logout'),
              trailing: const Icon(Icons.logout),
              onTap: () async {
                await LogoutBloc.logout().then((value) => {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => LoginPage()),
                          (route) => false),
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) =>
                              const SuccessDialog(
                                description: "Logout berhasil",
                              ))
                    });
              },
            )
          ],
        ),
      ),
      body: FutureBuilder<List<Buku>>(
        future: BukuBloc.getBuku(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? ListBuku(
                  list: snapshot.data,
                )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}

class ListBuku extends StatelessWidget {
  final List? list;
  const ListBuku({Key? key, this.list}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: list == null ? 0 : list!.length,
        itemBuilder: (context, i) {
          return ItemBuku(
            buku: list![i],
          );
        });
  }
}

class ItemBuku extends StatelessWidget {
  final Buku buku;
  const ItemBuku({Key? key, required this.buku}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BukuDetail(
                      buku: buku,
                    )));
      },
      child: Card(
        child: ListTile(
          title: Text(buku.totalPages.toString()),
          subtitle: Text(buku.paperType!),
        ),
      ),
    );
  }
}
