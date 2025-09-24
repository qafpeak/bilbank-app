
import 'package:url_launcher/url_launcher.dart';

class SocialMediaHelper {
  // Instagram profil aç
  static Future<void> openProfile(String username) async {
    final appUri = Uri.parse('instagram://user?username=$username');
    final webUri = Uri.parse('https://instagram.com/$username');

    // Uygulamada açmayı dene, olmazsa web'e düş
    if (await canLaunchUrl(appUri)) {
      await launchUrl(appUri, mode: LaunchMode.externalApplication);
    } else {
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    }
  }

  // Belirli bir gönderi aç (kısa kod veya tam URL ile)
  static Future<void> openPost(String shortCodeOrUrl) async {
    // shortCode ör: CxYz123Abc
    final isUrl = shortCodeOrUrl.startsWith('http');
    final webUri = isUrl
        ? Uri.parse(shortCodeOrUrl)
        : Uri.parse('https://www.instagram.com/p/$shortCodeOrUrl/');

    // App şeması (post için evrensel garanti yok, profil üzerinden daha stabil)
    // Bu yüzden doğrudan web URL'sine düşmek daha güvenilir:
    await launchUrl(webUri, mode: LaunchMode.externalApplication);
  }

  // DM aç (kullanıcı adına hızlı DM)
  static Future<void> openDm(String username) async {
    // App şeması çoğu cihazda çalışır:
    final appUri = Uri.parse('instagram://direct/new?username=$username');
    final webUri = Uri.parse('https://instagram.com/direct/t/$username');

    if (await canLaunchUrl(appUri)) {
      await launchUrl(appUri, mode: LaunchMode.externalApplication);
    } else {
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    }
  }

  // Hashtag sayfası
  static Future<void> openHashtag(String tag) async {
    final appUri = Uri.parse('instagram://tag?name=$tag');
    final webUri = Uri.parse('https://instagram.com/explore/tags/$tag/');

    if (await canLaunchUrl(appUri)) {
      await launchUrl(appUri, mode: LaunchMode.externalApplication);
    } else {
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    }
  }
}
