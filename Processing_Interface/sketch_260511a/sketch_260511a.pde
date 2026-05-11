import processing.serial.*;

Serial myPort;
String val;
float angle, distSol, distOrta, distSag;
int maxDistance = 200; // Radar menzili (cm)
float radarRadius; // Ekrandaki radar yarıçapı (piksel)

void setup() {
  // Tam ekran veya büyük bir pencere açalım
  size(1200, 800); 
  // Radar yarıçapını ekrana göre dinamik ayarlayalım
  radarRadius = height * 0.8; 
  
  // Bilgisayarındaki COM portunu ayarla
  myPort = new Serial(this, "COM3", 115200); 
  background(0);
  smooth();
}

void draw() {
  // Profesyonel İz Bırakma Efekti (Fading)
  // Bu, eski ışınların yavaşça kaybolmasını sağlar.
  fill(0, 15); // İkinci parametre (alpha) ne kadar düşükse, iz o kadar uzun kalır.
  noStroke();
  rect(0, 0, width, height);

  drawGrid(); // Arka plan çizgilerini çiz

  // Seri porttan veriyi oku ve parçala
  if (myPort.available() > 0) {
    val = myPort.readStringUntil('\n');
    if (val != null) {
      val = trim(val);
      float[] list = float(split(val, ','));
      
      // Paket formatı: Angle,DistSol,DistOrta,DistSag
      if (list.length == 4) {
        angle = list[0];
        distSol = list[1];
        distOrta = list[2];
        distSag = list[3];
      }
    }
  }

  // --- 3 Sensörü Işınlar Halinde Görselleştir ---
  // Işınlar merkezden nesneye kadar uzanır.
  
  // Sol Sensör (Kırmızı Işın) - Fiziksel olarak +60 derecede varsayıyoruz
  drawRadarBeam(angle + 60, distSol, color(255, 50, 50)); 
  
  // Orta Sensör (Yeşil Işın) - Tam merkezde
  drawRadarBeam(angle, distOrta, color(50, 255, 50)); 
  
  // Sağ Sensör (Mavi Işın) - Fiziksel olarak -60 derecede varsayıyoruz
  drawRadarBeam(angle - 60, distSag, color(50, 50, 255));
  
  // --- Canlı Tarama İbnesi (Sweep Hand) ---
  // Servonun o an nereye baktığını gösteren ince parlak çizgi
  drawSweepHand(angle, color(0, 255, 0, 100)); // Hafif şeffaf yeşil
}

// Radar ızgarasını (daireler ve açılar) çizen fonksiyon
void drawGrid() {
  pushMatrix();
  translate(width/2, height - 80); // Merkezi alt-ortaya taşı
  stroke(0, 80, 0); // Koyu yeşil çizgiler
  noFill();
  strokeWeight(1);
  
  // Mesafe Halkalarını Çiz (50cm, 100cm, 150cm, 200cm)
  for (int i = 1; i <= 4; i++) {
    float r = map(i * 50, 0, maxDistance, 0, radarRadius);
    arc(0, 0, r*2, r*2, PI, TWO_PI);
  }
  
  // Açı Çizgilerini ve Metinlerini Çiz
  for (int a = 30; a <= 150; a += 30) {
    float rad = radians(-a);
    float x = radarRadius * cos(rad);
    float y = radarRadius * sin(rad);
    line(0, 0, x, y);
    
    // Açı metinleri
    fill(0, 150, 0);
    textAlign(CENTER);
    text(a + "°", x * 1.1, y * 1.1);
  }
  
  // Merkez noktası
  fill(0, 255, 0);
  ellipse(0, 0, 10, 10);
  popMatrix();
}

// Nesneyi merkezden uzanan bir ışın olarak çizen fonksiyon
void drawRadarBeam(float a, float d, color c) {
  // Sadece menzil içindeki (veyatimeout olmayan) verileri çiz
  if (d > 2 && d < maxDistance) {
    pushMatrix();
    translate(width/2, height - 80);
    
    // Mesafeyi piksele oranla
    float r = map(d, 0, maxDistance, 0, radarRadius);
    float rad = radians(-(a));
    float x = r * cos(rad);
    float y = r * sin(rad);
    
    // Işını çiz
    stroke(c);
    strokeWeight(6); // Işın kalınlığı
    line(0, 0, x, y); // Merkezden (0,0) nesneye (x,y)
    
    // İsteğe bağlı: Işının ucuna parlak bir nokta ekleyerek nesnenin tam yerini vurgula
    strokeWeight(10);
    stroke(255); // Beyaz nokta
    point(x, y);
    popMatrix();
  }
}

// Servonun mevcut konumunu gösteren ibre
void drawSweepHand(float a, color c) {
  pushMatrix();
  translate(width/2, height - 80);
  float rad = radians(-(a));
  float x = radarRadius * cos(rad);
  float y = radarRadius * sin(rad);
  
  stroke(c);
  strokeWeight(2);
  line(0, 0, x, y); // Merkezden en dış halkaya kadar
  popMatrix();
}
