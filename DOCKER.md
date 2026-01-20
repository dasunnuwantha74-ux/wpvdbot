# Docker Setup Guide

## Başlangıç

### 1. Ortam Değişkenlerini Ayarlayın

`.env` dosyasını oluşturun:

```bash
cp .env.example .env
```

`.env` dosyasını düzenleyin ve WhatsApp JID'lerinizi ekleyin:

```env
OWNER_JID=905xxxxxxxxx@c.us
ADMIN_JIDS=905xxxxxxxxx@c.us,905yyyyyyyyy@c.us
```

### 2. Docker Konteynerini Başlatın

```bash
# Sadece başlat
docker-compose up -d

# Çıkışı görüntüle (QR kod için gerekli)
docker-compose logs -f wpvdbot
```

### 3. QR Kod ile Oturum Açın

1. Docker log çıkışında QR kodunu görüntüleyin
2. WhatsApp uygulamasını açın
3. **Ayarlar** → **Bağlı Cihazlar**
4. **"Cihaz Bağla"** seçeneğine basın
5. QR kodunu tarayın

Authentication verileri `bot_auth/` klasörüne kaydedilecek ve konteyner yeniden başlatılsa da oturum korunacak.

## Kullanımı

### Bot Kontrol

```bash
# Logs görüntüle
docker-compose logs -f

# Durdur
docker-compose stop

# Kaldır
docker-compose down

# Yeniden başlat
docker-compose restart
```

### Veri Yönetimi

Tüm veriler volume'lar aracılığıyla host makinenizde kalıcı olarak saklanır:

- `bot_auth/` - WhatsApp authentication verileri
- `backups/` - Bot yedekleri
- `logs/` - Bot logları
- `videos/` - İndirilen videolar

### Konteyner İçine Girmek

```bash
docker-compose exec wpvdbot bash
```

## Sorun Giderme

### Chrome/Chromium Hatası

Dockerfile'da zaten gerekli tüm Chrome bağımlılıkları kurulu. Eğer hala sorun varsa:

```bash
docker-compose down
docker-compose up -d --build
```

### Konteyner Başlamıyor

```bash
docker-compose logs wpvdbot
```

### QR Kod Görünmüyor

Konteyner çalışmaya başladıktan sonra logs'u kontrol edin:

```bash
docker-compose logs -f wpvdbot
```

## Gelişmiş Ayarlar

### Özel Port Mapping

`docker-compose.yml` dosyasında ports kısmının açıklamasını kaldırın:

```yaml
ports:
  - "3000:3000"
```

### Konteyner Performansı

CPU veya bellek sınırlaması eklemek için `docker-compose.yml` dosyasında:

```yaml
services:
  whatsapp-bot:
    # ... diğer ayarlar
    deploy:
      resources:
        limits:
          cpus: '1'
          memory: 1G
```

## Production Kullanımı

Sistemin yeniden başlatılması sonrası Docker otomatik olarak başlasın:

```bash
docker-compose up -d
```

`restart: unless-stopped` ayarı zaten tanımlandığından, konteyner otomatik olarak yeniden başlayacaktır.

## Multi-Instance Kurulum

Birden fazla bot çalıştırmak istiyorsanız, her biri için ayrı bir klasör oluşturun ve `docker-compose.yml` dosyasını düzenleyin:

```yaml
services:
  wpvdbot-1:
    container_name: wpvdbot-1
    # ...
    volumes:
      - ./instance1/bot_auth:/app/.wwebjs_auth
      
  wpvdbot-2:
    container_name: wpvdbot-2
    # ...
    volumes:
      - ./instance2/bot_auth:/app/.wwebjs_auth
```
