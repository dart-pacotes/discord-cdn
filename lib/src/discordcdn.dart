import 'package:discordcdn/discordcdn.dart';
import 'package:http/http.dart' as http;

///
/// Returns an instance of [BotDiscordClient] which
/// takes on a token that authorizes the bot for requests.
///
DiscordClient withBotToken(final String token) {
  return BotDiscordClient(
    token: token,
    httpClient: http.Client(),
  );
}
