import '../models/models.dart';

///
/// [DiscordClient] describes a general interface to interact with Discord
///
abstract class DiscordClient {
  ///
  /// Uploads an image to a Discord channel, specified in [channelId] parameter.
  ///
  Future<Uri> uploadImage({
    required DiscordUploadableImage image,
    required String channelId,
  });

  Uri get apiUrl => Uri.parse('https://discordapp.com/api');
}
