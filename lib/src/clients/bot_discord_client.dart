import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../models/models.dart';
import 'discord_client.dart';

class BotDiscordClient extends DiscordClient {
  final String token;

  final http.Client _httpClient;

  BotDiscordClient({
    required final this.token,
    required final http.Client httpClient,
  }) : _httpClient = httpClient;

  @override
  Future<Either<RequestError, Uri>> uploadImage({
    required DiscordUploadableImage image,
    required String channelId,
  }) async {
    final endpointUrl = apiUri.resolve('api/channels/${channelId}/messages');

    final request = http.MultipartRequest('POST', endpointUrl);

    request.headers['Authorization'] = 'Bot ${token}';

    request.files.add(
      http.MultipartFile.fromBytes(
        'files[0]',
        image.bytes,
        filename: '${image.name}.${image.format}',
      ),
    );

    try {
      final response = await _httpClient.send(request);

      if (response.statusCode == 200) {
        final body = jsonDecode(
          await response.stream.bytesToString(),
        );

        return Right(
          Uri.parse(
            body['attachments'][0]['url'],
          ),
        );
      } else if (response.statusCode == 403) {
        return Left(InvalidBotToken());
      } else if (response.statusCode == 404) {
        return Left(ChannelNotFound());
      } else {
        return Left(
          UnknownError(
            reason: await response.stream.bytesToString(),
            stackTrace: StackTrace.current,
          ),
        );
      }
    } on Object catch (error, stackTrace) {
      return Left(
        NetworkError(
          reason: error.toString(),
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
