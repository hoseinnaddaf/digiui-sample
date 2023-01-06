
class Slide {

  String _name  ;
  String _imageUrl ;

  Slide(this._name, this._imageUrl);

  String get imageUrl => _imageUrl;

  set imageUrl(String value) {
    _imageUrl = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }
}