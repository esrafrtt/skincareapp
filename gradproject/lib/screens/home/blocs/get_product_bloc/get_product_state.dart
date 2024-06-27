part of 'get_product_bloc.dart';

abstract class GetProductState extends Equatable {
  const GetProductState();

  @override
  List<Object> get props => [];
}

class GetProductInitial extends GetProductState {}

class GetProductLoading extends GetProductState {}

class GetProductSuccess extends GetProductState {
  final List<Product> products;

  const GetProductSuccess(this.products);

  @override
  List<Object> get props => [products];
}

class GetProductFailure extends GetProductState {
  final String error;

  const GetProductFailure(this.error);

  @override
  List<Object> get props => [error];
}
