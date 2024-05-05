import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../constants/constants.dart';
import '../../controller/product_controller.dart';
import '../../db/db.dart';
import '../../model/product.dart';

class CreateProductPage extends StatefulWidget {
  final Function reload;

  const CreateProductPage({Key? key, required this.reload}) : super(key: key);

  @override
  _CreateProductPageState createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  
  late TextEditingController _imageController;
  late TextEditingController _nameController;
  late TextEditingController _groupsController;
  late TextEditingController _quantityController;
  late TextEditingController _priceSellController;
  late TextEditingController _priceBuyController;
  late TextEditingController _codBarrasController; // Novo controller
  ProductController controller = ProductController();
  final db = DB();
  final ImagePicker _picker = ImagePicker();
  XFile? imageFile;

  @override
  void initState() {
    super.initState();
    _imageController = TextEditingController();
    _nameController = TextEditingController();
    _groupsController = TextEditingController();
    _quantityController = TextEditingController();
    _priceSellController = TextEditingController();
    _priceBuyController = TextEditingController();
    _codBarrasController =
        TextEditingController(); // Inicialização do novo controller
  }

  @override
  void dispose() {
    _imageController.dispose();
    _nameController.dispose();
    _groupsController.dispose();
    _quantityController.dispose();
    _priceSellController.dispose();
    _priceBuyController.dispose();
    _codBarrasController.dispose(); // Dispose do novo controller
    super.dispose();
  }

  Future<void> _scanBarcode() async {
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          'COLOR_CODE', 'CANCEL_BUTTON_TEXT', true, ScanMode.DEFAULT);
      setState(() {
        _codBarrasController.text = barcodeScanRes;
      });
    } catch (e) {
      print('Erro ao escanear código de barras: $e');
    }
  }

  Future<void> _pickImageGalery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final File file = File(image.path);
      imageFile = image;

      setState(() {
        _imageController.text =
            image.path; // Usar image.path em vez de imageFile.toString()
      });
    }
  }

  Future<void> _pickImageCamera(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      final File file = File(image.path);
      // Salvar a imagem no armazenamento local
      final appDir = await getApplicationDocumentsDirectory();
      final fileName =
          image.path.split('/').last; // Extrair o nome do arquivo manualmente
      final savedImage = await file.copy('${appDir.path}/$fileName');

      imageFile = XFile(savedImage.path); // Corrigindo o tipo de arquivo aqui
      setState(() {
        _imageController.text = savedImage.path;
      });
    }
  }

  Widget _buildSelectedImage() {
    if (imageFile == null) {
      return SizedBox
          .shrink(); // Retorna um widget vazio se nenhuma imagem for selecionada
    } else {
      return Image.file(File(imageFile!.path));
    }
  }

  Future<void> _showImageSourceDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Escolher origem da imagem'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  _pickImageGalery();
                },
                icon: Icon(Icons.image_search_sharp),
                label: Text('Galeria'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  _pickImageCamera(ImageSource.camera);
                },
                icon: Icon(Icons.camera_alt),
                label: Text('Câmera'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Product'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 12.0),
              _buildSelectedImage(),
              SizedBox(height: 24.0),
              IconButton(
                  onPressed: _showImageSourceDialog,
                  icon: Icon(Icons.image_search_sharp)),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do produto';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12.0),
              TextFormField(
                controller: _groupsController,
                decoration: InputDecoration(
                  labelText: 'Grupo',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o grupo do produto';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12.0),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(
                  labelText: 'Quantidade',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a quantidade do produto';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12.0),
              TextFormField(
                controller: _priceSellController,
                decoration: InputDecoration(
                  labelText: 'Preço Venda',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o preço de venda do produto';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12.0),
              TextFormField(
                controller: _priceBuyController,
                decoration: InputDecoration(
                  labelText: 'Preço Compra',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o preço de compra do produto';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12.0),
              TextFormField(
                controller:
                    _codBarrasController, // Ligação do controller ao campo de texto
                decoration: InputDecoration(
                  labelText: 'Código de Barras', // Rótulo do campo de texto
                ),
                
              ),
              SizedBox(height: 24.0),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          const uuid = Uuid();
                          final newProduct = Product(
                            id: uuid.v4(),
                            localId: uuid.v4(),
                            image: _imageController.text,
                            name: _nameController.text,
                            groups: _groupsController.text,
                            quantity: int.parse(_quantityController.text),
                            priceSell: _priceSellController.text,
                            priceBuy: _priceBuyController.text,
                            codBarras: _codBarrasController
                                .text, // Atribuição do código de barras ao novo produto
                          );
                          await db.addProduct(newProduct);
                          Get.back();
                          widget.reload();
                          print(newProduct.toString());
                        }
                      },
                      child: Text('SALVAR'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
