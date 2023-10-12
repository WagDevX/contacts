class ContactsModel {
  List<Results> results = [];

  ContactsModel(this.results);

  ContactsModel.vazio();

  ContactsModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results.add(Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['results'] = results.map((v) => v.toJson()).toList();
    return data;
  }
}

class Results {
  String objectId = "";
  String name = "";
  String phoneNumer = "";
  String countryCode = "";
  bool favorite = false;
  String cidade = "";
  String instagram = "";
  String linkedn = "";
  String photo = "";
  String createdAt = "";
  String updatedAt = "";
  String email = "";

  Results(
      this.objectId,
      this.name,
      this.phoneNumer,
      this.countryCode,
      this.favorite,
      this.cidade,
      this.instagram,
      this.linkedn,
      this.photo,
      this.createdAt,
      this.updatedAt,
      this.email);

  Results.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'];
    name = json['Name'];
    phoneNumer = json['phone_numer'];
    countryCode = json['country_code'];
    favorite = json['favorite'];
    cidade = json['cidade'];
    instagram = json['instagram'];
    linkedn = json['linkedn'];
    photo = json['photo'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
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
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['email'] = email;
    return data;
  }
}
