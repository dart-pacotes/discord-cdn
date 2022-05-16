import 'dart:convert';

import 'package:discordcdn/discordcdn.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockHttpClient extends Mock implements Client {}

class MockStreamedResponse extends Mock implements StreamedResponse {}

class MockByteStream extends Mock implements ByteStream {}

class FakeRequest extends Fake implements Request {}

const fakeBotToken = 'token';

const fakeChannelId = 'channel id';

const fakeImageUrl = 'https://discord.com';

final fakeUri = Uri.base;

const fakeDiscordUploadableImage = DiscordUploadableImage(
  bytes: [],
  format: '',
  name: '',
);

void main() {
  setUpAll(
    () {
      registerFallbackValue(FakeRequest());
    },
  );

  group(
    'BotDiscordClient',
    () {
      group(
        'uploadImage',
        () {
          test(
            'returns url present in response attachements, if response status is 200',
            () async {
              final mockHttpClient = MockHttpClient();
              final mockedStreamedResponse = MockStreamedResponse();
              final mockByteStream = MockByteStream();

              final responseJsonString = jsonEncode(
                {
                  'attachments': [
                    {
                      'url': fakeImageUrl,
                    }
                  ],
                },
              );

              when(() => mockByteStream.bytesToString()).thenAnswer(
                (_) => Future.value(responseJsonString),
              );

              when(() => mockedStreamedResponse.statusCode).thenReturn(200);
              when(() => mockedStreamedResponse.stream).thenAnswer(
                (_) => mockByteStream,
              );

              when(
                () => mockHttpClient.send(any()),
              ).thenAnswer(
                (_) => Future.value(mockedStreamedResponse),
              );

              final discordClient = BotDiscordClient(
                httpClient: mockHttpClient,
                token: fakeBotToken,
              );

              final result = await discordClient.uploadImage(
                image: fakeDiscordUploadableImage,
                channelId: fakeChannelId,
              );

              expect(
                result.getOrElse(() => fakeUri),
                Uri.parse(fakeImageUrl),
              );
            },
          );

          test(
            'returns invalid bot token, if response status is 401',
            () async {
              final mockHttpClient = MockHttpClient();
              final mockedStreamedResponse = MockStreamedResponse();

              when(() => mockedStreamedResponse.statusCode).thenReturn(401);

              when(
                () => mockHttpClient.send(any()),
              ).thenAnswer(
                (_) => Future.value(mockedStreamedResponse),
              );

              final discordClient = BotDiscordClient(
                httpClient: mockHttpClient,
                token: fakeBotToken,
              );

              final result = await discordClient.uploadImage(
                image: fakeDiscordUploadableImage,
                channelId: fakeChannelId,
              );

              final leftHand = result.fold(
                (l) => l,
                (r) => fakeUri,
              );

              expect(
                leftHand,
                isA<InvalidBotToken>(),
              );
            },
          );

          test(
            'returns invalid bot token, if response status is 403',
            () async {
              final mockHttpClient = MockHttpClient();
              final mockedStreamedResponse = MockStreamedResponse();

              when(() => mockedStreamedResponse.statusCode).thenReturn(403);

              when(
                () => mockHttpClient.send(any()),
              ).thenAnswer(
                (_) => Future.value(mockedStreamedResponse),
              );

              final discordClient = BotDiscordClient(
                httpClient: mockHttpClient,
                token: fakeBotToken,
              );

              final result = await discordClient.uploadImage(
                image: fakeDiscordUploadableImage,
                channelId: fakeChannelId,
              );

              final leftHand = result.fold(
                (l) => l,
                (r) => fakeUri,
              );

              expect(
                leftHand,
                isA<InvalidBotToken>(),
              );
            },
          );

          test(
            'returns channel not found, if response status is 404',
            () async {
              final mockHttpClient = MockHttpClient();
              final mockedStreamedResponse = MockStreamedResponse();

              when(() => mockedStreamedResponse.statusCode).thenReturn(404);

              when(
                () => mockHttpClient.send(any()),
              ).thenAnswer(
                (_) => Future.value(mockedStreamedResponse),
              );

              final discordClient = BotDiscordClient(
                httpClient: mockHttpClient,
                token: fakeBotToken,
              );

              final result = await discordClient.uploadImage(
                image: fakeDiscordUploadableImage,
                channelId: fakeChannelId,
              );

              final leftHand = result.fold(
                (l) => l,
                (r) => fakeUri,
              );

              expect(
                leftHand,
                isA<ChannelNotFound>(),
              );
            },
          );

          test(
            'returns unknown error, if previous conditions did not match',
            () async {
              final mockHttpClient = MockHttpClient();
              final mockedStreamedResponse = MockStreamedResponse();
              final mockByteStream = MockByteStream();

              final responseString = '';

              when(() => mockByteStream.bytesToString()).thenAnswer(
                (_) => Future.value(responseString),
              );

              when(() => mockedStreamedResponse.statusCode).thenReturn(405);
              when(() => mockedStreamedResponse.stream).thenAnswer(
                (_) => mockByteStream,
              );

              when(
                () => mockHttpClient.send(any()),
              ).thenAnswer(
                (_) => Future.value(mockedStreamedResponse),
              );

              final discordClient = BotDiscordClient(
                httpClient: mockHttpClient,
                token: fakeBotToken,
              );

              final result = await discordClient.uploadImage(
                image: fakeDiscordUploadableImage,
                channelId: fakeChannelId,
              );

              final leftHand = result.fold(
                (l) => l,
                (r) => fakeUri,
              );

              expect(
                leftHand,
                isA<UnknownError>(),
              );
            },
          );
        },
      );
    },
  );
}
