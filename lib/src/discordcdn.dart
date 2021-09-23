import 'package:discordcdn/discordcdn.dart';
import 'package:http/http.dart' as http;

DiscordClient withBotToken(final String token) {
  return BotDiscordClient(
    token: token,
    httpClient: http.Client(),
  );
}
