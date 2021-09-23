import 'dart:convert';

import '../models/models.dart';
import 'discord_client.dart';
import 'package:http/http.dart' as http;

class BotDiscordClient extends DiscordClient {
  final String token;

  final http.Client _httpClient;

  BotDiscordClient({
    required final this.token,
    required final http.Client httpClient,
  }) : _httpClient = httpClient;

  @override
  Future<Uri> uploadImage({
    required DiscordUploadableImage image,
    required String channelId,
  }) async {
    final url = apiUrl.resolve('/channels/${channelId}/messages');

    final request = http.MultipartRequest('POST', url);

    request.headers['Authorization'] = 'Bot ${token}';

    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        image.bytes,
        filename: '${image.name}.${image.format}',
      ),
    );

    final response = await _httpClient.send(request);

    if (response.statusCode == 200) {
      final body = jsonDecode(
        await response.stream.bytesToString(),
      );

      return Uri.parse(
        body['attachments'][0]['url'],
      );
    } else {
      throw response;
    }
  }
}
