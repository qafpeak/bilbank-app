// Backend controllers/rooms/ klasörüne eklenecek dosya
// roomRewards.js

const Response = require('../../lib/Response');

// Oda ödül dağıtımını getiren endpoint
const getRoomRewards = async (req, res) => {
  try {
    const { room_id } = req.body;

    if (!room_id) {
      return res.status(400).json(
        Response.error('room_id gerekli', 400)
      );
    }

    // Odayı veritabanından getir
    const Room = require('../../db/models/Room');
    const room = await Room.findById(room_id);

    if (!room) {
      return res.status(404).json(
        Response.error('Oda bulunamadı', 404)
      );
    }

    // Ödül dağıtımını hesapla
    const rewardTiers = calculateRewardDistribution(room.reward);

    const rewardsData = {
      room_id: room._id,
      room_title: room.title,
      total_reward: room.reward,
      reward_tiers: rewardTiers
    };

    return res.json(
      Response.success('Ödül dağıtımı başarıyla getirildi', rewardsData)
    );

  } catch (error) {
    console.error('Room rewards error:', error);
    return res.status(500).json(
      Response.error('Sunucu hatası', 500)
    );
  }
};

// Ödül dağıtımını hesaplayan fonksiyon
const calculateRewardDistribution = (totalReward) => {
  const percentages = [
    0.30, // 1. %30
    0.20, // 2. %20
    0.15, // 3. %15
    0.10, // 4. %10
    0.08, // 5. %8
    0.06, // 6. %6
    0.04, // 7. %4
    0.03, // 8. %3
    0.02, // 9. %2
    0.02, // 10. %2
  ];

  return percentages.map((percentage, index) => ({
    rank: index + 1,
    reward_amount: Math.round(totalReward * percentage),
    percentage: percentage
  }));
};

module.exports = {
  getRoomRewards
};

/*
Backend routes/rooms.js dosyasına eklenmesi gereken route:

const { getRoomRewards } = require('../controllers/rooms/roomRewards');

// Existing routes...
router.post('/rewards', authJwt, getRoomRewards);

*/