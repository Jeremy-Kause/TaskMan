# Product Requirement Document (PRD) - TASKMAN

- **Penulis:** Jeremy Zadrimman Kause ([zekkey24@gmai.com](mailto:zekkey24@gmai.com))
- **Platform:** Android & iOS
- **Teknologi:** Flutter (Dart)
- **Status:** Draft
- **Tanggal:** 25 Agustus 2026

---

## 1. Latar Belakang

Mahasiswa dan pekerja sering menghadapi kesulitan dalam mengatur waktu dan mengelola berbagai tugas yang mereka miliki. Banyaknya tugas harian, mingguan, jadwal kuliah/kerja, serta kebiasaan yang ingin dibangun membuat mereka kewalahan jika tidak memiliki sistem manajemen yang baik. Hal ini mengakibatkan tugas terlewat, deadline tidak terpenuhi, dan produktivitas menurun.

Aplikasi **Taskman** hadir sebagai solusi untuk membantu pengguna mengelola tugas, jadwal, dan kebiasaan mereka dalam satu platform yang terintegrasi. Dengan fitur prioritas dan pengingat (reminder), pengguna dapat fokus pada hal yang paling penting terlebih dahulu.

## 2. Tujuan Aplikasi

- Membantu pengguna mencatat dan mengelola **tugas harian dan mingguan** secara terstruktur.
- Menyediakan fitur **kalender** untuk melihat jadwal dan event secara visual.
- Membantu pengguna membangun **kebiasaan positif (habit tracking)** secara konsisten.
- Menyediakan sistem **prioritas tugas** agar pengguna fokus pada hal yang paling penting.
- Memberikan **reminder/notifikasi** agar tugas dan jadwal tidak terlewat.
- Meningkatkan produktivitas dan manajemen waktu pengguna secara keseluruhan.

## 3. Target Pengguna

| Segmen | Kebutuhan Utama | Pain Point |
|---|---|---|
| **Mahasiswa** | Mengatur tugas kuliah, deadline, jadwal kelas, dan kegiatan organisasi | Tugas menumpuk, lupa deadline, sulit membagi waktu |
| **Pekerja / Profesional** | Mengatur task pekerjaan, meeting, dan kebiasaan produktif | Banyak task bersamaan, sulit menentukan prioritas |
| **Pekerja Lepas (Freelancer)** | Mengatur project dari berbagai klien dan jadwal sendiri | Tidak ada struktur waktu yang jelas |

## 4. Scope dan Fitur

### a. MVP (Minimum Viable Product)

- [ ] Navigasi utama (Home, Calendar, Profile)
- [ ] **Manajemen Tugas (Task)**
  - [ ] Membuat, mengedit, dan menghapus tugas
  - [ ] Menentukan jenis tugas: harian atau mingguan
  - [ ] Menandai tugas sebagai selesai
  - [ ] Menentukan level prioritas (Tinggi, Sedang, Rendah)
  - [ ] Menentukan deadline / tenggat waktu
- [ ] **Kalender & Event**
  - [ ] Tampilan kalender bulanan
  - [ ] Melihat tugas dan event berdasarkan tanggal
  - [ ] Menambahkan event (kuliah, meeting, kegiatan)
- [ ] **Habit Tracker**
  - [ ] Membuat kebiasaan baru yang ingin dibangun
  - [ ] Check-in harian untuk setiap kebiasaan
  - [ ] Melihat streak / progres kebiasaan
- [ ] **Reminder / Notifikasi**
  - [ ] Pengingat sebelum deadline tugas
  - [ ] Pengingat untuk check-in kebiasaan harian
- [ ] **Profil Pengguna**
  - [ ] Melihat ringkasan statistik (tugas selesai, streak habit)

### b. Nice To Have

- [ ] Kategori/label untuk tugas (Kuliah, Kerja, Pribadi)
- [ ] Tampilan kalender mingguan
- [ ] Dark mode / tema kustomisasi
- [ ] Laporan produktivitas mingguan/bulanan
- [ ] Fitur pomodoro timer
- [ ] Recurring task (tugas berulang otomatis)
- [ ] Widget di home screen perangkat

### c. Out Of Scope

- Sinkronisasi multi-perangkat / cloud sync (fase selanjutnya)
- Fitur kolaborasi / berbagi tugas antar pengguna
- Integrasi dengan Google Calendar atau platform eksternal
- Versi web application

## 5. User Stories

### Manajemen Tugas
- **Sebagai** mahasiswa, **saya ingin** membuat tugas baru dengan judul, deskripsi, dan deadline, **sehingga** saya bisa mencatat semua tugas yang perlu dikerjakan.
- **Sebagai** pekerja, **saya ingin** menentukan prioritas tugas (Tinggi/Sedang/Rendah), **sehingga** saya bisa mengerjakan yang paling penting terlebih dahulu.
- **Sebagai** pengguna, **saya ingin** menandai tugas sebagai selesai, **sehingga** saya bisa melacak progres pekerjaan saya.
- **Sebagai** pengguna, **saya ingin** memisahkan tugas harian dan mingguan, **sehingga** saya bisa fokus pada tugas hari ini tanpa kewalahan.

### Kalender & Event
- **Sebagai** mahasiswa, **saya ingin** melihat semua tugas dan event di kalender, **sehingga** saya bisa melihat jadwal secara keseluruhan dalam satu tampilan.
- **Sebagai** pengguna, **saya ingin** menambahkan event ke tanggal tertentu, **sehingga** saya bisa mencatat jadwal kuliah, meeting, atau kegiatan penting.

### Habit Tracker
- **Sebagai** pengguna, **saya ingin** membuat kebiasaan baru (misal: olahraga, membaca), **sehingga** saya bisa membangun rutinitas yang konsisten.
- **Sebagai** pengguna, **saya ingin** melakukan check-in harian untuk kebiasaan saya, **sehingga** saya bisa melihat streak dan tetap termotivasi.

### Reminder
- **Sebagai** pengguna, **saya ingin** mendapatkan notifikasi sebelum deadline tugas, **sehingga** saya tidak lupa dan bisa menyelesaikannya tepat waktu.
- **Sebagai** pengguna, **saya ingin** diingatkan untuk check-in kebiasaan setiap hari, **sehingga** saya tidak melewatkan rutinitas saya.

## 6. Functional Requirement

### Tugas (Task)
- **FR-01:** Sistem dapat membuat tugas baru dengan field: judul, deskripsi, deadline, prioritas, dan jenis (harian/mingguan).
- **FR-02:** Sistem dapat menampilkan daftar tugas berdasarkan filter (semua, hari ini, minggu ini, selesai).
- **FR-03:** Sistem dapat mengedit dan menghapus tugas yang sudah ada.
- **FR-04:** Sistem dapat menandai tugas sebagai selesai/belum selesai.
- **FR-05:** Sistem dapat mengurutkan tugas berdasarkan prioritas dan deadline.

### Kalender & Event
- **FR-06:** Sistem dapat menampilkan kalender bulanan dengan indikator tugas/event pada setiap tanggal.
- **FR-07:** Sistem dapat menambahkan, mengedit, dan menghapus event pada tanggal tertentu.
- **FR-08:** Sistem dapat menampilkan detail tugas dan event ketika tanggal di kalender dipilih.

### Habit Tracker
- **FR-09:** Sistem dapat membuat kebiasaan baru dengan field: nama, frekuensi, dan waktu pengingat.
- **FR-10:** Sistem dapat mencatat check-in harian untuk setiap kebiasaan.
- **FR-11:** Sistem dapat menampilkan streak (hari berturut-turut) untuk setiap kebiasaan.

### Reminder
- **FR-12:** Sistem dapat mengirimkan notifikasi lokal sebelum deadline tugas.
- **FR-13:** Sistem dapat mengirimkan notifikasi pengingat untuk check-in kebiasaan harian.

### Profil
- **FR-14:** Sistem dapat menampilkan statistik pengguna (total tugas selesai, habit streak terpanjang).

## 7. Non-Functional Requirement

| Kategori | Requirement |
|---|---|
| **Performa** | Aplikasi harus memuat halaman dalam waktu < 2 detik. |
| **Ketersediaan** | Aplikasi dapat digunakan secara offline (data tersimpan lokal). |
| **Keamanan** | Data pengguna tersimpan secara lokal di perangkat menggunakan database lokal (SQLite/Hive). |
| **Usability** | Antarmuka harus intuitif, bersih, dan mudah digunakan dengan maksimal 3 tap untuk aksi utama. |
| **Kompatibilitas** | Mendukung Android 8.0+ dan iOS 13+. |
| **Ukuran Aplikasi** | Ukuran instalasi tidak lebih dari 50 MB. |

## 8. Success Metrics

| Metrik | Target |
|---|---|
| Instalasi di bulan pertama | ≥ 500 unduhan |
| Daily Active Users (DAU) | ≥ 20% dari total pengguna |
| Tingkat penyelesaian tugas | ≥ 60% tugas ditandai selesai |
| Rata-rata habit streak | ≥ 7 hari berturut-turut |
| Crash rate | < 1% |
| Rating Play Store / App Store | ≥ 4.0 / 5.0 |

## 9. Risk and Assumption

### Asumsi
- Pengguna memiliki perangkat Android atau iOS yang memenuhi persyaratan minimum.
- Pengguna bersedia memberikan izin notifikasi untuk fitur reminder.
- Penyimpanan data lokal cukup untuk kebutuhan pengguna individu.

### Risiko & Mitigasi

| Risiko | Dampak | Mitigasi |
|---|---|---|
| Pengguna tidak mengaktifkan notifikasi | Fitur reminder tidak berfungsi | Menampilkan panduan dan ajakan untuk mengaktifkan notifikasi saat pertama kali menggunakan app |
| Data hilang jika perangkat rusak/reset | Pengguna kehilangan semua tugas dan progres | Menyediakan fitur ekspor data (JSON/CSV) sebagai backup manual; cloud sync di fase berikutnya |
| Persaingan dengan aplikasi sejenis (Todoist, Notion, dll) | Pengguna memilih aplikasi lain | Fokus pada kesederhanaan dan kecepatan; desain yang ditujukan khusus untuk mahasiswa & pekerja Indonesia |
| Scope creep selama pengembangan | Deadline pengembangan terlewat | Disiplin mengikuti scope MVP; fitur tambahan masuk ke backlog Nice To Have |