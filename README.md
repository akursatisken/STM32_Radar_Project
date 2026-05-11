# 🛰️ Multi-Channel Phased Array Radar System
> **STM32-based Real-Time Object Detection & Visualization Project**

![GitHub top language](https://img.shields.io/github/languages/top/akursatisken/STM32_Radar_Project?color=blue&style=for-the-badge)
![GitHub hardware](https://img.shields.io/badge/Hardware-STM32F103--C8T6-orange?style=for-the-badge)
![GitHub status](https://img.shields.io/badge/Status-Completed-green?style=for-the-badge)

## 📖 Genel Bakış
Bu proje, yüksek hassasiyetli nesne tespiti için tasarlanmış, gömülü sistemler ve bilgisayar bilimlerini birleştiren bir **End-to-End** (Uçtan Uca) mühendislik çalışmasıdır. 3 adet ultrasonik sensörün senkronize çalışmasıyla elde edilen veriler, karmaşık sinyal işleme süreçlerinden geçerek görsel bir radar arayüzüne dönüştürülür.

---

## 🛠️ Teknik Mimari

### 🧠 Mikrodenetleyici Seviyesi (STM32)
* **Hassas Zamanlama:** `TIM1` timer'ı kullanılarak mikrosaniye seviyesinde ultrasonik tetikleme (Trigger) ve yankı (Echo) okuma.
* **PWM Kontrolü:** `TIM2` birimi üzerinden 50Hz frekansında, 0.5ms-2.5ms arası *Duty Cycle* ile yüksek çözünürlüklü servo konumlandırma.
* **Hata Yönetimi:** Sensörlerden sinyal gelmemesi durumunda işlemcinin kilitlenmesini önleyen **Timeout ve Watchdog** mantığına sahip algoritmalar.
* **UART Haberleşme:** 115200 baud hızında, veri kaybını minimize eden paketleme yapısı.

### ⚡ Donanım Koruması ve Güç Yönetimi
* **LM2596 Buck Converter:** Harici 12V kaynağı, servo ve sensörlerin ihtiyacı olan **stabil 5V** seviyesine regüle eder.
* **Direnç Bariyeri (Safety First):** Sensörlerin 5V'luk Echo çıkışları ile STM32'nin hassas giriş pinleri arasına **1kΩ koruma dirençleri** eklenerek "Overcurrent" koruması sağlanmıştır.
* **Common Ground:** Sinyal referansının kaymaması için tüm sistem şaseleri (GND) tek noktada birleştirilmiştir.

---

## 📊 Görselleştirme (Processing GUI)
Radar arayüzü, gelen ham verileri kutupsal koordinatlardan kartezyen koordinatlara dönüştürerek canlı bir ekran sunar:
* **Işın (Beam) Modu:** Her sensörün kapsama alanı, merkezden dışa uzanan renkli ışınlarla temsil edilir.
* **Fading Efekti:** Eski tarama verilerinin yavaşça kararması sağlanarak gerçek bir radar fosfor ekranı estetiği yakalanmıştır.
* **Tehlike Analizi:** Nesne mesafesine göre dinamik renk değişimi ve beyaz odak noktaları.

---

## 🔌 Pin Konfigürasyonu (Pinout)

| Fonksiyon | Pin | Tip | Açıklama |
| :--- | :--- | :--- | :--- |
| **Servo PWM** | `PA0` | Output | PWM (TIM2_CH1) |
| **Trigger (All)** | `PA8` | Output | Ortak Tetikleme Hattı |
| **Left Echo** | `PA9` | Input | 1kΩ Koruma Dirençli |
| **Center Echo** | `PB11` | Input | 1kΩ Koruma Dirençli |
| **Right Echo** | `PB5` | Input | 1kΩ Koruma Dirençli |

---
## ⚙️ Kurulum ve Çalıştırma

Projenin sorunsuz çalışması için aşağıdaki adımları sırasıyla uygulayınız:

### 1. Yazılım Hazırlığı
* **STM32:** `STM32_Code/` klasörü altındaki projeyi STM32CubeIDE veya VS Code (PlatformIO/STM32-Extension) ile açın. Derleme (Build) sonrası oluşan `.bin` veya `.elf` dosyasını kartınıza yükleyin.
* **Processing:** Bilgisayarınıza [Processing IDE](https://processing.org/) yükleyin. `Processing_Interface/` klasöründeki `.pde` dosyasını açın.
    * *Önemli:* Kod içerisindeki `myPort = new Serial(this, "COM3", 115200);` satırındaki **"COM3"** ifadesini, kartınızın bağlı olduğu port ile değiştirin.

### 2. Donanım ve Güç Bağlantısı
* **Voltaj Ayarı:** Devreye enerji vermeden önce LM2596 regülatörünün çıkışını multimetre ile ölçün ve trimpotu çevirerek **tam 5.0V** değerine sabitleyin.
* **Bağlantı Kontrolü:** Sensörlerin Echo hatları üzerindeki **1kΩ koruma dirençlerinin** ve ortak şase (GND) bağlantısının yapıldığından emin olun.

### 3. Sistemi Başlatma
1.  Önce donanıma (güç kaynağına) enerji verin; servonun başlangıç konumuna geldiğini ve sensörlerin tetiklendiğini gözlemleyin.
2.  Ardından Processing IDE üzerinden "Run" butonuna basarak görsel arayüzü başlatın.
3.  Ekranda yeşil tarama çizgisinin (Sweep Hand) servo ile senkronize hareket ettiğini ve nesne algılandığında renkli ışınların oluştuğunu göreceksiniz.

---

## 📂 Proje Yapısı
```text
├── STM32_Code/           # STM32CubeIDE projesi ve C kodları
├── Processing_Interface/ # Görselleştirme arayüzü (.pde)
├── Media/                # Devre fotoğrafları ve çalışma videoları
└── Schematics/           # Bağlantı şemaları (EasyEDA/Fritzing)
