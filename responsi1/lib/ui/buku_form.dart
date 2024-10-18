import 'package:responsi1/bloc/buku_bloc.dart';
import 'package:responsi1/model/buku.dart';
import 'package:responsi1/ui/buku_page.dart';
import 'package:responsi1/widget/success_dialog.dart';
import 'package:responsi1/widget/warning_dialog.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BukuForm extends StatefulWidget {
  Buku? buku;
  BukuForm({Key? key, this.buku}) : super(key: key);
  @override
  _BukuFormState createState() => _BukuFormState();
}

class _BukuFormState extends State<BukuForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String judul = "TAMBAH BUKU";
  String tombolSubmit = "SIMPAN";

  // Controllers for form fields
  final _totalPagesController = TextEditingController();
  final _paperTypeController = TextEditingController();
  final _dimensionsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  isUpdate() {
    if (widget.buku != null) {
      setState(() {
        judul = "UBAH BUKU";
        tombolSubmit = "UBAH";
        _totalPagesController.text = widget.buku!.totalPages.toString();
        _paperTypeController.text = widget.buku!.paperType!;
        _dimensionsController.text = widget.buku!.dimensions!;
      });
    } else {
      judul = "TAMBAH BUKU";
      tombolSubmit = "SIMPAN";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(judul)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _totalPagesTextField(),
                _paperTypeTextField(),
                _dimensionsTextField(),
                _buttonSubmit()
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Membuat Textbox untuk Jumlah Halaman
  Widget _totalPagesTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Jumlah Halaman"),
      keyboardType: TextInputType.number,
      controller: _totalPagesController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Jumlah Halaman harus diisi";
        }
        return null;
      },
    );
  }

  // Membuat Textbox untuk Tipe Kertas
  Widget _paperTypeTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Tipe Kertas"),
      keyboardType: TextInputType.text,
      controller: _paperTypeController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Tipe Kertas harus diisi";
        }
        return null;
      },
    );
  }

  // Membuat Textbox untuk Dimensi Buku
  Widget _dimensionsTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Dimensi"),
      keyboardType: TextInputType.text,
      controller: _dimensionsController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Dimensi harus diisi";
        }
        return null;
      },
    );
  }

  // Membuat Tombol Simpan/Ubah
  Widget _buttonSubmit() {
    return OutlinedButton(
        child: Text(tombolSubmit),
        onPressed: () {
          var validate = _formKey.currentState!.validate();
          if (validate) {
            if (!_isLoading) {
              if (widget.buku != null) {
                // Kondisi update buku
                ubah();
              } else {
                // Kondisi tambah buku
                simpan();
              }
            }
          }
        });
  }

  // Fungsi untuk menyimpan buku baru
  void simpan() {
    setState(() {
      _isLoading = true;
    });
    Buku newBuku = Buku(
      id: null,
      totalPages: int.parse(_totalPagesController.text),
      paperType: _paperTypeController.text,
      dimensions: _dimensionsController.text,
    );
    BukuBloc.addBuku(buku: newBuku).then((value) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => const BukuPage()));
      showDialog(
          context: context,
          builder: (BuildContext context) => const SuccessDialog(
                description: "Data berhasil disimpan",
              ));
    }, onError: (error) {
      showDialog(
          context: context,
          builder: (BuildContext context) => const WarningDialog(
                description: "Simpan gagal, silahkan coba lagi",
              ));
    });
    setState(() {
      _isLoading = false;
    });
  }

  // Fungsi untuk mengubah data buku
  void ubah() {
    setState(() {
      _isLoading = true;
    });
    Buku updatedBuku = Buku(
      id: widget.buku!.id,
      totalPages: int.parse(_totalPagesController.text),
      paperType: _paperTypeController.text,
      dimensions: _dimensionsController.text,
    );
    BukuBloc.updateBuku(buku: updatedBuku).then((value) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => const BukuPage()));
      showDialog(
          context: context,
          builder: (BuildContext context) => const SuccessDialog(
                description: "Data berhasil diubah",
              ));
    }, onError: (error) {
      showDialog(
          context: context,
          builder: (BuildContext context) => const WarningDialog(
                description: "Permintaan ubah data gagal, silahkan coba lagi",
              ));
    });
    setState(() {
      _isLoading = false;
    });
  }
}
