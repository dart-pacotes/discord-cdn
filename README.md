# discord-cdn.dart

Use Discord as a CDN.

Upload images to Discord and serve them using Discord blazing fast CDN.

## How to use

Right now you can upload images using the Bot HTTP REST API, which is implemented in the `BotDiscordClient` class. To use it in your app, it is as simple as:

```dart
final botToken = '<bot_token>';
final channelId = '<channel_id>';

final discordClient = withBotToken(botToken);

final uploadImageResult = await discordClient.uploadImage(
    image: DiscordUploadableImage(
        bytes: dart_logo_bytes,
        format: 'jpeg',
        name: 'my super cool image',
    ),
    channelId: channelId,
);
```

## Why use discord-cdn.dart?

The main use case that inspired the development of this package, is to provide developers (mostly indie) a way to store and retrieve for free and in a fast manner.

## Side Effects

Powered by Dart null sound + [`dartz`](https://pub.dev/packages/dartz) monads, this package is free of null issues and side effects. This is to prevent the throw of any exception that may not be known and caught by developers, and to make sure that information is consistent by contract.

The `uploadImage` returns an `Either` monad that either returns the the URL of the image available on Discord CDN on the right hand, or `ResponseError` instance on the left hand that is typed to several possible Discord API errors (see available errors [here](https://pub.dev/documentation/discordcdn/latest/discordcdn/RequestError-class.html)).

---

### Bugs and Contributions

Found any bug (including typos) in the package? Do you have any suggestion or feature to include for future releases? Please create an issue via GitHub in order to track each contribution. Also, pull requests are very welcome!

### Disclaimer

This is not an official library/SDK implemented by the Discord team, but rather a developer implementation that uses it.