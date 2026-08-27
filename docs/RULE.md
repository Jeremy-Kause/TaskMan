# 📘 Taksman – Project Rules & Architecture Guide

> Dokumen ini berisi aturan dan panduan pengembangan proyek **Taksman** agar kode tetap konsisten, modular, dan mudah dipelihara oleh seluruh tim.

---

## 1. Gambaran Umum Proyek

**Taksman** adalah aplikasi manajemen tugas (*task manager*) berbasis **Flutter** dengan fitur utama:

- Manajemen **Task** (tugas harian/mingguan/bulanan)
- Manajemen **Habit** (kebiasaan harian dengan logging)
- Manajemen **Event** (agenda/kegiatan dengan waktu)
- **Kalender** untuk visualisasi jadwal
- **Profil** pengguna

**Database**: SQLite (lokal via `sqflite`), dengan persiapan untuk Supabase (cloud sync di masa depan).

---

## 2. Struktur Folder `lib/`

```
lib/
├── main.dart               # Entry point aplikasi
├── models/                 # Data class / entitas
├── database/               # Konfigurasi & definisi database
│   ├── sqlite/             # SQLite lokal
│   │   ├── sqliteHelper.dart
│   │   └── tabels/         # Definisi tabel SQL
│   └── supabase/           # (Dipersiapkan untuk cloud sync)
├── dao/                    # Data Access Object – operasi CRUD
├── controlers/             # Controller – logika bisnis & state management
├── presentations/          # Halaman / layar utama (UI Screen)
├── components/             # Widget kecil yang reusable
├── hooks/                  # Custom hooks / lifecycle helpers
└── utils/                  # Utilitas & helper umum
```

---

## 3. Fungsi & Aturan Setiap Folder

### 3.1 `main.dart` – Entry Point

**Fungsi**: Titik masuk aplikasi. Hanya berisi inisialisasi dan konfigurasi global.

**Boleh berisi**:
- `WidgetsFlutterBinding.ensureInitialized()`
- Inisialisasi database / service
- Konfigurasi `MaterialApp` (tema, routes, home)
- Registrasi Provider / state management global

**Tidak boleh berisi**:
- Widget UI yang kompleks
- Logika bisnis
- Query database langsung

---

### 3.2 `models/` – Data Models

**Fungsi**: Mendefinisikan struktur data (entitas) yang digunakan di seluruh aplikasi.

**Aturan**:
- Setiap model adalah **plain Dart class** (tidak bergantung pada Flutter/UI)
- Wajib memiliki:
  - Constructor dengan named parameters
  - Method `toMap()` untuk konversi ke Map (simpan ke DB)
  - Factory `fromMap()` untuk konversi dari Map (baca dari DB)
- Satu file = satu model
- Penamaan file: `PascalCase` sesuai nama class (contoh: `Task.dart`, `Habit.dart`)

**File yang ada**:
| File               | Deskripsi                       |
|--------------------|---------------------------------|
| `Task.dart`        | Model tugas dengan prioritas & deadline |
| `Habit.dart`       | Model kebiasaan harian          |
| `Event.dart`       | Model agenda/kegiatan           |
| `habit_log.dart`   | Model log check-in habit harian |

---

### 3.3 `database/` – Konfigurasi Database

**Fungsi**: Mengelola koneksi database dan definisi skema tabel.

#### `database/sqlite/`
- `sqliteHelper.dart` → Singleton class untuk mengelola koneksi SQLite (open, create, close).
- `tabels/` → Berisi definisi SQL `CREATE TABLE` untuk setiap entitas.

**Aturan**:
- Gunakan **Singleton pattern** untuk koneksi database
- Definisi tabel terpisah per file di `tabels/`
- Increment `_databaseVersion` jika ada perubahan skema, dan tangani migrasi di `onUpgrade`

#### `database/supabase/`
- Dipersiapkan untuk integrasi cloud sync di masa depan
- Belum digunakan saat ini

---

### 3.4 `dao/` – Data Access Objects

**Fungsi**: Menyediakan operasi **CRUD** dan query terhadap database. DAO adalah satu-satunya layer yang boleh berinteraksi langsung dengan database.

**Aturan**:
- Satu DAO per model/entitas (contoh: `TaskDAO.dart` untuk `Task`)
- Setiap DAO wajib menyediakan method dasar:
  - `insert()` – Tambah data baru
  - `getById()` – Ambil satu data berdasarkan ID
  - `getAll()` – Ambil semua data
  - `update()` – Perbarui data
  - `delete()` – Hapus data
- Query khusus (filter, date range, dsb.) boleh ditambahkan sebagai method tambahan
- **Return type** selalu berupa Model, bukan `Map<String, dynamic>`
- Tidak boleh memiliki logika UI atau state management

**File yang ada**:
| File               | Deskripsi                          |
|--------------------|------------------------------------|
| `TaskDAO.dart`     | CRUD + filter hari/minggu/bulan/overdue |
| `HabitDAO.dart`    | CRUD untuk kebiasaan               |
| `HabitLogDAO.dart` | CRUD untuk log habit harian        |
| `EventDAO.dart`    | CRUD untuk agenda/kegiatan         |

---

### 3.5 `controlers/` – Controllers (Logika Bisnis & State)

**Fungsi**: Menjembatani antara **UI (presentations)** dan **Data (dao)**. Controller mengelola state aplikasi dan menjalankan logika bisnis.

**Tanggung jawab**:
- Memanggil method dari DAO
- Menyimpan data aktif ke dalam state (list, variabel)
- Memberitahu UI saat data berubah (`notifyListeners()` / `setState`)
- Validasi input sebelum menyimpan ke database
- Mengelola loading state, error handling

**Aturan**:
- Satu controller per fitur/modul (contoh: `task_controller.dart`, `habit_controller.dart`)
- **Presentations TIDAK boleh memanggil DAO langsung** – harus melalui Controller
- Gunakan `ChangeNotifier` atau state management pattern yang konsisten
- Tidak boleh berisi kode UI (Widget, BuildContext)

**Contoh file yang harus dibuat**:
| File                    | Deskripsi                              |
|-------------------------|----------------------------------------|
| `task_controller.dart`  | State & aksi untuk manajemen tugas     |
| `habit_controller.dart` | State & aksi untuk kebiasaan + log     |
| `event_controller.dart` | State & aksi untuk agenda/kegiatan     |

---

### 3.6 `presentations/` – Halaman / Screen UI

**Fungsi**: Berisi widget halaman utama yang ditampilkan ke pengguna. Setiap file merepresentasikan satu layar penuh.

**Aturan**:
- Satu file = satu halaman/screen
- Penamaan file: `namaFiturPres.dart` (contoh: `homePres.dart`, `profilePres.dart`)
- Boleh menggunakan `StatefulWidget` atau `StatelessWidget`
- **Ambil data dari Controller**, bukan langsung dari DAO
- Komposisi UI menggunakan widget dari `components/`
- Navigasi antar halaman dikelola dari sini atau dari `mainNavPres.dart`

**File yang ada**:
| File                  | Deskripsi                         |
|-----------------------|-----------------------------------|
| `homePres.dart`       | Halaman utama / dashboard         |
| `calenderPres.dart`   | Halaman kalender & jadwal         |
| `profilePres.dart`    | Halaman profil pengguna           |
| `mainNavPres.dart`    | Wrapper navigasi (BottomNav/Tab)  |

---

### 3.7 `components/` – Reusable Widgets

**Fungsi**: Berisi potongan UI kecil yang **digunakan berulang** di berbagai halaman.

**Aturan**:
- Setiap komponen harus **self-contained** dan bisa dipakai di halaman mana pun
- Terima data melalui **constructor parameter**, bukan langsung akses global state
- Penamaan file: `snake_case.dart` (contoh: `task_card.dart`, `habit_item.dart`)
- Tidak boleh memanggil DAO atau Controller secara langsung – terima data & callback dari parent

**Contoh file yang bisa dibuat**:
| File                   | Deskripsi                              |
|------------------------|----------------------------------------|
| `task_card.dart`       | Kartu tampilan satu tugas              |
| `habit_item.dart`      | Item kebiasaan dengan tombol check-in  |
| `event_card.dart`      | Kartu tampilan satu agenda             |
| `priority_badge.dart`  | Badge warna berdasarkan prioritas      |
| `empty_state.dart`     | Placeholder saat daftar kosong         |
| `summary_card.dart`    | Kartu ringkasan statistik              |

---

### 3.8 `hooks/` – Custom Hooks / Lifecycle Helpers

**Fungsi**: Berisi helper terkait lifecycle widget atau custom hooks untuk logika yang berulang.

**Contoh penggunaan**:
- Custom hook untuk auto-refresh data saat halaman dibuka
- Timer/interval handler untuk notifikasi
- Lifecycle observer (app foreground/background)

---

### 3.9 `utils/` – Utilitas & Helper

**Fungsi**: Berisi fungsi-fungsi pembantu yang bersifat **general-purpose** dan tidak terikat pada fitur tertentu.

**Aturan**:
- Tidak boleh bergantung pada model, DAO, atau controller tertentu
- Berisi class/fungsi statis murni (pure functions)
- Penamaan file: `snake_case.dart`

**File yang ada**:
| File               | Deskripsi                                    |
|--------------------|----------------------------------------------|
| `app_theme.dart`   | Definisi tema, warna (`AppColors`), dan style Material 3 |
| `date_helper.dart` | Formatter tanggal dalam Bahasa Indonesia     |

---

## 4. Alur Data (Data Flow)

```
┌─────────────────────────────────────────────────────────┐
│                        USER                             │
└──────────────────────┬──────────────────────────────────┘
                       │ interaksi (tap, input)
                       ▼
┌─────────────────────────────────────────────────────────┐
│  PRESENTATIONS (homePres, calenderPres, profilePres)    │
│  → Menampilkan UI, menerima input user                  │
│  → Menggunakan widget dari COMPONENTS                   │
└──────────────────────┬──────────────────────────────────┘
                       │ panggil aksi / baca state
                       ▼
┌─────────────────────────────────────────────────────────┐
│  CONTROLLERS (task_controller, habit_controller)        │
│  → Mengelola state & logika bisnis                      │
│  → Validasi data                                        │
│  → Notify UI saat data berubah                          │
└──────────────────────┬──────────────────────────────────┘
                       │ panggil CRUD
                       ▼
┌─────────────────────────────────────────────────────────┐
│  DAO (TaskDAO, HabitDAO, EventDAO, HabitLogDAO)         │
│  → Eksekusi query SQL                                   │
│  → Return data sebagai Model                            │
└──────────────────────┬──────────────────────────────────┘
                       │ read/write
                       ▼
┌─────────────────────────────────────────────────────────┐
│  DATABASE (SQLite via sqliteHelper)                     │
│  → Penyimpanan data persisten                           │
└─────────────────────────────────────────────────────────┘
```

**Aturan penting**:
- ❌ **Presentations → DAO** (DILARANG, harus lewat Controller)
- ❌ **Components → DAO / Controller** (DILARANG, terima data via parameter)
- ✅ **Presentations → Controller → DAO → Database**

---

## 5. Konvensi Penamaan

| Elemen         | Konvensi          | Contoh                      |
|----------------|-------------------|-----------------------------|
| File Model     | `PascalCase.dart` | `Task.dart`, `Habit.dart`   |
| File DAO       | `PascalCaseDAO.dart` | `TaskDAO.dart`           |
| File Controller| `snake_case_controller.dart` | `task_controller.dart` |
| File Presentation | `camelCasePres.dart` | `homePres.dart`       |
| File Component | `snake_case.dart` | `task_card.dart`            |
| File Util      | `snake_case.dart` | `date_helper.dart`          |
| File Tabel DB  | `snake_case_table.dart` | `task_table.dart`      |
| Class          | `PascalCase`      | `TaskDAO`, `AppTheme`       |
| Variable/Method| `camelCase`       | `getThisDay()`, `todayTasks`|
| Konstanta      | `camelCase` / `UPPER_SNAKE` | `tableName`, `_databaseVersion` |

---

## 6. Aturan Umum Pengembangan

### 6.1 Prinsip Dasar
- **Single Responsibility**: Satu file/class = satu tanggung jawab
- **DRY (Don't Repeat Yourself)**: Widget yang dipakai > 1 kali → pindahkan ke `components/`
- **Separation of Concerns**: UI, logika bisnis, dan akses data harus terpisah

### 6.2 Dependensi Antar Layer
```
models      → tidak bergantung pada apapun
database    → bergantung pada models (untuk definisi tabel)
dao         → bergantung pada database + models
controlers  → bergantung pada dao + models
components  → bergantung pada models (untuk type parameter)
presentations → bergantung pada controlers + components + models
utils       → tidak bergantung pada layer lain (berdiri sendiri)
```

### 6.3 State Management
- Gunakan `ChangeNotifier` + `Provider` atau pattern serupa yang konsisten
- Semua state yang berhubungan dengan data → di dalam Controller
- State lokal UI (animasi, form input sementara) → boleh di dalam `StatefulWidget`

### 6.4 Tema & Styling
- Semua warna didefinisikan di `AppColors` (`utils/app_theme.dart`)
- Semua konfigurasi tema di `AppTheme.lightTheme`
- **Jangan hardcode warna di widget** – selalu referensikan dari `AppColors` atau `Theme.of(context)`
- Gunakan Material 3 (`useMaterial3: true`)

### 6.5 Format Tanggal
- Gunakan `DateHelper` (`utils/date_helper.dart`) untuk semua formatting tanggal
- Format default dalam **Bahasa Indonesia**
- Jangan gunakan `toString()` langsung pada `DateTime` untuk tampilan ke user

---

## 7. Checklist Sebelum Commit

- [ ] Kode tidak mengandung `print()` debug yang tertinggal
- [ ] Tidak ada widget yang langsung memanggil DAO (harus lewat Controller)
- [ ] Warna menggunakan `AppColors`, bukan hardcode hex
- [ ] Format tanggal menggunakan `DateHelper`
- [ ] Widget reusable sudah dipindahkan ke `components/`
- [ ] File baru mengikuti konvensi penamaan yang benar
- [ ] Tidak ada import yang tidak terpakai
