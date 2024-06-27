part of 'get_product_bloc.dart';

abstract class GetProductEvent extends Equatable {
  const GetProductEvent();

  @override
  List<Object> get props => [];
}

class GetProduct extends GetProductEvent {
  final List<String> selectedAfterUseOptions;

  const GetProduct(this.selectedAfterUseOptions);

  @override
  List<Object> get props => [selectedAfterUseOptions];
}
