# Software Requirements Specification (SRS) - TASKMAN

- **Penulis:** Jeremy Zadrimman Kause ([zekkey24@gmai.com](mailto:zekkey24@gmai.com))
- **Versi Dokumen:** 1.0
- **Tanggal:** 25 Agustus 2026
- **Status:** Draft
- **Referensi:** [PRD - TASKMAN](./PRD.md)

---

## 1. Pendahuluan

### 1.1. Tujuan Dokumen

Dokumen Software Requirements Specification (SRS) ini menjelaskan secara lengkap kebutuhan perangkat lunak untuk aplikasi **Taskman** — sebuah aplikasi mobile untuk manajemen tugas, jadwal, dan kebiasaan (habit). Dokumen ini menjadi acuan teknis bagi tim pengembang dalam proses desain, implementasi, pengujian, dan pemeliharaan sistem.

### 1.2. Lingkup Sistem

Aplikasi Taskman adalah aplikasi mobile cross-platform (Android & iOS) yang dibangun menggunakan **Flutter (Dart)**. Aplikasi ini memungkinkan pengguna untuk:

- Mencatat dan mengelola tugas harian serta mingguan.
- Menentukan prioritas tugas (Tinggi, Sedang, Rendah).
- Melihat jadwal dan event melalui tampilan kalender.
- Membangun kebiasaan positif dengan fitur habit tracking dan streak.
- Menerima pengingat (reminder) melalui notifikasi lokal.
- Melihat statistik produktivitas pada halaman profil.

### 1.3. Definisi, Akronim, dan Singkatan

| Istilah | Definisi |
|---|---|
| **SRS** | Software Requirements Specification |
| **PRD** | Product Requirements Document |
| **MVP** | Minimum Viable Product |
| **CRUD** | Create, Read, Update, Delete |
| **DAU** | Daily Active Users |
| **UI** | User Interface |
| **UX** | User Experience |
| **ERD** | Entity Relationship Diagram |
| **Task** | Satuan pekerjaan/tugas yang dicatat oleh pengguna |
| **Event** | Kegiatan terjadwal (kuliah, meeting, dll.) |
| **Habit** | Kebiasaan yang ingin dibangun secara konsisten |
| **Streak** | Jumlah hari berturut-turut pengguna melakukan check-in habit |
| **SQLite** | Database relasional ringan yang berjalan secara lokal di perangkat |

### 1.4. Referensi

- PRD Taskman v1.0 — [docs/PRD.md](./PRD.md)
- IEEE 830-1998: Recommended Practice for SRS
- Flutter Documentation — [flutter.dev](https://flutter.dev)

### 1.5. Gambaran Umum Dokumen

| Bagian | Isi |
|---|---|
| Bab 1 | Pendahuluan, tujuan, dan lingkup |
| Bab 2 | Deskripsi umum produk dan pengguna |
| Bab 3 | Kebutuhan fungsional (detail per modul) |
| Bab 4 | Kebutuhan antarmuka eksternal (UI, hardware, software) |
| Bab 5 | Kebutuhan non-fungsional |
| Bab 6 | Kebutuhan data dan ERD |
| Bab 7 | Arsitektur sistem dan diagram |

---

## 2. Deskripsi Umum

### 2.1. Perspektif Produk

Taskman adalah aplikasi **standalone** yang berjalan secara lokal di perangkat mobile pengguna. Aplikasi ini tidak bergantung pada server backend atau koneksi internet untuk fungsi utamanya. Semua data tersimpan di database lokal (SQLite) pada perangkat pengguna.

```
┌─────────────────────────────────────────────┐
│              Perangkat Mobile                │
│                                             │
│   ┌───────────────────────────────────┐     │
│   │         Aplikasi Taskman          │     │
│   │                                   │     │
│   │  ┌─────────┐  ┌──────────────┐   │     │
│   │  │   UI    │  │ Business     │   │     │
│   │  │  Layer  │──│ Logic Layer  │   │     │
│   │  └─────────┘  └──────┬───────┘   │     │
│   │                      │           │     │
│   │              ┌───────▼───────┐   │     │
│   │              │  Data Access  │   │     │
│   │              │  Layer (DAO)  │   │     │
│   │              └───────┬───────┘   │     │
│   └──────────────────────┼───────────┘     │
│                  ┌───────▼───────┐          │
│                  │    SQLite     │          │
│                  │   Database   │          │
│                  └───────────────┘          │
│                                             │
│   ┌───────────────────────────────────┐     │
│   │   OS Notification Service         │     │
│   │   (Android / iOS)                 │     │
│   └───────────────────────────────────┘     │
└─────────────────────────────────────────────┘
```

### 2.2. Fungsi Utama Produk

| No | Modul | Fungsi |
|---|---|---|
| 1 | Manajemen Tugas | CRUD tugas dengan prioritas, jenis (harian/mingguan), dan deadline |
| 2 | Kalender & Event | Tampilan kalender bulanan, CRUD event pada tanggal tertentu |
| 3 | Habit Tracker | CRUD kebiasaan, check-in harian, perhitungan streak |
| 4 | Reminder | Notifikasi lokal untuk deadline tugas dan pengingat habit |
| 5 | Profil & Statistik | Ringkasan produktivitas pengguna |

### 2.3. Karakteristik Pengguna

| Karakteristik | Deskripsi |
|---|---|
| **Tipe Pengguna** | Mahasiswa, pekerja, dan freelancer |
| **Usia** | 17–40 tahun |
| **Kemampuan Teknis** | Pengguna umum smartphone (tidak memerlukan keahlian teknis) |
| **Frekuensi Penggunaan** | Harian (minimal 1–3 kali per hari) |
| **Bahasa** | Indonesia |

### 2.4. Batasan Sistem

- Aplikasi hanya berjalan di platform **Android 8.0+** dan **iOS 13+**.
- Data disimpan secara **lokal** — tidak ada sinkronisasi cloud pada versi MVP.
- Aplikasi memerlukan izin notifikasi dari OS untuk fitur reminder.
- Tidak ada fitur autentikasi pengguna (login/register) pada versi MVP.
- Ukuran instalasi aplikasi tidak boleh melebihi **50 MB**.

### 2.5. Asumsi dan Ketergantungan

- Pengguna menggunakan perangkat dengan sistem operasi yang didukung.
- Pengguna memberikan izin notifikasi saat pertama kali menggunakan aplikasi.
- Framework Flutter dan plugin yang digunakan mendukung fitur yang dibutuhkan.
- Kapasitas penyimpanan lokal perangkat cukup untuk menyimpan data aplikasi.

---

## 3. Kebutuhan Fungsional

### 3.1. Modul Manajemen Tugas (Task)

#### FR-01: Membuat Tugas Baru

| Atribut | Detail |
|---|---|
| **ID** | FR-01 |
| **Deskripsi** | Sistem harus memungkinkan pengguna membuat tugas baru |
| **Input** | Judul (wajib), Deskripsi (opsional), Deadline (wajib), Prioritas (wajib, default: Sedang), Jenis (wajib: Harian/Mingguan) |
| **Proses** | Validasi input → Simpan ke database lokal → Jadwalkan notifikasi jika deadline diisi |
| **Output** | Tugas baru muncul di daftar tugas pada Task Page |
| **Pre-condition** | Pengguna berada di Task Page |
| **Post-condition** | Data tugas tersimpan di tabel `tasks` |

#### FR-02: Menampilkan Daftar Tugas

| Atribut | Detail |
|---|---|
| **ID** | FR-02 |
| **Deskripsi** | Sistem harus menampilkan daftar tugas dengan filter |
| **Filter** | Semua, Hari Ini, Minggu Ini, Selesai |
| **Urutan Default** | Prioritas (Tinggi → Sedang → Rendah), lalu deadline terdekat |
| **Output** | Daftar tugas dengan informasi: judul, prioritas (badge warna), deadline, dan status selesai |

#### FR-03: Mengedit Tugas

| Atribut | Detail |
|---|---|
| **ID** | FR-03 |
| **Deskripsi** | Sistem harus memungkinkan pengguna mengedit tugas yang sudah ada |
| **Field yang Dapat Diedit** | Judul, Deskripsi, Deadline, Prioritas, Jenis |
| **Pre-condition** | Tugas sudah ada di database |
| **Post-condition** | Data tugas diperbarui; notifikasi dijadwalkan ulang jika deadline berubah |

#### FR-04: Menghapus Tugas

| Atribut | Detail |
|---|---|
| **ID** | FR-04 |
| **Deskripsi** | Sistem harus memungkinkan pengguna menghapus tugas |
| **Proses** | Konfirmasi penghapusan → Hapus dari database → Batalkan notifikasi terkait |
| **Pre-condition** | Tugas sudah ada di database |
| **Post-condition** | Data tugas dihapus dari tabel `tasks` |

#### FR-05: Menandai Tugas Selesai/Belum Selesai

| Atribut | Detail |
|---|---|
| **ID** | FR-05 |
| **Deskripsi** | Sistem harus memungkinkan pengguna menandai tugas sebagai selesai atau belum selesai |
| **Proses** | Toggle status `is_completed` → Update tampilan (strikethrough/visual feedback) |
| **Post-condition** | Field `is_completed` dan `completed_at` diperbarui di database |

#### FR-06: Mengurutkan Tugas

| Atribut | Detail |
|---|---|
| **ID** | FR-06 |
| **Deskripsi** | Sistem harus mengurutkan tugas berdasarkan prioritas dan deadline |
| **Aturan Urutan** | 1) Prioritas: Tinggi (3) > Sedang (2) > Rendah (1); 2) Deadline terdekat lebih dulu; 3) Tugas selesai ditampilkan di bagian bawah |

---

### 3.2. Modul Kalender & Event

#### FR-07: Menampilkan Kalender Bulanan

| Atribut | Detail |
|---|---|
| **ID** | FR-07 |
| **Deskripsi** | Sistem harus menampilkan kalender dalam tampilan bulanan |
| **Output** | Grid kalender dengan indikator titik/dot pada tanggal yang memiliki tugas atau event |
| **Interaksi** | Pengguna dapat mengetuk tanggal untuk melihat detail tugas dan event pada tanggal tersebut |

#### FR-08: Menampilkan Detail Tanggal

| Atribut | Detail |
|---|---|
| **ID** | FR-08 |
| **Deskripsi** | Sistem harus menampilkan daftar tugas dan event ketika tanggal pada kalender dipilih |
| **Output** | List tugas (berdasarkan deadline) dan event (berdasarkan waktu) pada tanggal yang dipilih |

#### FR-09: CRUD Event

| Atribut | Detail |
|---|---|
| **ID** | FR-09 |
| **Deskripsi** | Sistem harus memungkinkan pengguna membuat, melihat, mengedit, dan menghapus event |
| **Input** | Judul (wajib), Deskripsi (opsional), Tanggal (wajib), Waktu mulai (opsional), Waktu selesai (opsional), Lokasi (opsional) |
| **Post-condition** | Data event tersimpan/diperbarui/dihapus di tabel `events` |

---

### 3.3. Modul Habit Tracker

#### FR-10: Membuat Kebiasaan Baru

| Atribut | Detail |
|---|---|
| **ID** | FR-10 |
| **Deskripsi** | Sistem harus memungkinkan pengguna membuat kebiasaan baru yang ingin dibangun |
| **Input** | Nama kebiasaan (wajib), Frekuensi target per minggu (opsional, default: 7), Waktu pengingat (opsional) |
| **Post-condition** | Data habit tersimpan di tabel `habits` |

#### FR-11: Check-in Harian

| Atribut | Detail |
|---|---|
| **ID** | FR-11 |
| **Deskripsi** | Sistem harus memungkinkan pengguna melakukan check-in harian untuk setiap kebiasaan |
| **Aturan** | Satu check-in per hari per kebiasaan; check-in hanya valid untuk hari ini |
| **Post-condition** | Record baru di tabel `habit_logs` dengan tanggal hari ini |

#### FR-12: Menampilkan Streak

| Atribut | Detail |
|---|---|
| **ID** | FR-12 |
| **Deskripsi** | Sistem harus menghitung dan menampilkan streak untuk setiap kebiasaan |
| **Aturan Streak** | Streak bertambah +1 jika pengguna check-in pada hari berturut-turut. Streak di-reset ke 0 jika pengguna melewatkan satu hari penuh tanpa check-in. |
| **Output** | Angka streak dan indikator visual (misal: ikon api/🔥) |

---

### 3.4. Modul Reminder / Notifikasi

#### FR-13: Pengingat Deadline Tugas

| Atribut | Detail |
|---|---|
| **ID** | FR-13 |
| **Deskripsi** | Sistem harus mengirimkan notifikasi lokal sebelum deadline tugas |
| **Waktu Pengingat** | 1 jam sebelum deadline (default) |
| **Pre-condition** | Izin notifikasi diberikan oleh pengguna |
| **Teknologi** | `flutter_local_notifications` + `timezone` |

#### FR-14: Pengingat Check-in Habit

| Atribut | Detail |
|---|---|
| **ID** | FR-14 |
| **Deskripsi** | Sistem harus mengirimkan notifikasi pengingat untuk check-in kebiasaan harian |
| **Waktu Pengingat** | Sesuai waktu yang diatur pengguna saat membuat habit, atau default pukul 08:00 |
| **Pre-condition** | Izin notifikasi diberikan oleh pengguna; habit memiliki pengingat aktif |

---

### 3.5. Modul Profil & Statistik

#### FR-15: Menampilkan Statistik Pengguna

| Atribut | Detail |
|---|---|
| **ID** | FR-15 |
| **Deskripsi** | Sistem harus menampilkan ringkasan statistik produktivitas pengguna |
| **Data yang Ditampilkan** | Total tugas selesai, Total tugas aktif, Streak habit terpanjang, Streak habit aktif saat ini, Persentase tugas selesai bulan ini |

---

## 4. Kebutuhan Antarmuka Eksternal

### 4.1. Antarmuka Pengguna (User Interface)

#### 4.1.1. Struktur Navigasi

Aplikasi menggunakan **Bottom Navigation Bar** dengan 4 tab utama:

```
┌─────────────────────────────────────────────────────┐
│                      App Bar                        │
│                   (Judul Halaman)                   │
├─────────────────────────────────────────────────────┤
│                                                     │
│                                                     │
│                  Konten Halaman                     │
│                (Body / SafeArea)                    │
│                                                     │
│                                                     │
├─────────────────────────────────────────────────────┤
│  ✅ Task   │  🔁 Habit   │  📅 Kalender  │  👤 Profil │
└─────────────────────────────────────────────────────┘
```

#### 4.1.2. Deskripsi Layar

**A. Task Page**

| Komponen | Deskripsi |
|---|---|
| Header | Judul halaman dan tanggal hari ini |
| Filter Tab | Tab: *Hari Ini* · *Minggu Ini* · *Prioritas* · *Selesai* |
| Task List | Daftar tugas dengan checkbox, badge prioritas (warna), dan label deadline |
| FAB (Floating Action Button) | Tombol `+` untuk menambah tugas baru |

**B. Habit Page**

| Komponen | Deskripsi |
|---|---|
| Header | Judul halaman |
| Habit List | Daftar kebiasaan dengan tombol check-in, streak indicator, dan progress |
| FAB | Tombol `+` untuk menambah kebiasaan baru |

**C. Kalender / Event Page**

| Komponen | Deskripsi |
|---|---|
| Calendar Widget | Tampilan kalender bulanan dengan dot indicator pada tanggal yang memiliki tugas/event |
| Detail Section | Daftar tugas dan event pada tanggal yang dipilih (di bawah kalender) |
| FAB | Tombol `+` untuk menambah event baru |

**D. Profile Page**

| Komponen | Deskripsi |
|---|---|
| User Info | Nama pengguna dan informasi singkat |
| Stats Card | Kartu statistik: tugas selesai, streak terpanjang, persentase penyelesaian |
| Habit Overview | Ringkasan semua habit beserta streak masing-masing |
| Settings | Pengaturan notifikasi |

**D. Form Dialog (Modal Bottom Sheet)**

| Komponen | Deskripsi |
|---|---|
| Add/Edit Task | Form: Judul, Deskripsi, Deadline (date picker), Prioritas (dropdown), Jenis (toggle harian/mingguan) |
| Add/Edit Event | Form: Judul, Deskripsi, Tanggal, Waktu mulai, Waktu selesai, Lokasi |
| Add/Edit Habit | Form: Nama kebiasaan, Frekuensi, Waktu pengingat (time picker) |

#### 4.1.3. Warna Badge Prioritas

| Prioritas | Warna | Kode Nilai |
|---|---|---|
| Tinggi | 🔴 Merah | 3 |
| Sedang | 🟡 Kuning/Oranye | 2 |
| Rendah | 🔵 Biru/Hijau | 1 |

### 4.2. Antarmuka Perangkat Keras (Hardware Interface)

| Komponen | Kebutuhan |
|---|---|
| **Layar Sentuh** | Untuk seluruh interaksi pengguna (tap, scroll, swipe) |
| **Penyimpanan Internal** | Untuk menyimpan database SQLite lokal |
| **Sistem Notifikasi** | Menggunakan layanan notifikasi bawaan OS (Android Notification Channel / iOS UNNotification) |

### 4.3. Antarmuka Perangkat Lunak (Software Interface)

| Komponen | Teknologi | Fungsi |
|---|---|---|
| **Framework** | Flutter 3.x (Dart) | Framework utama pengembangan UI cross-platform |
| **Database Lokal** | SQLite via `sqflite` | Penyimpanan data tugas, event, habit, dan log |
| **Notifikasi Lokal** | `flutter_local_notifications` | Penjadwalan dan pengiriman notifikasi |
| **Kalender UI** | `table_calendar` | Widget kalender bulanan interaktif |
| **State Management** | `provider` atau `flutter_bloc` | Manajemen state aplikasi |
| **Format Tanggal** | `intl` | Format dan parsing tanggal/waktu |
| **Path Helper** | `path` + `path_provider` | Mengakses direktori penyimpanan lokal |

### 4.4. Antarmuka Komunikasi

Pada versi MVP, aplikasi **tidak memiliki antarmuka komunikasi jaringan**. Seluruh operasi data dilakukan secara lokal tanpa koneksi internet.

---

## 5. Kebutuhan Non-Fungsional

### 5.1. Performa

| ID | Requirement |
|---|---|
| **NFR-01** | Waktu muat halaman (page load) tidak boleh lebih dari **2 detik**. |
| **NFR-02** | Operasi CRUD (simpan, edit, hapus) harus selesai dalam waktu **< 500 ms**. |
| **NFR-03** | Transisi antar halaman (navigasi) harus berjalan pada **60 fps** tanpa jank. |

### 5.2. Ketersediaan & Reliabilitas

| ID | Requirement |
|---|---|
| **NFR-04** | Aplikasi harus dapat digunakan sepenuhnya **secara offline** tanpa koneksi internet. |
| **NFR-05** | Crash rate aplikasi harus di bawah **1%** dari total sesi pengguna. |
| **NFR-06** | Data tidak boleh hilang saat aplikasi ditutup secara paksa (force close). |

### 5.3. Keamanan

| ID | Requirement |
|---|---|
| **NFR-07** | Data pengguna disimpan di database lokal (SQLite) yang hanya dapat diakses oleh aplikasi Taskman. |
| **NFR-08** | Aplikasi tidak mengirimkan data pengguna ke server eksternal manapun. |

### 5.4. Usability

| ID | Requirement |
|---|---|
| **NFR-09** | Aksi utama (membuat tugas, check-in habit) harus dapat dicapai dalam **maksimal 3 tap**. |
| **NFR-10** | Antarmuka menggunakan bahasa Indonesia yang konsisten. |
| **NFR-11** | Elemen interaktif harus memiliki ukuran minimum **48x48 dp** sesuai Material Design guidelines. |

### 5.5. Kompatibilitas

| ID | Requirement |
|---|---|
| **NFR-12** | Mendukung perangkat Android dengan API level ≥ 26 (Android 8.0 Oreo). |
| **NFR-13** | Mendukung perangkat iOS dengan versi ≥ 13.0. |
| **NFR-14** | Mendukung resolusi layar dari 320dp (small phone) hingga 428dp (large phone). |

### 5.6. Ukuran & Instalasi

| ID | Requirement |
|---|---|
| **NFR-15** | Ukuran file APK/IPA tidak melebihi **50 MB**. |
| **NFR-16** | Ukuran database lokal tidak melebihi **100 MB** dalam penggunaan normal (< 10.000 record). |

---

## 6. Kebutuhan Data (ERD)

### 6.1. Entity Relationship Diagram

```
┌──────────────────┐
│    categories    │
├──────────────────┤
│ PK id            │
│    name          │
│    color_hex     │
│    created_at    │
│    updated_at    │
└──────┬───────────┘
       │
       ├──────────────────── 1:N ────────────────────┐
       │                                             │
       │ 1:N                              1:N        │
       ▼                                             ▼
┌──────────────────┐       ┌──────────────────┐    ┌──────────────────┐
│      tasks       │       │ schedule_events  │    │      habits      │
├──────────────────┤       ├──────────────────┤    ├──────────────────┤
│ PK id            │       │ PK id            │    │ PK id            │
│ FK category_id   │       │ FK category_id   │    │ FK category_id   │
│    title         │       │    title         │    │    name          │
│    description   │       │    description   │    │    frequency     │
│    type          │       │    start_time    │    │    target_count  │
│    priority      │       │    end_time      │    │    reminder_time │
│    deadline      │       │    is_recurring  │    │    is_active     │
│    is_completed  │       │    recurrence    │    │    created_at    │
│    completed_at  │       │    _rule         │    │    updated_at    │
│    created_at    │       │    location      │    └────────┬─────────┘
│    updated_at    │       │    type          │             │
└──────────────────┘       │    created_at    │             │ 1:N
                           │    updated_at    │             │
                           └──────────────────┘             ▼
                                                  ┌──────────────────┐
                                                  │   habit_logs     │
                                                  ├──────────────────┤
                                                  │ PK id            │
                                                  │ FK habit_id      │
                                                  │    check_in_date │
                                                  │    is_done       │
                                                  │    created_at    │
                                                  └──────────────────┘
```

**Relasi antar tabel:**

| Relasi | Tipe | Keterangan |
|---|---|---|
| `categories` → `tasks` | 1:N | Satu kategori memiliki banyak tugas |
| `categories` → `schedule_events` | 1:N | Satu kategori memiliki banyak event |
| `categories` → `habits` | 1:N | Satu kategori memiliki banyak kebiasaan |
| `habits` → `habit_logs` | 1:N | Satu kebiasaan memiliki banyak log check-in |

### 6.2. Deskripsi Tabel

#### Tabel `categories` *(BARU)*

Tabel ini menyimpan kategori untuk mengelompokkan tugas, event, dan kebiasaan. Setiap kategori memiliki warna unik yang digunakan sebagai badge dan dot indicator pada kalender.

| Field | Tipe Data | Constraint | Keterangan |
|---|---|---|---|
| `id` | INTEGER | PRIMARY KEY, AUTOINCREMENT | ID unik kategori |
| `name` | TEXT | NOT NULL, UNIQUE | Nama kategori (misal: "Kuliah", "Pribadi", "Kerja") |
| `color_hex` | TEXT | NOT NULL | Kode warna hex (misal: "#0EA5E9") untuk badge & kalender |
| `created_at` | TEXT (ISO 8601) | NOT NULL | Waktu pembuatan |
| `updated_at` | TEXT (ISO 8601) | NOT NULL | Waktu pembaruan terakhir |

**Contoh data default:**

| name | color_hex | Keterangan |
|---|---|---|
| Kuliah | #0EA5E9 | Biru langit |
| Pribadi | #8B5CF6 | Ungu |
| Kerja | #F59E0B | Oranye |
| Kesehatan | #10B981 | Hijau |

#### Tabel `tasks`

| Field | Tipe Data | Constraint | Keterangan |
|---|---|---|---|
| `id` | INTEGER | PRIMARY KEY, AUTOINCREMENT | ID unik tugas |
| `category_id` | INTEGER | FOREIGN KEY → categories(id), NULLABLE | Referensi ke tabel categories |
| `title` | TEXT | NOT NULL | Judul tugas |
| `description` | TEXT | NULLABLE | Deskripsi / catatan tambahan tugas |
| `type` | TEXT | NOT NULL, CHECK ('daily', 'weekly') | Jenis tugas: harian atau mingguan |
| `priority` | INTEGER | NOT NULL, DEFAULT 2 | 1 = Rendah, 2 = Sedang, 3 = Tinggi |
| `deadline` | TEXT (ISO 8601) | NOT NULL | Tanggal dan waktu deadline |
| `is_completed` | INTEGER | NOT NULL, DEFAULT 0 | 0 = Belum selesai, 1 = Selesai |
| `completed_at` | TEXT (ISO 8601) | NULLABLE | Waktu penyelesaian tugas |
| `created_at` | TEXT (ISO 8601) | NOT NULL | Waktu pembuatan |
| `updated_at` | TEXT (ISO 8601) | NOT NULL | Waktu pembaruan terakhir |

#### Tabel `schedule_events` *(Sebelumnya: `events`)*

Tabel ini di-*rename* dari `events` menjadi `schedule_events` agar lebih deskriptif dan menghindari konflik penamaan. Tabel ini juga ditambah dukungan untuk event berulang (*recurring*).

| Field | Tipe Data | Constraint | Keterangan |
|---|---|---|---|
| `id` | INTEGER | PRIMARY KEY, AUTOINCREMENT | ID unik event |
| `category_id` | INTEGER | FOREIGN KEY → categories(id), NULLABLE | Referensi ke tabel categories |
| `title` | TEXT | NOT NULL | Judul event |
| `description` | TEXT | NULLABLE | Deskripsi event |
| `start_time` | TEXT (ISO 8601) | NOT NULL | Waktu mulai (tanggal + jam digabung) |
| `end_time` | TEXT (ISO 8601) | NULLABLE | Waktu selesai (tanggal + jam digabung) |
| `is_recurring` | INTEGER | NOT NULL, DEFAULT 0 | 0 = Sekali, 1 = Berulang |
| `recurrence_rule` | TEXT | NULLABLE | Aturan pengulangan format iCalendar RRULE (misal: "FREQ=WEEKLY;BYDAY=MO,WE") |
| `location` | TEXT | NULLABLE | Lokasi event |
| `type` | TEXT | NULLABLE | Jenis event (misal: "kuliah", "meeting", "pribadi") |
| `created_at` | TEXT (ISO 8601) | NOT NULL | Waktu pembuatan |
| `updated_at` | TEXT (ISO 8601) | NOT NULL | Waktu pembaruan terakhir |

> **Catatan:** Field `event_date`, `start_time` (HH:mm), dan `end_time` (HH:mm) pada desain lama digabung menjadi `start_time` dan `end_time` bertipe DATETIME penuh (ISO 8601). Ini menghindari parsing manual antara tanggal dan jam yang terpisah.

#### Tabel `habits`

| Field | Tipe Data | Constraint | Keterangan |
|---|---|---|---|
| `id` | INTEGER | PRIMARY KEY, AUTOINCREMENT | ID unik kebiasaan |
| `category_id` | INTEGER | FOREIGN KEY → categories(id), NULLABLE | Referensi ke tabel categories |
| `name` | TEXT | NOT NULL | Nama kebiasaan |
| `frequency` | TEXT | NOT NULL, DEFAULT 'daily' | Frekuensi: "daily", "weekly" |
| `target_count` | INTEGER | NOT NULL, DEFAULT 1 | Target berapa kali per frekuensi |
| `reminder_time` | TEXT | NULLABLE | Waktu pengingat (HH:mm) |
| `is_active` | INTEGER | NOT NULL, DEFAULT 1 | 0 = Nonaktif, 1 = Aktif |
| `created_at` | TEXT (ISO 8601) | NOT NULL | Waktu pembuatan |
| `updated_at` | TEXT (ISO 8601) | NOT NULL | Waktu pembaruan terakhir |

#### Tabel `habit_logs`

| Field | Tipe Data | Constraint | Keterangan |
|---|---|---|---|
| `id` | INTEGER | PRIMARY KEY, AUTOINCREMENT | ID unik log |
| `habit_id` | INTEGER | FOREIGN KEY → habits(id), NOT NULL, ON DELETE CASCADE | Referensi ke tabel habits |
| `check_in_date` | TEXT (ISO 8601) | NOT NULL | Tanggal check-in |
| `is_done` | INTEGER | NOT NULL, DEFAULT 1 | 0 = Batal, 1 = Selesai |
| `created_at` | TEXT (ISO 8601) | NOT NULL | Waktu pembuatan |

> **Constraint Unik:** Kombinasi `habit_id` + `check_in_date` harus unik (satu check-in per hari per habit).

### 6.3. Perubahan dari Desain Sebelumnya

Berikut ringkasan perubahan ERD dari versi 1.0:

| Perubahan | Alasan |
|---|---|
| **Tabel `categories` ditambahkan** | Pengelompokan tugas/event/habit dengan warna untuk badge & kalender dot indicator |
| **`events` di-rename menjadi `schedule_events`** | Nama lebih deskriptif, menghindari konflik penamaan |
| **`category_id` (FK) ditambahkan** pada tasks, schedule_events, habits | Relasi ke tabel categories |
| **`start_time` & `end_time` menjadi DATETIME penuh** pada schedule_events | Menghindari parsing manual antara tanggal dan jam terpisah |
| **`is_recurring` & `recurrence_rule` ditambahkan** pada schedule_events | Dukungan event berulang (kuliah mingguan, meeting rutin) |
| **`type` ditambahkan** pada schedule_events | Membedakan jenis event (kuliah, meeting, pribadi) |
| **`target_count` ditambahkan** pada habits | Target berapa kali per frekuensi (misal: olahraga 3x per minggu) |
| **`frequency` diubah ke TEXT** pada habits | Lebih fleksibel: "daily", "weekly" vs angka |
| **`status` (INTEGER) diganti `is_done` (INTEGER)** pada habit_logs | Semantik lebih jelas: bool selesai/belum |

---

## 7. Arsitektur Sistem

### 7.1. Arsitektur Aplikasi (Layered Architecture)

Aplikasi Taskman menggunakan arsitektur berlapis yang memisahkan antara tampilan (UI), logika bisnis, dan akses data:

```
┌─────────────────────────────────────────────────┐
│                 Presentation Layer               │
│     (Pages, Components, Widgets)                 │
│     lib/presentations/  ·  lib/components/       │
├─────────────────────────────────────────────────┤
│                 Business Logic Layer             │
│     (State Management / Providers)               │
│     lib/controllers/                             │
├─────────────────────────────────────────────────┤
│                 Data Access Layer (DAO)           │
│     (Database Operations, CRUD)                  │
│     lib/dao/                                     │
├─────────────────────────────────────────────────┤
│                 Data Layer                        │
│     (Models, Database Helper, Utils)             │
│     lib/models/  ·  lib/database/  ·  lib/utils/ │
├─────────────────────────────────────────────────┤
│                 SQLite Database                   │
└─────────────────────────────────────────────────┘
```

### 7.2. Struktur Direktori Proyek

```
lib/
├── main.dart              # Entry point aplikasi
├── components/            # Widget reusable (TaskCard, HabitCard, dll.)
├── controllers/           # State management / Providers
│   ├── taskProvider.dart
│   ├── eventProvider.dart
│   └── habbitProvider.dart
├── dao/                   # Data Access Objects (CRUD operations)
│   ├── TaskDAO.dart
│   ├── EventDAO.dart
│   ├── HabitDAO.dart
│   └── HabitLogDAO.dart
├── database/              # Database helper (inisialisasi SQLite)
│   ├── sqlite/
│   │   ├── sqliteHelper.dart
│   │   └── tabels/        # Definisi CREATE TABLE
│   └── supabase/          # (Dipersiapkan untuk cloud sync)
├── models/                # Data model (Task, Event, Habit, HabitLog)
│   ├── Task.dart
│   ├── Event.dart
│   ├── Habit.dart
│   └── habit_log.dart
├── presentations/         # Halaman utama (UI Screens)
│   ├── mainNavPres.dart   # Wrapper navigasi (BottomNav, 4 tab)
│   ├── taskPres.dart      # Tab 1: Manajemen tugas
│   ├── habitPres.dart     # Tab 2: Habit tracker
│   ├── eventPres.dart     # Tab 3: Kalender & event
│   └── profilePres.dart   # Tab 4: Profil & statistik
└── utils/                 # Utility functions
    ├── app_theme.dart     # Definisi tema & warna
    └── date_helper.dart   # Formatter tanggal Indonesia
```

### 7.3. Class Diagram

```
════════════════════════════════════════════════════════════════════════
                           DATA MODELS
════════════════════════════════════════════════════════════════════════

┌───────────────────────┐
│       Category        │
├───────────────────────┤
│ - id: int?            │
│ - name: String        │
│ - colorHex: String    │
│ - createdAt: DateTime?│
│ - updatedAt: DateTime │
├───────────────────────┤
│ + toMap(): Map        │
│ + fromMap(Map)        │
└───────────┬───────────┘
            │
    ┌───────┼──────────────────────────┐
    │ 1:N   │ 1:N                      │ 1:N
    ▼       ▼                          ▼
┌───────────────────────┐  ┌───────────────────────┐  ┌───────────────────────┐
│        Task           │  │    ScheduleEvent      │  │        Habit          │
├───────────────────────┤  ├───────────────────────┤  ├───────────────────────┤
│ - id: int?            │  │ - id: int?            │  │ - id: int?            │
│ - categoryId: int?    │  │ - categoryId: int?    │  │ - categoryId: int?    │
│ - title: String       │  │ - title: String       │  │ - name: String        │
│ - description: String?│  │ - description: String?│  │ - frequency: String   │
│ - type: String        │  │ - startTime: DateTime │  │ - targetCount: int    │
│ - priority: int       │  │ - endTime: DateTime?  │  │ - reminderTime: String│
│ - deadline: DateTime  │  │ - isRecurring: bool   │  │ - isActive: bool      │
│ - isCompleted: bool   │  │ - recurrenceRule: Str?│  │ - createdAt: DateTime?│
│ - completedAt: DTime? │  │ - location: String?   │  │ - updatedAt: DateTime │
│ - createdAt: DateTime?│  │ - type: String?       │  ├───────────────────────┤
│ - updatedAt: DateTime │  │ - createdAt: DateTime?│  │ + toMap(): Map        │
├───────────────────────┤  │ - updatedAt: DateTime │  │ + fromMap(Map)        │
│ + toMap(): Map        │  ├───────────────────────┤  │ + logToday()          │
│ + fromMap(Map)        │  │ + toMap(): Map        │  └───────────┬───────────┘
└───────────────────────┘  │ + fromMap(Map)        │              │
                           └───────────────────────┘              │ 1:N
                                                                  ▼
                                                      ┌───────────────────────┐
                                                      │      HabitLog         │
                                                      ├───────────────────────┤
                                                      │ - id: int?            │
                                                      │ - habitId: int        │
                                                      │ - checkInDate: DTime  │
                                                      │ - isDone: bool        │
                                                      │ - createdAt: DateTime?│
                                                      ├───────────────────────┤
                                                      │ + toMap(): Map        │
                                                      │ + fromMap(Map)        │
                                                      └───────────────────────┘

════════════════════════════════════════════════════════════════════════
                       DATA ACCESS (DAO)
════════════════════════════════════════════════════════════════════════

┌─────────────────────────┐  ┌─────────────────────────┐
│        TaskDAO          │  │      ScheduleEventDAO   │
├─────────────────────────┤  ├─────────────────────────┤
│ + insert(Task): int     │  │ + insert(Event): int    │
│ + getById(int): Task?   │  │ + getById(int): Event?  │
│ + getAll(): List<Task>  │  │ + getAll(): List<Event> │
│ + update(Task): int     │  │ + update(Event): int    │
│ + delete(int): int      │  │ + delete(int): int      │
│ + getThisDay(): List    │  │ + getByDate(DateTime)   │
│ + getThisWeek(): List   │  │ + getByDateRange(...)   │
│ + getThisMonth(): List  │  │ + getRecurring(): List  │
│ + getPending(): List    │  └─────────────────────────┘
│ + getCompleted(): List  │
│ + getOverdue(): List    │  ┌─────────────────────────┐
└─────────────────────────┘  │      CategoryDAO        │
                             ├─────────────────────────┤
┌─────────────────────────┐  │ + insert(Category): int │
│       HabitDAO          │  │ + getAll(): List<Cat>   │
├─────────────────────────┤  │ + update(Category): int │
│ + insert(Habit): int    │  │ + delete(int): int      │
│ + getAll(): List<Habit> │  └─────────────────────────┘
│ + getActive(): List     │
│ + update(Habit): int    │  ┌─────────────────────────┐
│ + delete(int): int      │  │     HabitLogDAO         │
└─────────────────────────┘  ├─────────────────────────┤
                             │ + insert(HabitLog): int  │
                             │ + getByHabitId(int): List│
                             │ + getStreak(int): int    │
                             │ + checkInToday(int)      │
                             │ + isCheckedIn(int, Date) │
                             └─────────────────────────┘

┌────────────────────────────┐
│      SqliteHelper          │
├────────────────────────────┤
│ - _database: Database?     │
│ - instance: SqliteHelper   │
├────────────────────────────┤
│ + database: Future<DB>     │
│ - _initDatabase(): DB      │
│ - _onCreate(DB, int)       │
│ + close()                  │
│ + getDatabasePath(): String│
└────────────────────────────┘

════════════════════════════════════════════════════════════════════════
                   CONTROLLERS (PROVIDERS)
════════════════════════════════════════════════════════════════════════

┌──────────────────────────┐  ┌──────────────────────────┐
│      TaskProvider        │  │     EventProvider        │
│  (extends ChangeNotifier)│  │  (extends ChangeNotifier) │
├──────────────────────────┤  ├──────────────────────────┤
│ - _dao: TaskDAO          │  │ - _dao: ScheduleEventDAO │
│ + tasks: List<Task>      │  │ + events: List<Event>    │
├──────────────────────────┤  ├──────────────────────────┤
│ + addTask(Task)          │  │ + addEvent(Event)        │
│ + updateTask(Task)       │  │ + updateEvent(Event)     │
│ + deleteTask(int)        │  │ + deleteEvent(int)       │
│ + fetchAll()             │  │ + fetchByDate(DateTime)  │
│ + toggleComplete(Task)   │  │ + fetchAll()             │
└──────────────────────────┘  └──────────────────────────┘

┌──────────────────────────┐
│     HabitProvider        │
│  (extends ChangeNotifier)│
├──────────────────────────┤
│ - _habitDAO: HabitDAO    │
│ - _logDAO: HabitLogDAO   │
│ + habits: List<Habit>    │
├──────────────────────────┤
│ + addHabit(Habit)        │
│ + logHabit(int habitId)  │
│ + fetchAll()             │
│ + getStreak(int): int    │
└──────────────────────────┘
```

**Penjelasan hubungan antar layer:**

| Dari | Ke | Hubungan |
|---|---|---|
| **Presentations** | **Controllers (Providers)** | UI memanggil method Provider untuk aksi (tambah, edit, hapus) dan membaca state (list data) |
| **Controllers** | **DAO** | Provider memanggil DAO untuk operasi database |
| **DAO** | **Models** | DAO menerima dan mengembalikan data dalam bentuk Model |
| **DAO** | **Database (SqliteHelper)** | DAO mengakses database melalui SqliteHelper |

### 7.4. Sequence Diagram — Membuat Tugas Baru

```
Pengguna       TaskPres       TaskForm       TaskProvider     TaskDAO       Database
   │               │              │              │              │              │
   │  Tap FAB "+"  │              │              │              │              │
   │──────────────>│              │              │              │              │
   │               │ showModal    │              │              │              │
   │               │─────────────>│              │              │              │
   │               │              │              │              │              │
   │        Isi form & tap "Simpan"              │              │              │
   │─────────────────────────────>│              │              │              │
   │               │              │  Validasi OK │              │              │
   │               │              │  addTask()   │              │              │
   │               │              │─────────────>│              │              │
   │               │              │              │  insert(task)│              │
   │               │              │              │─────────────>│              │
   │               │              │              │              │  INSERT INTO │
   │               │              │              │              │─────────────>│
   │               │              │              │              │    Success   │
   │               │              │              │              │<─────────────│
   │               │              │              │   Task ID    │              │
   │               │              │              │<─────────────│              │
   │               │              │              │ notifyList() │              │
   │               │   Tutup form │              │              │              │
   │               │<─────────────│              │              │              │
   │               │  UI rebuild (listener)      │              │              │
   │   Tampil tugas│<────────────────────────────│              │              │
   │<──────────────│              │              │              │              │
   │               │              │              │              │              │
```

### 7.5. Activity Diagram — Check-in Habit

```
          ┌─────────┐
          │  Start  │
          └────┬────┘
               ▼
    ┌─────────────────────┐
    │  Buka Habit Page    │
    └──────────┬──────────┘
               ▼
    ┌─────────────────────┐
    │  Lihat daftar habit │
    │  di Habit Page      │
    └──────────┬──────────┘
               ▼
    ┌─────────────────────┐
    │  Tap habit card     │
    │  untuk check-in     │
    └──────────┬──────────┘
               ▼
       ┌───────────────┐
       │ Sudah check-in│──── Ya ───┐
       │  hari ini?    │           ▼
       └───────┬───────┘   ┌──────────────┐
               │ Tidak     │ Tampilkan    │
               ▼           │ "Sudah       │
    ┌─────────────────┐    │  check-in"   │
    │ Simpan log      │    └──────┬───────┘
    │ ke habit_logs   │           │
    └──────────┬──────┘           │
               ▼                  │
    ┌─────────────────┐           │
    │ Hitung streak   │           │
    │ (hari berturut) │           │
    └──────────┬──────┘           │
               ▼                  │
    ┌─────────────────┐           │
    │ Update tampilan │           │
    │ (streak + ✅)   │◄──────────┘
    └──────────┬──────┘
               ▼
          ┌─────────┐
          │   End   │
          └─────────┘
```

### 7.6. Activity Diagram — Melihat Kalender & Detail Tanggal

```
          ┌─────────┐
          │  Start  │
          └────┬────┘
               ▼
    ┌─────────────────────┐
    │  Buka Calendar Page │
    └──────────┬──────────┘
               ▼
    ┌─────────────────────┐
    │  Tampilkan kalender │
    │  bulanan + dot      │
    │  indicator          │
    └──────────┬──────────┘
               ▼
    ┌─────────────────────┐
    │  Pengguna tap       │
    │  tanggal tertentu   │
    └──────────┬──────────┘
               ▼
    ┌─────────────────────┐
    │  EventProvider      │
    │  query events untuk │
    │  tanggal tertentu   │
    │  → List<Event>      │
    └──────────┬──────────┘
               ▼
       ┌───────────────┐
       │  Ada data?    │──── Tidak ──┐
       └───────┬───────┘             ▼
               │ Ya          ┌──────────────┐
               ▼             │ Tampilkan    │
    ┌─────────────────┐      │ "Tidak ada   │
    │ Tampilkan list  │      │  kegiatan"   │
    │ event pada      │      └──────┬───────┘
    │ tanggal terpilih│             │
    └──────────┬──────┘             │
               ▼                    │
          ┌─────────┐               │
          │   End   │◄──────────────┘
          └─────────┘
```

---

## Riwayat Perubahan Dokumen

| Versi | Tanggal | Penulis | Keterangan |
|---|---|---|---|
| 1.0 | 25 Agustus 2026 | Jeremy Zadrimman Kause | Pembuatan dokumen SRS awal |
| 1.1 | 27 Agustus 2026 | Jeremy Zadrimman Kause | Pembaruan ERD (tambah tabel categories, rename events → schedule_events, tambah dukungan event berulang), pembaruan Class Diagram (tambah Provider layer, AgendaItem interface), penyesuaian struktur direktori sesuai implementasi aktual |
| 1.2 | 28 Agustus 2026 | Jeremy Zadrimman Kause | Restrukturisasi navigasi dari 3 tab menjadi 4 tab (Task, Habit, Kalender/Event, Profil). Penghapusan file dan konsep agenda (`agendaPres.dart`, `agendaProvider.dart`, `AgendaItem`) untuk menyederhanakan arsitektur sistem langsung ke 3 domain utama: Task, Habit, dan Event. |