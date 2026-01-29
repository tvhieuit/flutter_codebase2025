import 'package:freezed_annotation/freezed_annotation.dart';

import '../annotations/annotations.dart';

part 'product_entity.freezed.dart';
part 'product_entity.g.dart';

/// Product entity representing a product in the domain layer.
@modelFreezed
sealed class ProductEntity with _$ProductEntity {
  const ProductEntity._();

  const factory ProductEntity({
    @Default(0) int id,
    @Default('') String name,
    @Default('') String description,
    @Default(0) @JsonKey(name: 'price_in_cents') int priceInCents,
    @Default('') String category,
    @JsonKey(name: 'image_url') String? imageUrl,
    @Default(0) @JsonKey(name: 'stock_quantity') int stockQuantity,
    @Default(true) @JsonKey(name: 'is_available') bool isAvailable,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _ProductEntity;

  factory ProductEntity.fromJson(Map<String, dynamic> json) =>
      _$ProductEntityFromJson(json);

  /// Gets the price as a formatted double
  double get priceAsDouble => priceInCents / 100;

  /// Checks if the product is in stock
  bool get isInStock => stockQuantity > 0 && isAvailable;

  /// Checks if the product is low on stock (less than 10)
  bool get isLowStock => stockQuantity > 0 && stockQuantity < 10;

  /// Checks if this is an empty/default product
  bool get isEmpty => id == 0 && name.isEmpty;
}
