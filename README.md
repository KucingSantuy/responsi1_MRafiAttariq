1.  	Proses Registrasi

a.      Mengisi Form Registrasi

Pengguna diminta untuk mengisi nama, email, password, dan konfirmasi password.
Kode terkait:
Widget _namaTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Nama"),
      keyboardType: TextInputType.text,
      controller: _namaTextboxController,
      validator: (value) {
        if (value!.length < 3) {
          return "Nama harus diisi minimal 3 karakter";
        }
        return null;
      },
    );
  }


  //Membuat Textbox email
  Widget _emailTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Email"),
      keyboardType: TextInputType.emailAddress,
      controller: _emailTextboxController,
      validator: (value) {
        //validasi harus diisi
        if (value!.isEmpty) {
          return 'Email harus diisi';
        }
        //validasi email
        Pattern pattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regex = RegExp(pattern.toString());
        if (!regex.hasMatch(value)) {
          return "Email tidak valid";
        }
        return null;
      },
    );
  }


//Membuat Textbox password
  Widget _passwordTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Password"),
      keyboardType: TextInputType.text,
      obscureText: true,
      controller: _passwordTextboxController,
      validator: (value) {
        //jika karakter yang dimasukkan kurang dari 6 karakter
        if (value!.length < 3) {
          return "Password harus diisi minimal 3 karakter";
        }
        return null;
      },
    );
  }


//membuat textbox Konfirmasi Password
  Widget _passwordKonfirmasiTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Konfirmasi Password"),
      keyboardType: TextInputType.text,
      obscureText: true,
      validator: (value) {
        //jika inputan tidak sama dengan password
        if (value != _passwordTextboxController.text) {
          return "Konfirmasi Password tidak sama";
        }
        return null;
      },
    );
  }

b.      Proses Pengiriman Data Registrasi
Setelah menekan tombol registrasi, aplikasi akan mengirim data ke API.
Kode terkait:
void _submit() {
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    RegistrasiBloc.registrasi(
            nama: _namaTextboxController.text,
            email: _emailTextboxController.text,
            password: _passwordTextboxController.text)
        .then((value) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => SuccessDialog(
                description: "Registrasi berhasil, silahkan login",
                okClick: () {
                  Navigator.pop(context);
                },
              ));
    }, onError: (error) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const WarningDialog(
                description: "Registrasi gagal, silahkan coba lagi",
              ));
    });
    setState(() {
      _isLoading = false;
    });
  }
}



c.      Hasil Registrasi
Pengguna akan melihat popup yang menginformasikan hasil registrasi.

2.  	Proses Login

a.      Mengisi Form Login

Pengguna diminta untuk memasukkan email dan password pada form login.
Kode terkait:
Widget _emailTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Email",
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(fontFamily: 'Verdana'),
      keyboardType: TextInputType.emailAddress,
      controller: _emailTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Email harus diisi';
        }
        return null;
      },
    );
  }


  Widget _passwordTextField() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: "Password",
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        style: const TextStyle(fontFamily: 'Verdana'),
        keyboardType: TextInputType.text,
        obscureText: true,
        controller: _passwordTextboxController,
        validator: (value) {
          if (value!.isEmpty) {
            return "Password harus diisi";
          }
          return null;
        },
      ),
    );
  }


b.      Proses Autentikasi
Setelah menekan tombol login, aplikasi akan mengirim permintaan ke API untuk melakukan autentikasi.
Kode terkait:
void _submit() {
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });


    LoginBloc.login(
            email: _emailTextboxController.text,
            password: _passwordTextboxController.text)
        .then((value) async {
      if (value.code == 200) {
        await UserInfo().setToken(value.token ?? "");
        await UserInfo().setUserID(int.tryParse(value.userID.toString()) ?? 0);


        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => SuccessDialog(
            description: "Login berhasil",
            okClick: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const BukuPage(),
                ),
              );
            },
          ),
        );
      } else {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => const WarningDialog(
                  description: "Login gagal, silahkan coba lagi",
                ));
      }
    }, onError: (error) {
      print(error);
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const WarningDialog(
                description: "Login gagal, silahkan coba lagi",
              ));
    });


    setState(() {
      _isLoading = false;
    });
  }

c.      Hasil Login
Setelah proses autentikasi, pengguna akan melihat popup yang menginformasikan hasil login.

3.  	Menampilkan Daftar Jenis Halaman

a.      Halaman Utama Jenis halaman pada buku
Setelah login berhasil, pengguna akan diarahkan ke halaman utama yang menampilkan daftar jenis halaman.
Kode terkait:
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

b.      Proses Pengambilan Data Jenis Halaman
Data Jenis Halaman diambil dari API menggunakan ProdukBloc.getProduks().
Kode terkait:
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



4.  	Melihat Detail Jenis Halaman

a.      Memilih Jenis Halaman dari Daftar
Pengguna dapat melihat detail jenis halaman dengan menekan item Jenis Halaman di daftar.
b.      Halaman Detail Jenis Halaman
Halaman ini menampilkan informasi lengkap tentang Jenis Halaman yang dipilih.
Kode terkait:
class BukuDetail extends StatefulWidget {
  Buku? buku;
  BukuDetail({Key? key, this.buku}) : super(key: key);
  @override
  _BukuDetailState createState() => _BukuDetailState();
}


class _BukuDetailState extends State<BukuDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Buku'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "ID Buku: ${widget.buku!.id}",
                style: const TextStyle(fontSize: 20.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Jumlah Halaman: ${widget.buku!.totalPages}",
                style: const TextStyle(fontSize: 18.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Tipe Kertas: ${widget.buku!.paperType}",
                style: const TextStyle(fontSize: 18.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Dimensi: ${widget.buku!.dimensions}",
                style: const TextStyle(fontSize: 18.0),
              ),
            ),
            _tombolHapusEdit()
          ],
        ),
      ),
    );
  }



5.  	Menambah Jenis Halaman Baru

a.      Membuka Form Tambah Jenis Halaman
Pengguna dapat menambah Jenis Halaman baru dengan menekan ikon "+" di halaman utama.
b.      Mengisi Data Jenis Halaman Baru
Pengguna diminta untuk mengisi bahasa asli, bahasa Jenis Halaman, dan nama penerjemah.
Kode terkait:
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

c.      Proses Penyimpanan Jenis Halaman Baru

Setelah menekan tombol simpan, aplikasi akan mengirim data ke API.
Kode terkait:
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

d.      Hasil Penambahan Jenis Halaman

Pengguna akan melihat popup yang menginformasikan hasil penambahan Jenis Halaman.
6.  	Mengubah Jenis Halaman
a.      Membuka Form Ubah Jenis Halaman

Dari halaman detail Jenis Halaman, pengguna dapat menekan tombol "EDIT" untuk membuka form ubah Jenis Halaman.
b.      Mengisi Perubahan Data Jenis Halaman

Form ubah Jenis Halaman akan terisi dengan data produk yang ada, dan pengguna dapat mengubahnya.
c.      Proses Penyimpanan Perubahan Jenis Halaman
Setelah menekan tombol ubah, aplikasi akan mengirim data perubahan ke API.
Kode terkait:
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



d.      Hasil Pengubahan Jenis Halaman

Pengguna akan melihat popup yang menginformasikan hasil perubahan Jenis Halaman.
7.  	Menghapus Jenis Halaman
a.      Memilih Jenis Halaman Untuk Dihapus

Dari halaman detail Jenis Halaman, pengguna dapat menekan tombol "DELETE" untuk menghapus Jenis Halaman.
b.      Konfirmasi Penghapusan
Sebelum menghapus, aplikasi akan menampilkan dialog konfirmasi.
Kode terkait:
Tombol Hapus
        OutlinedButton(
          child: const Text("DELETE"),
          onPressed: () => confirmHapus(),
        ),
      ],
    );
  }


  void confirmHapus() {
    AlertDialog alertDialog = AlertDialog(
      content: const Text("Yakin ingin menghapus data ini?"),
      actions: [
//tombol hapus
        OutlinedButton(
          child: const Text("Ya"),
          onPressed: () {
            // Logika penghapusan
            Navigator.pop(context); // Close the dialog after deletion
          },
        ),


//tombol batal
        OutlinedButton(
          child: const Text("Batal"),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
    showDialog(builder: (context) => alertDialog, context: context);
  }
}



c.      Proses Penghapusan
Jika pengguna mengkonfirmasi, aplikasi akan mengirim permintaan hapus ke API.
Kode terkait:
Tombol Hapus
        OutlinedButton(
          child: const Text("DELETE"),
          onPressed: () => confirmHapus(),
        ),
      ],
    );
  }


  void confirmHapus() {
    AlertDialog alertDialog = AlertDialog(
      content: const Text("Yakin ingin menghapus data ini?"),
      actions: [
//tombol hapus
        OutlinedButton(
          child: const Text("Ya"),
          onPressed: () {
            // Logika penghapusan
            Navigator.pop(context); // Close the dialog after deletion
          },
        ),


//tombol batal
        OutlinedButton(
          child: const Text("Batal"),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
    showDialog(builder: (context) => alertDialog, context: context);
  }
}

d.      Hasil Penghapusan
Pengguna akan melihat popup yang menginformasikan hasil penghapusan Jenis Halaman.
8.      Proses Logout
a.  	Memilih Menu Logout
Pengguna dapat mengakses menu logout dari drawer aplikasi.
Kode terkait:
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

b.  	Proses Logout
Ketika pengguna memilih logout, aplikasi akan menghapus token dan informasi pengguna dari penyimpanan lokal.
Kode terkait:
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

c.  	Kembali ke Halaman Login
Setelah proses logout selesai, pengguna akan diarahkan kembali ke halaman login.

