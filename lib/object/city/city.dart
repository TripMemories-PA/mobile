import 'package:freezed_annotation/freezed_annotation.dart';

part 'city.freezed.dart';
part 'city.g.dart';

@Freezed()
class City with _$City {
  @JsonSerializable(explicitToJson: true)
  const factory City({
    required int id,
    required String name,
    required String zipCode,
    required int coverId,
  }) = _City;

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);
}
