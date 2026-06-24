import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';
import 'package:jara_vendor/screens/product_selection/controller/product_selection_controller.dart';
import 'package:jara_vendor/screens/product_selection/models/mdels.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import '../../widgets/status_bar.dart';
import '../../widgets/back_button.dart';

ProductSelectionController controller = Get.put(ProductSelectionController());

class ProductSelectionScreen extends StatefulWidget {
  const ProductSelectionScreen({super.key});

  @override
  State<ProductSelectionScreen> createState() => _ProductSelectionScreenState();
}

class _ProductSelectionScreenState extends State<ProductSelectionScreen> {
  RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );
  void _onrefresh() {
    controller.fetchCategories();
  }

  //List<bool> isSelectedIngredient = List.generate(controller.data[0]., generator)
  // final List<String> _products = [
  //   'Spices',
  //   'Protein',
  //   'Vegetables',
  //   'Cooking Oil',
  //   'Grains',
  //   'Tuber',
  //   'Fruit',
  //   'Drinks',
  //   'Beverage',
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onrefresh,
        child: SafeArea(
          child: Obx(() {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: controller.isLoading.value
                  ? Center(
                      child: CircularProgressIndicator(color: Colors.amber),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const StatusBar(),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const CustomBackButton(),
                            const SizedBox(width: 16),
                            const Text(
                              'What product do you sell',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Select what you sell below, and don\'t pick what you are not selling. you can pick more than one class.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // ElevatedButton(onPressed: (){
                        //   controller.fetchCategories();
                        // }, child: Text('fecth cats here')),
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: controller.data.length + 1,
                            itemBuilder: (context, index) {
                              if (index < controller.data.length) {
                                final product = controller.data[index];
                                final isSelected = controller.selectedProducts
                                    .contains(product.id);

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  child: _buildProductItem(
                                    product,
                                    isSelected,
                                    () {
                                      setState(() {
                                        if (isSelected) {
                                          controller.selectedProducts.remove(
                                            product.id,
                                          );
                                          controller.selectedProductName.remove(
                                            product.name,
                                          );
                                          if (controller.appendCount.value >
                                                  0 &&
                                              controller
                                                  .selectedProductNames
                                                  .value
                                                  .startsWith(product.name)) {
                                            controller
                                                .selectedProductNames
                                                .value = controller
                                                .selectedProductNames
                                                .value
                                                .substring(product.name.length);
                                            controller.appendCount.value--;
                                          }
                                        } else {
                                          controller.selectedProductName.add(
                                            product.name,
                                          );
                                          controller.selectedProducts.add(
                                            product.id,
                                          );
                                          controller
                                                  .selectedProductNames
                                                  .value +=
                                              product.name;
                                          controller.appendCount.value++;
                                        }
                                      });
                                    },
                                  ),
                                );
                              } else {
                                bool isSelected = false;
                                return _buildOthersItem(isSelected: isSelected);
                              }
                            },
                          ),
                        ),

                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: controller.selectedProducts.isNotEmpty
                              ? () {
                                  controller.saveCategory();
                                  // print(controller.selectedProductName.join(', '));
                                  // Navigator.pushNamed(Get.context!, '/shop-size');
                                  // print(controller.data.map((e){e.ingredients[0];}));
                                  // controller.fetchCategories();
                                  //   print(controller.selectedProducts);
                                  // controller.selectedProductNames.value = '';
                                }
                              : null,
                          child: const Text('Continue'),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildProductItem(Data product, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: AnimatedSize(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFFF9800).withAlpha(
                        26,
                      ) // Changed from withOpacity(0.1)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFFF9800)
                      : Colors.grey.shade300,
                  width: 1,
                ),
              ),
              child: Row(
                spacing: 5,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFFF9800)
                          : Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getIconForProduct(product.name),
                      color: isSelected ? Colors.white : Colors.grey.shade600,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    product.name.length > 25
                        ? '${product.name.substring(0, 23)}...'
                        : product.name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected
                          ? const Color(0xFFFF9800)
                          : Colors.black,
                    ),
                  ),
                  if (isSelected)
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Icon(Icons.check_circle, color: Color(0xFFFF9800)),
                    ),
                  Spacer(),
                  isSelected
                      ? SvgPicture.asset('assets/down.svg')
                      : SvgPicture.asset('assets/left.svg'),
                  //Icon(Icons.chevron_right),
                  SizedBox(width: 10),
                ],
              ),
            ),
            isSelected
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: product.ingredients.map((e) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        child: Column(
                          children: [
                            //  List<bool> selct = List.generate(product.products.length, (value)=> value),
                            Row(
                              children: [
                                Checkbox(
                                  value: isSelected,
                                  onChanged: (value) {},
                                ),
                                Text(' ${e.name}'),
                              ],
                            ),
                            //   Divider(),
                          ],
                        ),
                      );
                    }).toList(),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _buildOthersItem({bool isSelected = true}) {
    return InkWell(
      onTap: () {
        // Show dialog to add custom product
        setState(() {
          isSelected = !isSelected;
        });
        print('tapping');
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFFF9800).withAlpha(
                  26,
                ) // Changed from withOpacity(0.1)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color.fromARGB(255, 44, 34, 20)
                : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Color(0xFFFF9800), size: 24),
            ),
            const SizedBox(height: 12),
            const Text(
              'Others',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForProduct(String product) {
    switch (product) {
      case 'Spices':
        return Icons.spa;
      case 'Protein':
        return Icons.egg;
      case 'Vegetables':
        return Icons.eco;
      case 'Oil & Condiment Vendors':
        return Icons.water_drop;
      case 'Bakery and Grain Supply Vendors':
        return Icons.grain;
      case 'Tuber':
        return Icons.agriculture;
      case 'Fresh Produce Vendors':
        return Icons.apple;
      case 'Drinks':
        return Icons.local_drink;
      case 'Beverage':
        return Icons.coffee;
      default:
        return Icons.category;
    }
  }
}
