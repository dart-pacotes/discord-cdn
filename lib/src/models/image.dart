///
/// Specifies an uploadable image to Discord
///
class DiscordUploadableImage {
  final String name;

  final String format;

  final List<int> bytes;

  const DiscordUploadableImage({
    required final this.bytes,
    required final this.format,
    required final this.name,
  });
}
