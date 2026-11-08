# Joki Username Finder — Windows Desktop v2.0.0

Aplikasi desktop Windows untuk memeriksa jejak profil publik berdasarkan username menggunakan **Sherlock Project** sebagai engine utama.

## Perbaikan v2.0.0 — Smart Scan & HTTP 403 Diagnostics

Versi ini ditujukan khusus untuk kasus ketika banyak platform mengembalikan HTTP 403, 429, atau hasil yang tidak dapat dipastikan.

- **HTTP 403/401/407 → BLOCKED**. Tidak lagi disamakan dengan NOT FOUND atau error biasa.
- **HTTP 429 → RATE LIMITED**. Dipisahkan dari pemblokiran akses.
- **HTTP 5xx, 408, 425 → ERROR**. Tetap berbeda dari hasil profil.
- **Scan bergelombang**. Maksimum 5 situs diproses bersamaan secara default, bukan menjalankan satu pemanggilan dengan seluruh katalog.
- **Cooldown**. Default jeda 5 detik antar-gelombang dan 15 detik antar-username.
- **Auto-pause**. Jika setidaknya 60% hasil dalam gelombang ditolak/dibatasi, scan dihentikan otomatis agar tidak terus membanjiri situs yang menolak.
- **Diagnosis koneksi**. Menguji 3 endpoint netral untuk membantu membedakan masalah koneksi/proxy lokal dari penolakan spesifik situs.
- **Riwayat keandalan platform**. Menampilkan jumlah FOUND, BLOCKED, 429, dan ERROR berdasarkan hasil yang tersimpan secara lokal.
- **Migrasi konfigurasi v1 → v2**. Riwayat SQLite lama dipertahankan dan pengaturan scan lama otomatis diganti ke default lebih konservatif. Pengaturan tema dan timeout tetap dipertahankan.

> Penting: jeda dan gelombang kecil dapat mengurangi lonjakan permintaan, tetapi **tidak dapat menghilangkan HTTP 403**. HTTP 403 berarti situs menolak permintaan pada saat pemeriksaan. Aplikasi tidak mencoba mengakali WAF, CAPTCHA, login, atau pembatasan akses.

## Fitur

- Single username dan bulk username.
- Pemilihan platform dari katalog `data.json` paket Sherlock yang terpasang.
- Progres proses, log aktivitas, dan tombol Stop.
- Status FOUND, NOT FOUND, UNKNOWN, ERROR, BLOCKED, dan RATE LIMITED.
- SQLite lokal untuk riwayat scan dan hasil.
- Export CSV, XLSX, PDF, dan JSON.
- Tema terang/gelap.
- Diagnosis koneksi dan ringkasan keandalan platform.
- Tidak membutuhkan Laravel, VPS, atau browser.

## Cara menjalankan

1. Tutup Joki Username Finder versi sebelumnya.
2. Ekstrak ZIP v2 ke folder baru, misalnya `D:\JokiUsernameFinder_v2`.
3. Jalankan `run.bat`. Folder `.venv` baru akan dibuat dan dependency dipasang bila belum tersedia.
4. Koneksi internet diperlukan untuk instalasi pertama.
5. Riwayat dan pengaturan tetap di `%LOCALAPPDATA%\JokiUsernameFinder`; database dimigrasikan otomatis dan pengaturan scan lama diperbarui ke default aman.

Python 3.10–3.13 64-bit diperlukan. Instal dari https://www.python.org/downloads/windows/ dan aktifkan **Add Python to PATH**.

## Rekomendasi pengaturan untuk kondisi HTTP 403

Gunakan pengaturan awal v2:

- 5 situs per gelombang.
- Cooldown 5 detik antar-gelombang.
- Jeda 15 detik antar-username.
- Jeda otomatis jika 60% atau lebih hasil satu gelombang berstatus BLOCKED/RATE LIMITED.

Jika hasil awal sudah didominasi 403, biarkan aplikasi menjeda scan. Buka **Pengaturan → Diagnosis HTTP 403 dan koneksi**. Jika endpoint netral juga gagal/403, periksa koneksi, DNS, proxy/VPN, firewall, atau proteksi web antivirus. Jika endpoint netral normal sementara situs target tetap 403, masalah lebih mungkin spesifik pada situs target, WAF, atau definisi pemeriksaan Sherlock.

Jangan menjalankan scan berulang-ulang untuk platform yang terus menolak permintaan. Tunggu, periksa kebijakan situs, atau abaikan platform yang tidak dapat diakses.

## Arti status

- **FOUND** — Sherlock mendeteksi profil pada URL tersebut.
- **NOT FOUND** — profil tidak terdeteksi pada saat pemeriksaan. Ini bukan jaminan username tersedia untuk registrasi.
- **UNKNOWN** — Sherlock tidak dapat memastikan status.
- **BLOCKED** — HTTP 401/403/407 atau indikasi halaman WAF. Keberadaan username belum dapat dipastikan.
- **RATE LIMITED** — HTTP 429. Situs membatasi frekuensi permintaan.
- **ERROR** — timeout, HTTP 408/425/5xx, kegagalan koneksi, atau proses gagal.

## Build executable Windows

1. Jalankan `run.bat` sekali agar dependency terpasang.
2. Klik dua kali `build_exe.bat`.
3. Hasil build berada di `dist\JokiUsernameFinder\`.
4. Jalankan `JokiUsernameFinder.exe`. File `sherlock_engine.exe` harus berada di folder yang sama.

Build executable harus dilakukan di Windows. ZIP source ini tidak menyertakan binary `.exe` hasil build silang.

## Data lokal

Data aplikasi disimpan di:

`%LOCALAPPDATA%\JokiUsernameFinder\`

Isi utamanya:

- `joki_username_finder.sqlite3` — database scan dan riwayat.
- `settings.json` — konfigurasi aplikasi.
- `exports\` — folder default untuk hasil ekspor.
- `logs\` — log aplikasi.
- `temp\` — direktori sementara.

Jangan hapus folder ini ketika memperbarui aplikasi jika ingin mempertahankan histori scan.

## Batasan dan penggunaan yang bertanggung jawab

Sherlock mengirim permintaan HTTP ke situs publik. Hasil dapat dipengaruhi perubahan website, pembatasan otomatis, koneksi internet, dan konfigurasi situs. Hasil tidak membuktikan identitas atau kepemilikan akun. Gunakan hanya untuk pemeriksaan yang sah dan hormati ketentuan layanan serta privasi setiap platform. Aplikasi tidak melakukan bypass login, CAPTCHA, WAF, atau pembatasan akses.

## Teknologi

- Python + PySide6
- Sherlock Project (`sherlock-project==0.16.2`)
- SQLite
- Requests
- OpenPyXL
- ReportLab
- PyInstaller

## Referensi

- Sherlock: https://github.com/sherlock-project/sherlock
- Sherlock installation: https://sherlockproject.xyz/installation
- Sherlock usage: https://sherlockproject.xyz/usage
