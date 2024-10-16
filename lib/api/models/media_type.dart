enum MediaType {
  textPost,
  image,
  video,
  carouselAlbum,
  audio,
}

extension MediaTypeExtension on MediaType {
  String get receiveName {
    switch (this) {
      case MediaType.textPost:
        return 'TEXT_POST';
      case MediaType.image:
        return 'IMAGE';
      case MediaType.video:
        return 'VIDEO';
      case MediaType.carouselAlbum:
        return 'CAROUSEL_ALBUM';
      case MediaType.audio:
        return 'AUDIO';
    }
  }

   String get postName {
    switch (this) {
      case MediaType.textPost:
        return 'TEXT';
      case MediaType.image:
        return 'IMAGE';
      case MediaType.video:
        return 'VIDEO';
      case MediaType.carouselAlbum:
        return 'CAROUSEL';
      case MediaType.audio:
        return 'AUDIO';
    }
  }
}

MediaType mediaTypeFromString(String type) {
  switch (type) {
    case 'TEXT_POST':
      return MediaType.textPost;
    case 'IMAGE':
      return MediaType.image;
    case 'VIDEO':
      return MediaType.video;
    case 'CAROUSEL_ALBUM':
      return MediaType.carouselAlbum;
    case 'AUDIO':
      return MediaType.audio;
    default:
      return MediaType.textPost;
  }
}
