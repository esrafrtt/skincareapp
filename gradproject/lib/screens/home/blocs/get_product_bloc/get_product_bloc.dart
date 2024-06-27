import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:product_repository/product_repository.dart';

part 'get_product_event.dart';
part 'get_product_state.dart';

class GetProductBloc extends Bloc<GetProductEvent, GetProductState> {
  final ProductRepo _productRepo;

  GetProductBloc(this._productRepo) : super(GetProductInitial()) {
    on<GetProduct>((event, emit) async {
      emit(GetProductLoading());
      try {
        List<Product> products = await _productRepo.getProducts();
        if (products.isNotEmpty) {
          emit(GetProductSuccess(products));
        } else {
          emit(const GetProductFailure("No products available."));
        }
      } catch (e) {
        emit(GetProductFailure("Error occurred: ${e.toString()}"));
      }
    });
  }
}
