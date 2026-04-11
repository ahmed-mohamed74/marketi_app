import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketi_app/core/common/widgets/back_button_widget.dart';
import 'package:marketi_app/core/routing/app_routes.dart';
import 'package:marketi_app/core/themes/colors.dart';
import 'package:marketi_app/core/themes/styles.dart';
import 'package:marketi_app/features/home_feature/presentation/cubit/cart_cubits/add_product_cubit/add_product_cubit.dart';
import 'package:marketi_app/features/home_feature/presentation/cubit/home_cubit/home_cubit.dart';
import 'package:marketi_app/features/home_feature/presentation/widgets/product_card_widget.dart';
import 'package:marketi_app/features/home_feature/presentation/widgets/search_section_widget.dart';

class BrandPage extends StatefulWidget {
  final String? brandName;
  const BrandPage({super.key, required this.brandName});

  @override
  State<BrandPage> createState() => _BrandPageState();
}

class _BrandPageState extends State<BrandPage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getProductsByBrand(widget.brandName ?? 'Essence');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButtonWidget(onPressed: () => context.pop()),
        leadingWidth: 64,
        title: Text(
          widget.brandName ?? 'Essence',
          style: AppTextStyles.appBarTitle1,
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(5.0),
            child: Icon(Icons.shopping_cart_outlined, size: 30),
          ),
        ],
      ),
      body: BlocListener<AddProductCubit, AddProductState>(
        listener: (context, state) {
          if (state is AddCartProductSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state.productsByBrandStatus == RequestStatus.loading) {
              return const SizedBox(
                height: 60,
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (state.productsByBrandStatus == RequestStatus.error) {
              return SizedBox(
                height: 60,
                child: Center(
                  child: Text(
                    state.productsByBrandError ?? 'Something went wrong',
                  ),
                ),
              );
            } else if (state.productsByBrand.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SearchSectionWidget(products: state.productsByBrand),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 590,
                      child: ListView.builder(
                        itemCount: state.productsByBrand.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  context.push(
                                    AppRoutes.productPage,
                                    extra: state.productsByBrand[index],
                                  );
                                },
                                child: ProductCard(
                                  image:
                                      state
                                          .productsByBrand[index]
                                          .images
                                          ?.first ??
                                      '',
                                  price:
                                      state.productsByBrand[index].price
                                          ?.toString() ??
                                      '',
                                  rate:
                                      state.productsByBrand[index].rating
                                          ?.toString() ??
                                      '',
                                  name:
                                      state.productsByBrand[index].title ?? '',
                                  id: state.productsByBrand[index].id
                                      .toString(),
                                ),
                              ),
                              Divider(
                                color: AppColors.greyScaleColor.withValues(
                                  alpha: 0.2,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox(
              height: 60,
              child: Center(child: Text('No items found')),
            );
          },
        ),
      ),
    );
  }
}
