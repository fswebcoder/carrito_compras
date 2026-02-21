import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductEvent {
  const LoadProducts();
}

class RefreshProducts extends ProductEvent {
  const RefreshProducts();
}

class FilterByCategory extends ProductEvent {
  final String? category;

  const FilterByCategory(this.category);

  @override
  List<Object?> get props => [category];
}
