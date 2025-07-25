import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../services/local_db/isar_service.dart';
import '../data/product_model.dart';

class AdminProductEditScreen extends StatefulWidget {
  final ProductModel? product;
  const AdminProductEditScreen({Key? key, this.product}) : super(key: key);

  @override
  State<AdminProductEditScreen> createState() => _AdminProductEditScreenState();
}

class _AdminProductEditScreenState extends State<AdminProductEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descController;
  late TextEditingController _imageController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _priceController = TextEditingController(
      text: widget.product?.price.toString() ?? '',
    );
    _descController = TextEditingController(
      text: widget.product?.description ?? '',
    );
    _imageController = TextEditingController(text: widget.product?.image ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      final product = ProductModel.full(
        id: widget.product?.id ?? 0,
        name: _nameController.text,
        price: double.tryParse(_priceController.text) ?? 0.0,
        description: _descController.text,
        image: _imageController.text,
      );
      await IsarService().addProduct(product);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.product == null ? 'Product added!' : 'Product updated!',
            ),
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
        backgroundColor: AppColors.primary,
      ),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Enter product name'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || double.tryParse(value) == null
                    ? 'Enter valid price'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter description' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(
                  labelText: 'Image (asset path or URL)',
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Enter image path or URL'
                    : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.background,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: _saveProduct,
                  child: Text(
                    widget.product == null ? 'Add Product' : 'Update Product',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
