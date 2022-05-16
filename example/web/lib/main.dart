import 'package:discordcdn/discordcdn.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Discord as a CDN',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Discord as a CDN'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController botTokenController = TextEditingController();

  final TextEditingController channelIdController = TextEditingController();

  final TextEditingController imageUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: botTokenController,
              decoration: InputDecoration(
                labelText: 'Bot Token',
              ),
            ),
            TextField(
              controller: channelIdController,
              decoration: InputDecoration(
                labelText: 'Channel ID',
              ),
            ),
            TextField(
              controller: imageUrlController,
              decoration: InputDecoration(
                labelText: 'Image to store URL',
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _uploadImageToDiscord,
        tooltip: 'Upload image to Discord',
        child: Icon(Icons.send),
      ),
    );
  }

  void _uploadImageToDiscord() async {
    try {
      final discordClient = withBotToken(botTokenController.text);

      final image =
          await http.Client().readBytes(Uri.parse(imageUrlController.text));

      final uploadedImageUri = await discordClient.uploadImage(
        image: DiscordUploadableImage(
          bytes: image,
          format: 'jpeg',
          name: 'my_image',
        ),
        channelId: channelIdController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            uploadedImageUri.path,
          ),
        ),
      );
    } on Object catch (error, stacktrace) {
      print(stacktrace);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString(),
          ),
        ),
      );
    }
  }
}
