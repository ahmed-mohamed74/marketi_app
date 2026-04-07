import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketi_app/core/common/widgets/back_button_widget.dart';
import 'package:marketi_app/core/themes/colors.dart';
import 'package:marketi_app/core/themes/styles.dart';
import 'package:marketi_app/features/home_feature/presentation/cubit/home_cubit.dart';
import 'package:marketi_app/features/home_feature/presentation/widgets/search_section_widget.dart';
import 'package:marketi_app/features/home_feature/data/models/product_model.dart';

class AllProductsPage extends StatefulWidget {
  final String appBarTitle;
  const AllProductsPage({super.key, required this.appBarTitle});

  @override
  State<AllProductsPage> createState() => _AllProductsPageState();
}

class _AllProductsPageState extends State<AllProductsPage> {
  final ScrollController _scrollController = ScrollController();
  late HomeCubit homeCubit;

  @override
  void initState() {
    super.initState();
    homeCubit = context.read<HomeCubit>();
    homeCubit.getAllProducts(); // fetch first page

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        // fetch more when close to bottom
        if (homeCubit.state.allProductsStatus != RequestStatus.loading) {
          homeCubit.getAllProducts(loadMore: true);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButtonWidget(onPressed: () => context.pop()),
        leadingWidth: 64,
        title: Text(widget.appBarTitle, style: AppTextStyles.appBarTitle1),
        actions: const [
          Padding(
            padding: EdgeInsets.all(5.0),
            child: CircleAvatar(
              backgroundColor: AppColors.lightBlueColor,
              foregroundColor: AppColors.navyColor,
              child: Icon(Icons.person_2_outlined, size: 30),
            ),
          ),
        ],
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final items = state.allProducts;

          if (state.allProductsStatus == RequestStatus.loading &&
              items.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.allProductsStatus == RequestStatus.error && items.isEmpty) {
            return Center(child: Text(state.allProductsError ?? 'Error'));
          }

          return Column(
            children: [
              // Search
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchSectionWidget(products: items),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: GridView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.86,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount:
                      items.length +
                      (state.allProductsStatus == RequestStatus.loading
                          ? 2
                          : 0),
                  itemBuilder: (context, index) {
                    if (index >= items.length) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final product = items[index];
                    return ProductCardWidget(product: product);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Extracted product card widget
class ProductCardWidget extends StatelessWidget {
  final ProductModel product;
  const ProductCardWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.lightBlueColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: product.images?.isNotEmpty == true
                        ? Image.network(
                            product.images!.first,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/images/product2_image.png',
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.contain,
                          ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 15,
                      child: Icon(
                        Icons.favorite_border_outlined,
                        color: AppColors.darkBlueColor,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Text(
                  '${product.price ?? 499} LE',
                  style: AppTextStyles.bodySmall,
                ),
                const Spacer(),
                const Icon(Icons.star_border, size: 14),
                const SizedBox(width: 2),
                Text(
                  '${product.rating ?? 4.9}',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
            Text(
              product.title ?? 'Smart Watch',
              style: AppTextStyles.bodySmall,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: double.infinity,
              height: 30,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: AppColors.primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'Add',
                  style: AppTextStyles.heading3.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
