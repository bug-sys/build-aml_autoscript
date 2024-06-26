#!/bin/bash
#set -x

# Memproses jenis chipset/SoC yang ingin dibuat
echo -e "\e[33mPilih jenis chipset/SoC yang ingin Anda buat:\e[0m"
echo "1. Amlogic s805"
echo "2. Amlogic s905"
read -p "Masukkan nomor chipset yang ingin Anda buat (1/2): " nomor

# Validasi pilihan pengguna
case "$nomor" in
    1)
        jenis="s805"
        ;;
    2)
        jenis="s905"
        ;;
    *)
        echo -e "\e[31mPilihan tidak valid. Silakan pilih nomor 1 untuk AMLs805 atau nomor 2 untuk AMLs905.\e[0m" 
        exit 1
        ;;
esac

# Membuat direktori untuk menyimpan hasil
HASIL=hasil
mkdir -p $HASIL

# Menentukan CHIPSET berdasarkan jenis yang dipilih
case "$jenis" in
    s805)
        CHIPSET=s805
        FILE_EXTENSIONS=("txt" "ini")
        ;;
    s905)
        CHIPSET=s905
        FILE_EXTENSIONS=("txt" "ini")
        ;;
esac

# Menyalin file konfigurasi ke direktori hasil
for ext in "${FILE_EXTENSIONS[@]}"; do
    cp "$CHIPSET/uEnv.$ext" "$HASIL/uEnv.$ext"
done

# Menjalankan perintah mkimage untuk chipset yang dipilih
process_chipset() {
    local script="$1"
    echo -e "\e[34mMemproses file $script...\e[0m" 
    if mkimage -C none -A arm -T script -d "$CHIPSET/$script.cmd" "$HASIL/$script" >/dev/null 2>&1; then
        echo -e "\e[32mSelesai\e[0m"
    else
        echo -e "\e[31mGagal memproses $script\e[0m"
        exit 1
    fi
}

# Memproses setiap jenis file yang diperlukan untuk chipset yang dipilih
process_chipset "aml_autoscript"
process_chipset "${CHIPSET}_autoscript"
process_chipset "emmc_autoscript"

echo -e "\e[32mSEMUA PROSES SUDAH SELESAI !!!\e[0m"
