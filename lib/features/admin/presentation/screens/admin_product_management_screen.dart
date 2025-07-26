import 'package:ashleystreats/services/appwrite/appwrite_service.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../../products/data/product_repository.dart';
import '../../../products/data/models/product_isar.dart';

class AdminProductManagementScreen extends StatefulWidget {
  const AdminProductManagementScreen({Key? key}) : super(key: key);

  @override
  State<AdminProductManagementScreen> createState() =>
      _AdminProductManagementScreenState();
}

class _AdminProductManagementScreenState
    extends State<AdminProductManagementScreen> {
  final ProductRepository _repo = ProductRepository();
  late Future<List<ProductIsar>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _repo.getAllProducts();
  }

  void _refresh() {
    setState(() {
      _productsFuture = _repo.getAllProducts();
    });
  }

  void _showProductForm({ProductIsar? product}) {
    showDialog(
      context: context,
      builder: (context) => _ProductFormDialog(
        product: product,
        onSaved: (p) async {
          await _repo.addOrUpdateProduct(p);
          _refresh();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Products')),
      body: FutureBuilder<List<ProductIsar>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products found.'));
          }
          final products = snapshot.data!;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                leading: product.imageUrl.isNotEmpty
                    ? Image.network(
                        product.imageUrl,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.cake),
                title: Text(product.name),
                subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showProductForm(product: product),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await _repo.deleteProduct(product.id);
                        _refresh();
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProductForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ProductFormDialog extends StatefulWidget {
  final ProductIsar? product;
  final Future<void> Function(ProductIsar) onSaved;
  const _ProductFormDialog({Key? key, this.product, required this.onSaved})
    : super(key: key);

  @override
  State<_ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<_ProductFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _priceController;
  late TextEditingController _imageUrlController;
  String? _uploadError;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _descController = TextEditingController(
      text: widget.product?.description ?? '',
    );
    _priceController = TextEditingController(
      text: widget.product?.price.toString() ?? '',
    );
    _imageUrlController = TextEditingController(
      text: widget.product?.imageUrl ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage() async {
    setState(() {
      _isUploading = true;
      _uploadError = null;
    });
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;
        final fileId = DateTime.now().millisecondsSinceEpoch.toString();
        await AppwriteService().uploadFile(filePath: filePath, fileId: fileId);
        final url =
            'https://6883449200037fa86c79.appwrite.global/v1/storage/buckets/${AppwriteService.mediaBucketId}/files/$fileId/view?project=6883449200037fa86c79';
        setState(() {
          _imageUrlController.text = url;
        });
      }
    } catch (e) {
      setState(() {
        _uploadError = 'Image upload failed: $e';
      });
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;
    final product = widget.product ?? ProductIsar();
    product.name = _nameController.text;
    product.description = _descController.text;
    product.price = double.tryParse(_priceController.text) ?? 0.0;
    product.imageUrl = _imageUrlController.text;
    await widget.onSaved(product);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => v == null || v.isEmpty ? 'Enter name' : null,
              ),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter description' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Enter price' : null,
              ),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'Image URL'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter image URL' : null,
              ),
              const SizedBox(height: 8),
              if (_imageUrlController.text.isNotEmpty)
                Image.network(
                  _imageUrlController.text,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              if (_isUploading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: CircularProgressIndicator(),
                ),
              ElevatedButton(
                onPressed: _isUploading ? null : _pickAndUploadImage,
                child: const Text('Upload Image'),
              ),
              if (_uploadError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _uploadError!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }
}
