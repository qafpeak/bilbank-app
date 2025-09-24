// Backend controllers/users/ klasörüne eklenecek dosyalar

// avatarController.js
const Response = require('../../lib/Response');
const User = require('../../db/models/User');

// Kullanılabilir avatar listesini getiren endpoint
const getAvatarList = async (req, res) => {
  try {
    const userId = req.userId; // authJwt middleware'den gelir
    
    // Kullanıcının mevcut avatar'ını al
    const user = await User.findById(userId);
    const currentAvatar = user?.avatar || '1'; // Default avatar 1

    // Avatar listesi oluştur (pp1.png - pp12.png)
    const avatars = [];
    for (let i = 1; i <= 12; i++) {
      avatars.push({
        id: i.toString(),
        file_name: `pp${i}.png`,
        display_name: `Avatar ${i}`,
        network_url: `${req.protocol}://${req.get('host')}/assets/pp/pp${i}.png`,
        is_selected: currentAvatar === i.toString()
      });
    }

    const responseData = {
      avatars: avatars,
      current_avatar_id: currentAvatar
    };

    return res.json(
      Response.success('Avatar listesi başarıyla getirildi', responseData)
    );

  } catch (error) {
    console.error('Get avatar list error:', error);
    return res.status(500).json(
      Response.error('Sunucu hatası', 500)
    );
  }
};

// Kullanıcının avatar'ını güncelleyen endpoint
const updateUserAvatar = async (req, res) => {
  try {
    const userId = req.userId; // authJwt middleware'den gelir
    const { avatar_id } = req.body;

    if (!avatar_id) {
      return res.status(400).json(
        Response.error('avatar_id gerekli', 400)
      );
    }

    // Avatar ID'nin geçerli olup olmadığını kontrol et (1-12 arası)
    const avatarIdNum = parseInt(avatar_id);
    if (isNaN(avatarIdNum) || avatarIdNum < 1 || avatarIdNum > 12) {
      return res.status(400).json(
        Response.error('Geçersiz avatar ID. 1-12 arası olmalı.', 400)
      );
    }

    // Kullanıcının avatar'ını güncelle
    const updatedUser = await User.findByIdAndUpdate(
      userId,
      { avatar: avatar_id },
      { new: true }
    );

    if (!updatedUser) {
      return res.status(404).json(
        Response.error('Kullanıcı bulunamadı', 404)
      );
    }

    const responseData = {
      avatar_id: avatar_id,
      avatar_url: `${req.protocol}://${req.get('host')}/assets/pp/pp${avatar_id}.png`,
      user_id: userId
    };

    return res.json(
      Response.success('Avatar başarıyla güncellendi', responseData)
    );

  } catch (error) {
    console.error('Update avatar error:', error);
    return res.status(500).json(
      Response.error('Sunucu hatası', 500)
    );
  }
};

module.exports = {
  getAvatarList,
  updateUserAvatar
};

/*
Backend routes/users.js dosyasına eklenmesi gereken route'lar:

const { getAvatarList, updateUserAvatar } = require('../controllers/users/avatarController');

// Existing routes...
router.get('/avatars', authJwt, getAvatarList);
router.post('/avatar', authJwt, updateUserAvatar);

*/

/*
Backend app.js dosyasına eklenmesi gereken static dosya servisi:

// Assets klasörünü statik olarak servis et
app.use('/assets', express.static(path.join(__dirname, 'assets')));

*/