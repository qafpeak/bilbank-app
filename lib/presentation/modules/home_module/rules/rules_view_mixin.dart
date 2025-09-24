



mixin RulesViewMixin  {
  
  final  List<String> gameplayAndScoring = [
    "Her doğru cevap: +10 puan",
    "Yanlış veya boş cevap: Puan değişmez",
    "Her soru için süre: 15 saniye",
    "Maksimum 15 çark kullanabilirsiniz",
    "Çark çarpanı (örn. x20) puanı çarpar: 10 × 20 = 200 puan!",
  ];

  

  
  final  List<String> competitionRooms = [
    "Yarışmalar belirlenen odalarda yapılır.",
    "Başlaması için en az 200 oyuncu gerekir.",
    "Her odaya maksimum 1000 oyuncu katılabilir.",
    "Oda kapasitesi dolduktan sonra başvuran oyuncular sonraki yarışma grubuna aktarılır.",
    "Katılım ücreti oyun cüzdanından çekilir.",
    "Toplam süre: 120 dakika",
  ];

  
  final  List<String> rankingAndRewards = [
    "İlk 10 oyuncu ödül kazanır.",
    "Eşit puan varsa doğru cevap sayısı fazla olan önde.",
    "Ödül: Elmas (oyun içi para birimi)",
    "Elmaslar çekim talebi ile nakite çevirilebilir.",
  ];

  
  final  List<String> wheelUsage = [
    "Çarklar oyun içi mağazadan satın alınır.",
    "Her soruda sadece 1 çark kullanılır.",
    "Yarışma başına en fazla 15 çark.",
    "Kullanılan çarklar iade edilmez.",
    "Satın alınan çark ve oda ücretleri iade edilmez.",
  ];

  
  final  List<String> diamondsAndWithdrawal = [
    "Oyun içi para birimi: Elmas",
    "Ödeme: devreden ayın 15-20’sinde yapılır.",
    "Kazanç sorumluluğu kullanıcıya aittir.",
    "Devlet vergi/stopaj kesintileri uygulanır.",
  ];

  
  final  List<String> legalAndTax = [
    "Kazançlar Türkiye vergi mevzuatına tabidir.",
    "Gelir vergisi veya stopaj kesintisi yapılır.",
    "Kesinti sonrası(%20 KDV) kalan miktar ödenir.",
  ];

  
  final  List<String> cancellationAndRefund = [
    "Çark, oda ücreti ve diğer satın alımlar iade edilmez.",
    "Kendi isteğinizle ayrılırsanız ücret iadesi yapılmaz.",
    "Hile veya manipülasyon tespit edilirse hesap askıya alınır.",
  ];

  
  final  List<String> userResponsibilities = [
    "Bu kuralları kabul etmiş sayılırsınız.",
    "Etik kurallara uymak zorundasınız.",
    "Hile, dolandırıcılık yapılan hesaplar süresiz kapatılır.",
  ];

  
  final  List<String> updateRights = [
    "Bilbank, kurallarda önceden bildirim yapmadan değişiklik yapma hakkını saklı tutar.",
    "Güncellenen kurallar uygulamada ilan edildikten sonra geçerli olur.",
  ];

  
  final  List<String> supportAndContact = [
    "Soru, öneri veya destek için:",
    "Profil > Ayarlar > Sorun Bildir",
  ];
}
