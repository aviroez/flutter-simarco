import 'dart:convert';

class ImagePivot{
  int imageable_id;
  int image_id;
  String imageable_type;
  int sequence;
  String code;

  ImagePivot(this.imageable_id, this.image_id, this.imageable_type, this.sequence, this.code);

  factory ImagePivot.fromMap(Map<String, dynamic> data) {
    if (data != null) {
      return getImagePivot(data);
    }
    return null;
  }

  factory ImagePivot.fromJson(String string) {
    Map<String, dynamic> data = jsonDecode(string);
    if (data != null){
      return getImagePivot(data);
    }
    return null;
  }

  static getImagePivot(Map<String, dynamic> data){
    return ImagePivot(
        data['imageable_id'],
        data['image_id'],
        data['imageable_type'],
        data['sequence'],
        data['code'],
    );
  }

  Map toJson() => {
    'imageable_id': imageable_id,
    'image_id': image_id,
    'imageable_type': imageable_type,
    'sequence': sequence,
    'code': code,
  };
}