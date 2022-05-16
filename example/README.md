# example

There are two examples you can use to try `discordcdn`. The easiest one is yet to arrive, a Flutter web application that prompts you the needed credentials (bot token and channel id) and the URL of an image to upload. The other example is a standalone Dart application, found in the `cli` folder.

```dart
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
```