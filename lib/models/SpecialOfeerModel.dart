class SpecialOfferModel{
  String _product_name ;
  int _price ;
  int _off_price ;
  int _off_percent ;
  String _imageUrl ;

  SpecialOfferModel(this._product_name, this._price, this._off_price,
      this._off_percent, this._imageUrl);

  String get imageUrl => _imageUrl;

  set imageUrl(String value) {
    _imageUrl = value;
  }

  int get off_percent => _off_percent;

  set off_percent(int value) {
    _off_percent = value;
  }

  int get off_price => _off_price;

  set off_price(int value) {
    _off_price = value;
  }

  int get price => _price;

  set price(int value) {
    _price = value;
  }

  String get product_name => _product_name;

  set product_name(String value) {
    _product_name = value;
  }
}