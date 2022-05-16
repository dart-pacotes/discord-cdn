import 'dart:io';

import 'package:discordcdn/discordcdn.dart';
import 'package:example/images.dart';

void main() async {
  final botToken = '<bot_token>';

  final channelId = '<channel_id>';

  // Create discord client that interacts as a bot
  final discordClient = withBotToken(botToken);

  // Upload image
  final uploadImageResult = await discordClient.uploadImage(
    image: DiscordUploadableImage(
      bytes: dart_logo_bytes,
      format: 'jpeg',
      name: 'my super cool image',
    ),
    channelId: channelId,
  );

  // Tadaaaam!
  print(uploadImageResult);

  exit(0);
}
