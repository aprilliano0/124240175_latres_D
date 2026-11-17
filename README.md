# Latihan Responsi Praktikum Pemrograman Mobile SI-D
**Nama Repositori**: `124240175_latres_D`  
**NIM**: `124240175`  
**Kelas**: SI-D

Aplikasi toko online berbasis Flutter (**Toko Seturan**) yang mengintegrasikan REST API eksternal (DummyJSON), manajemen state reaktif menggunakan GetX, penyimpanan sesi login menggunakan SharedPreferences, serta penyimpanan keranjang belanja lokal persisten per pengguna menggunakan database NoSQL Hive.

---

## 📋 Fitur Aplikasi & Pemenuhan Ketentuan Soal

1. **Autentikasi & Validasi NIM (Poin 4b)**
   - Form Login dengan input Username (bebas) dan Password (**wajib berupa NIM: `124240175`**).
   - Menyimpan sesi username dan status login ke SharedPreferences.

2. **Session Persistence (Poin 4c)**
   - Saat aplikasi ditutup dan dibuka kembali, pengguna yang belum logout langsung diarahkan ke halaman utama tanpa harus login ulang.

3. **Bottom Navigation Bar (Poin 4d)**
   - Halaman utama memiliki 2 menu navigasi: **Home** dan **Profile**.

4. **Halaman Home (Poin 4e)**
   - Menampilkan sapaan nama pengguna yang sedang aktif (`Hi, <username>`).
   - Tombol Cart di pojok kanan atas dengan badge indikator jumlah item yang otomatis mengarahkan ke halaman Cart.
   - Mengambil dan menampilkan data produk dari API Eksternal (`https://dummyjson.com/products`).
   - Fitur pencarian produk secara real-time dan pull-to-refresh.
   - Klik pada item produk akan mengarahkan pengguna ke halaman Detail Produk.

5. **Halaman Detail Produk (Poin 4f)**
   - Menampilkan informasi lengkap produk: galeri gambar, judul, brand, kategori, harga, rating, stok, deskripsi, dan tag produk.
   - Fitur pengatur kuantitas dengan validasi ketat: `0 < qty <= totalQty (stok produk)`.
   - Tombol **Add to Cart** yang menyimpan data produk, username pemilik, dan kuantitas ke database lokal Hive.

6. **Halaman Cart / Keranjang Belanja (Poin 4g)**
   - Menampilkan daftar produk keranjang khusus milik pengguna yang sedang login.
   - **Multi-user Cart Isolation**: Jika User A logout lalu User B login, data keranjang User B terpisah dan tidak tercampur dengan User A.
   - Di setiap item terdapat tombol untuk menghapus item dari keranjang atau mengatur ulang kuantitas.
   - Menampilkan kalkulasi total harga belanja secara reaktif dan tombol Checkout.

7. **Halaman Profile (Poin 4h)**
   - Menampilkan avatar dan nama pengguna yang sedang aktif.
   - Menampilkan kesan dan pesan praktikum.
   - Menampilkan status sesi login.
   - Tombol **Logout** dengan dialog konfirmasi yang membersihkan session login dan mengembalikan pengguna ke halaman Login.

---

## 🛠️ Library / Dependencies yang Digunakan (Poin 5)

| Library | Versi | Kegunaan |
| :--- | :--- | :--- |
| **`hive`** & **`hive_flutter`** | `^2.2.3` / `^1.1.0` | Local NoSQL database untuk menyimpan item keranjang belanja (Cart) per user secara persisten dan cepat. |
| **`shared_preferences`** | `^2.5.6` | Local storage untuk menyimpan session login (`username` dan status `isLoggedIn`). |
| **`http`** | `^1.6.0` | HTTP client untuk melakukan request ke REST API eksternal `https://dummyjson.com/products`. |
| **`get`** (GetX) | `^4.7.3` | State management reaktif, route management, dependency injection, dan dialog/snackbar helper. |
| **`cupertino_icons`** | `^1.0.8` | Paket ikon pelengkap iOS style. |

---

## 📁 Penjelasan Struktur Folder (Poin 3 - 10 Poin)

Proyek ini dibangun menggunakan arsitektur modular yang rapi (Clean MVC / Service-Repository pattern) agar mudah dipelihara dan dipahami:

```text
latres/
├── android/                   # Konfigurasi native Android (Gradle, Manifest, build files)
├── ios/                       # Konfigurasi native iOS (Runner, Info.plist)
├── web/, windows/, linux/     # Konfigurasi platform pendukung lainnya
├── assets/                    # (Opsional) Direktori untuk asset gambar atau font
├── test/
│   └── widget_test.dart       # Pengujian unit/widget Flutter
│
├── lib/                       # Seluruh source code aplikasi Flutter berada di sini
│   ├── constants/             # Berisi nilai konstanta global aplikasi
│   │   └── app_constants.dart # Konfigurasi nama app, endpoint API dummyjson, box Hive, dan default NIM
│   │
│   ├── models/                # Berisi model entitas data aplikasi
│   │   ├── product.dart       # Data model untuk mem-parsing response JSON produk dari DummyJSON
│   │   └── cart_item.dart     # Data model untuk item keranjang yang disimpan ke database Hive
│   │
│   ├── services/              # Layer layanan untuk interaksi dengan sistem eksternal & storage
│   │   ├── api_service.dart   # Mengurus HTTP GET request ke https://dummyjson.com/products
│   │   ├── session_service.dart # Mengurus sesi login (save, check, clear) via SharedPreferences
│   │   └── database_service.dart# Mengurus operasi CRUD Cart di database lokal Hive (per-user key)
│   │
│   ├── controllers/           # State management GetX Controllers
│   │   ├── auth_controller.dart      # Mengatur logika login, validasi NIM, session, dan logout
│   │   ├── product_controller.dart   # Mengatur state pengambilan data produk API, loading, dan filter pencarian
│   │   ├── cart_controller.dart      # Mengatur state isi keranjang user, tambah, hapus, update qty, dan total harga
│   │   └── navigation_controller.dart# Mengatur index tab navigasi BottomNavigationBar (Home & Profile)
│   │
│   ├── routes/                # Konfigurasi rute navigasi aplikasi
│   │   ├── app_routes.dart    # Daftar nama-nama route konstan ('/login', '/main', '/detail', '/cart')
│   │   └── app_pages.dart     # Pengaturan binding dependensi dan daftar GetPage routes
│   │
│   ├── views/                 # Layer antarmuka pengguna (UI Presentation)
│   │   ├── pages/             # Layar atau halaman utama aplikasi
│   │   │   ├── login_page.dart          # Halaman autentikasi login (username bebas & password NIM)
│   │   │   ├── main_navigation_page.dart# Container dengan BottomNavigationBar (Home & Profile)
│   │   │   ├── product_home_page.dart   # Halaman daftar produk API, sapaan username, dan tombol cart
│   │   │   ├── product_detail_page.dart # Halaman rincian produk, gambar, info, stepper qty, dan Add to Cart
│   │   │   ├── cart_page.dart           # Halaman daftar keranjang user aktif, hapus item, dan total belanja
│   │   │   └── profile_page.dart        # Halaman profil user login, kesan & pesan, dan tombol logout
│   │   └── widgets/           # Komponen widget UI yang dapat digunakan kembali (reusable)
│   │       ├── product_card.dart        # Card tampilan ringkas produk pada list Home
│   │       └── cart_item_tile.dart      # Card tampilan item belanja pada halaman Cart
│   │
│   └── main.dart              # Titik masuk utama aplikasi (entry point), inisialisasi Hive & routing
│
├── pubspec.yaml               # Deklarasi library/dependencies dan konfigurasi metadata project
└── README.md                  # Dokumentasi penjelasan proyek dan struktur folder
```

---

## 🚀 Panduan Menjalankan Aplikasi

1. **Clone repository:**
   ```bash
   git clone <URL_REPO_GITHUB>
   cd <NAMA_REPO>
   ```

2. **Install seluruh dependensi:**
   ```bash
   flutter pub get
   ```

3. **Jalankan aplikasi:**
   ```bash
   flutter run
   ```

---

## 🔑 Kredensial Login

- **Username**: Bebas diinputkan pengguna (Contoh: `aprilliano`, `yusuf`, dsb.)
- **Password**: **Wajib NIM: `124240175`**
- *Catatan: Nilai password NIM dikonfigurasi di file `lib/constants/app_constants.dart`.*
