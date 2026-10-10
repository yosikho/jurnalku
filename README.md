# Jurnalku

Jurnal harian pribadi bergaya Day One: tulis setiap hari, tambahkan foto, rekam suara, simpan lokasi, cari dengan #hashtag, lihat kalender dan peta, dan pakai template.
Data tersimpan di Supabase dan sinkron otomatis di semua device yang login dengan akun yang sama.

## Isi folder

| File | Fungsi |
|---|---|
| `index.html` | Aplikasinya |
| `config.js` | Alamat dan kunci Supabase Anda |
| `setup.sql` | Skrip sekali jalan untuk menyiapkan database Supabase |
| `manifest.webmanifest`, `icon-*.png` | Supaya bisa dipasang di layar utama HP |

## Setup (sekali saja)

### A. Supabase (database)
1. Buat project di [supabase.com](https://supabase.com) dengan region **Southeast Asia (Singapore)**.
2. Buka **SQL Editor → New query**, tempel seluruh isi `setup.sql`, lalu klik **Run**. Hasilnya harus menampilkan `Setup Jurnalku selesai`.
3. Buka **Authentication → URL Configuration**:
   - **Site URL**: alamat GitHub Pages Anda, misalnya `https://USERNAME.github.io/jurnalku/`
   - **Redirect URLs**: tambahkan alamat yang sama.
4. Salin **Project URL** dan **anon / publishable key** dari **Project Settings → API**, lalu isi ke `config.js`.

### B. GitHub Pages (alamat aplikasi)
1. Di GitHub, klik **New repository**. Beri nama `jurnalku`, pilih **Public**, lalu klik **Create repository**.
2. Klik **uploading an existing file**, seret semua file dari folder ini, lalu klik **Commit changes**.
3. Buka **Settings → Pages**. Pada *Source* pilih **Deploy from a branch**, Branch **main**, folder **/(root)**, lalu klik **Save**.
4. Tunggu 1–2 menit. Aplikasi akan tersedia di `https://USERNAME.github.io/jurnalku/`.

### C. Mulai pakai
1. Buka alamat tersebut, pilih **Buat akun**, isi email dan password, lalu klik link konfirmasi yang dikirim ke email.
2. **Setelah akun Anda jadi**, buka Supabase → **Authentication → Sign In / Providers → Email**, lalu matikan **Allow new users to sign up**. Dengan begitu orang lain tidak bisa membuat akun di database Anda.
3. Di HP, buka alamatnya di Chrome, ketuk menu **⋮ → Tambahkan ke layar utama**. Di iPhone gunakan Safari, lalu **Bagikan → Tambah ke Layar Utama**.
4. Untuk memindahkan jurnal lama, buka tab **Lainnya → Impor dari Day One**.

## Mengubah aplikasi nanti
Ganti file `index.html` di GitHub lewat **Add file → Upload files**. Data tidak ikut terhapus, karena data tersimpan di Supabase, bukan di GitHub.

Jika versi baru menambah kolom database, jalankan ulang seluruh isi `setup.sql` di **SQL Editor**. Skripnya aman dijalankan ulang dan tidak menghapus data.

## Batas paket gratis Supabase
- 1 GB untuk foto dan suara, kira-kira 4.000 foto.
- 500 MB untuk teks.
- Project akan dijeda jika tidak dipakai selama 1 minggu. Data tetap aman; cukup klik **Restore** di dashboard.

Pemakaian bisa dicek di aplikasi: **Lainnya → Penyimpanan**.
Simpan cadangan secara berkala lewat **Lainnya → Unduh cadangan**.
