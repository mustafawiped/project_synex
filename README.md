# Synex
Modern bir mobil mesajlaşma uygulaması.

## Özellikler
- Gerçek zamanlı mesajlaşma
- Sesli arama (WebRTC)
- Kullanıcı yönetimi
- Güvenli kimlik doğrulama
- Modüler API mimarisi
- Anlık mobil bildirimler (mesaj, arama)

## Teknolojiler
### Mobil Uygulama
- **Flutter**
- **MVVM mimarisi**

### Sunucu
- **.NET 8**
- **ASP.NET Core Web API**
- **Modüler mimari**

### Veri Tabanı
- **MySQL**

### Gerçek Zamanlı İletişim
- **WebRTC** (Sesli konuşma)
  
### Gerçek Zamanlı Mobil Bildirimler
- **Firebase Notification**

## Proje Yapısı
```
Synex/
 ├── SynexApplication/ (Flutter)
 ├── SynexApi/ (ASP.NET Core Web API)
 └── database_query (MySQL scripti)
```

## Kurulum
### API
```bash
dotnet restore
dotnet run
```

### Mobil
```bash
flutter pub get
flutter run
```

## Lisans
Bu proje MIT lisansı ile lisanslanmıştır.

