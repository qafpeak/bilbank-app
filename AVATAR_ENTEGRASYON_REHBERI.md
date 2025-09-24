# Backend Entegrasyon Rehberi

## 1. Backend Dosyalarına Eklenmesi Gerekenler

### A) app.js dosyasına eklenecek (Assets için static dosya servisi):
```javascript
// Assets klasörünü statik olarak servis et
app.use('/assets', express.static(path.join(__dirname, 'assets')));
```

### B) controllers/users/ klasörüne avatarController.js dosyası oluşturun:
- `backend_template_avatarController.js` dosyasının içeriğini `controllers/users/avatarController.js` olarak kaydedin

### C) routes/users.js dosyasına route'ları ekleyin:
```javascript
const { getAvatarList, updateUserAvatar } = require('../controllers/users/avatarController');

// Mevcut route'ların altına ekleyin:
router.get('/avatars', authJwt, getAvatarList);
router.post('/avatar', authJwt, updateUserAvatar);
```

### D) User modelinin avatar field'ının string olduğundan emin olun (zaten var)

## 2. Flutter Tarafında Tamamlanan Özellikler

✅ **Modeller:**
- `AvatarModel` - Avatar bilgilerini tutan model
- `AvatarListResponse` - Avatar listesini tutan response model

✅ **UI Komponentleri:**
- `AvatarSelectionBottomSheet` - Avatar seçim bottom sheet'i
- `AvatarCard` güncellendi - Network image desteği eklendi

✅ **API Entegrasyonu:**
- `ApiConstants` - Avatar endpoint'leri eklendi
- `UserProvider` - Avatar CRUD operasyonları eklendi

✅ **State Management:**
- Local storage - Avatar ID saklama
- Provider updates - Real-time avatar güncellemeleri

## 3. Nasıl Çalışır?

1. **Avatar Gösterimi:**
   - Profil sayfasında kullanıcının mevcut avatar'ı görüntülenir
   - Avatar URL: `{baseUrl}/assets/pp/pp{avatarId}.png`

2. **Avatar Seçimi:**
   - Edit butonuna tıklandığında avatar seçim bottom sheet açılır
   - 3x4 grid'de 12 avatar seçeneği gösterilir
   - Mevcut avatar yeşil yıldız ile işaretlenir
   - Seçilen avatar mavi check ile işaretlenir

3. **Avatar Güncelleme:**
   - Seçim onaylandığında backend'e API çağrısı yapılır
   - Başarılı güncelleme sonrası local storage ve provider güncellenir
   - Profil sayfasında yeni avatar anında görünür

## 4. Backend API Endpoint'leri

### GET `/api/users/avatars`
- Kullanılabilir avatar listesini döndürür
- Kullanıcının mevcut avatar'ını işaretler

**Response:**
```json
{
  "success": true,
  "message": "Avatar listesi başarıyla getirildi",
  "data": {
    "avatars": [
      {
        "id": "1",
        "file_name": "pp1.png",
        "display_name": "Avatar 1",
        "network_url": "http://localhost:3000/assets/pp/pp1.png",
        "is_selected": true
      }
    ],
    "current_avatar_id": "1"
  }
}
```

### POST `/api/users/avatar`
- Kullanıcının avatar'ını günceller

**Request:**
```json
{
  "avatar_id": "5"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Avatar başarıyla güncellendi",
  "data": {
    "avatar_id": "5",
    "avatar_url": "http://localhost:3000/assets/pp/pp5.png",
    "user_id": "user_id_here"
  }
}
```

## 5. Önemli Notlar

- Avatar dosyaları `assets/pp/pp1.png` - `assets/pp/pp12.png` formatında olmalı
- Backend'de `express.static` middleware'i assets klasörünü servis etmeli
- User modelinde `avatar` field'ı string tipinde olmalı (1-12 arası değer)
- Frontend offline durumda varsayılan avatar listesi kullanır
- Error handling her iki tarafta da mevcut

## 6. Test Etmek İçin

1. Backend'i başlat ve assets klasörünün erişilebilir olduğunu kontrol et
2. Flutter uygulamasında profil sayfasına git
3. Avatar üzerindeki edit butonuna tıkla
4. Farklı bir avatar seç ve onayla
5. Avatar'ın güncellendiğini ve sonraki girişlerde saklandığını kontrol et