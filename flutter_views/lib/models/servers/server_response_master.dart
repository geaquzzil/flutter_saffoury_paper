import 'package:json_annotation/json_annotation.dart';

import 'server_response.dart';

part 'server_response_master.g.dart';

@JsonSerializable(explicitToJson: true)
class ServerResponseMaster {
  ServerResponse serverResponse;
  ServerResponseMaster(this.serverResponse);

  factory ServerResponseMaster.fromJson(Map<String, dynamic> data) =>
      _$ServerResponseMasterFromJson(data);

  Map<String, dynamic> toJson() => _$ServerResponseMasterToJson(this);
}
