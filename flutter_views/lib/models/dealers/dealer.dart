import 'package:json_annotation/json_annotation.dart';

part 'dealer.g.dart';

@JsonSerializable(explicitToJson: true)
class Dealers {
  int? iD;
  String? name;
  String? nameAr;
  int? commNum;
  String? address;
  String? addressAr;

  List<DealersEmails>? dealers_emails;
  int? dealers_emails_count;

  List<DealersPhone>? dealers_phones;
  int? dealers_phones_count;

  List<DealersSocial>? dealers_social;
  int? dealers_social_count;

  Dealers();

  factory Dealers.fromJson(Map<String, dynamic> data) =>
      _$DealersFromJson(data);

  Map<String, dynamic> toJson() => {};
}

class DealersDetailsApstract {
  int? iD;
  int? DealerID;

  String? title;
  String? type;
  String? url;
  Dealers? dealers;

  DealersDetailsApstract();
}

@JsonSerializable(explicitToJson: true)

///dealers_emails
class DealersEmails extends DealersDetailsApstract {
  String? email;
  DealersEmails() : super();

  factory DealersEmails.fromJson(Map<String, dynamic> data) =>
      _$DealersEmailsFromJson(data);

  // Map<String, dynamic> toJson() => _$DealersEmailsToJson(this);
}

@JsonSerializable(explicitToJson: true)

///dealers_phones
class DealersPhone extends DealersDetailsApstract {
  String? phone;
  DealersPhone() : super();

  factory DealersPhone.fromJson(Map<String, dynamic> data) =>
      _$DealersPhoneFromJson(data);

  // Map<String, dynamic> toJson() => _$DealersPhoneToJson(this);
}

@JsonSerializable(explicitToJson: true)

///dealers_social
class DealersSocial extends DealersDetailsApstract {
  DealersSocial() : super();

  factory DealersSocial.fromJson(Map<String, dynamic> data) =>
      _$DealersSocialFromJson(data);

  // Map<String, dynamic> toJson() => _$DealersSocialToJson(this);
}
