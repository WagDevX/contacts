class ContactModel {
  String objectId = "";
  String? name = "";
  String? phoneNumer = "";
  String? countryCode = "";
  bool? favorite = false;
  String? cidade = "";
  String? instagram = "";
  String? linkedn = "";
  String? photo = "";
  String? email = "";

  ContactModel(
      this.objectId,
      this.name,
      this.phoneNumer,
      this.countryCode,
      this.favorite,
      this.cidade,
      this.instagram,
      this.linkedn,
      this.photo,
      this.email);
  ContactModel.create(
      this.name,
      this.phoneNumer,
      this.countryCode,
      this.favorite,
      this.cidade,
      this.instagram,
      this.linkedn,
      this.photo,
      this.email);

  ContactModel.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'];
    name = json['Name'];
    phoneNumer = json['phone_numer'];
    countryCode = json['country_code'];
    favorite = json['favorite'];
    cidade = json['cidade'];
    instagram = json['instagram'];
    linkedn = json['linkedn'];
    photo = json['photo'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['objectId'] = objectId;
    data['Name'] = name;
    data['phone_numer'] = phoneNumer;
    data['country_code'] = countryCode;
    data['favorite'] = favorite;
    data['cidade'] = cidade;
    data['instagram'] = instagram;
    data['linkedn'] = linkedn;
    data['photo'] = photo;
    data['email'] = email;
    return data;
  }

  Map<String, dynamic> toJsonUpdate() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Name'] = name;
    data['phone_numer'] = phoneNumer;
    data['country_code'] = countryCode;
    data['favorite'] = favorite;
    data['cidade'] = cidade;
    data['instagram'] = instagram;
    data['linkedn'] = linkedn;
    data['photo'] = photo;
    data['email'] = email;
    return data;
  }
}
