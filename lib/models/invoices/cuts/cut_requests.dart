import 'package:flutter_view_controller/models/va_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cut_requests.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class CutRequest extends ViewAbstract<CutRequest>{


}