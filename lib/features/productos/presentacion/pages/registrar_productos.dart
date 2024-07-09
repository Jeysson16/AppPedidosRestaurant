import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant_app/app/global/preferencias/pref_usuarios.dart';
import 'package:restaurant_app/features/productos/data/service/firebase_service_producto.dart';

class RegistrarProductoPage extends StatefulWidget {
  const RegistrarProductoPage({super.key});

  @override
  _RegistrarProductoPageState createState() => _RegistrarProductoPageState();
}

class _RegistrarProductoPageState extends State<RegistrarProductoPage> {
  final ProductoService _productoService = ProductoService();

  List<DocumentSnapshot> _categorias = [];
  File? _mainImageFile;
  final List<File> _additionalImageFiles = [];
  String? _selectedCategoria;
  bool _isLoading = true;

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();

  Uint8List? _mainImageBytes;
  final List<Uint8List> _additionalImageBytes = [];
  String? _mainImageUrl;
  List<String> _additionalImageUrls = [];

  @override
  void initState() {
    super.initState();
    _loadCategorias();
  }

  Future<void> _loadCategorias() async {
    PreferenciasUsuario preferenciasUsuario = PreferenciasUsuario();
    final sucursalId = preferenciasUsuario.sucursalId;

    if (sucursalId != null) {
      try {
        final categorias = await _productoService.getCategorias(sucursalId);
        setState(() {
          _categorias = categorias;
          _isLoading = false; // Marca la carga como completada
        });
      } catch (e) {
        print('Error al cargar categorías: $e');
        setState(() {
          _isLoading =
              false; // Marca la carga como completada aunque haya error
        });
      }
    } else {
      setState(() {
        _isLoading =
            false; // Marca la carga como completada si no hay sucursalId
      });
    }
  }

  Future<void> _pickMainImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        final mainImageBytes = await pickedFile.readAsBytes();
        setState(() {
          _mainImageBytes = mainImageBytes;
        });
      } else {
        setState(() {
          _mainImageFile = File(pickedFile.path);
        });
      }
    }
  }

  Future<void> _pickAdditionalImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        final additionalImageBytes = await pickedFile.readAsBytes();
        setState(() {
          _additionalImageBytes.add(additionalImageBytes);
        });
      } else {
        setState(() {
          _additionalImageFiles.add(File(pickedFile.path));
        });
      }
    }
  }

  Future<void> _registerProduct() async {
    PreferenciasUsuario preferenciasUsuario = PreferenciasUsuario();
    final sucursalId = preferenciasUsuario.sucursalId;

    if (sucursalId != null &&
        _selectedCategoria != null &&
        (_mainImageBytes != null || _mainImageFile != null)) {
      try {
        print('Registrando producto...');

        // Subir imagen principal a Firebase Storage y obtener la URL
        if (_mainImageBytes != null) {
          _mainImageUrl = await _productoService.uploadImageBytes(
              _mainImageBytes!,
              sucursalId,
              _nombreController.text,
              'principal');
        } else if (_mainImageFile != null) {
          _mainImageUrl = await _productoService.uploadImageFile(
              _mainImageFile!, sucursalId, _nombreController.text, 'principal');
        }

        // Subir imágenes adicionales a Firebase Storage y obtener las URLs
        List<String> additionalImageUrls = [];
        if (kIsWeb) {
          for (var imageBytes in _additionalImageBytes) {
            final imageUrl = await _productoService.uploadImageBytes(
                imageBytes,
                sucursalId,
                _nombreController.text,
                'additional_image_${additionalImageUrls.length}');
            additionalImageUrls.add(imageUrl);
          }
        } else {
          for (var imageFile in _additionalImageFiles) {
            final imageUrl = await _productoService.uploadImageFile(
                imageFile,
                sucursalId,
                _nombreController.text,
                'additional_image_${additionalImageUrls.length}');
            additionalImageUrls.add(imageUrl);
          }
        }
        _additionalImageUrls = additionalImageUrls;
        // Agregar producto a Firestore
        await _productoService.addProducto(
          sucursalId: sucursalId,
          categoriaId: _selectedCategoria!,
          nombre: _nombreController.text,
          descripcion: _descripcionController.text,
          precio: double.parse(_precioController.text),
          imagenPrincipal: _mainImageUrl!,
          galeria: _additionalImageUrls,
        );
        // Limpiar el formulario
        _nombreController.clear();
        _descripcionController.clear();
        _precioController.clear();
        setState(() {
          _mainImageBytes = null;
          _mainImageFile = null;
          _additionalImageBytes.clear();
          _additionalImageFiles.clear();
          _selectedCategoria = null;
        });

        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Producto registrado con éxito')),
        );
      } catch (e) {
        print('Error al registrar producto: $e');
      }
    } else {
      print('Datos faltantes para registrar el producto');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Producto'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _nombreController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del producto',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _descripcionController,
                      decoration: const InputDecoration(
                        labelText: 'Descripción',
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _precioController,
                      decoration: const InputDecoration(
                        labelText: 'Precio',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    DropdownButton<String>(
                      hint: const Text('Selecciona una categoría'),
                      value: _selectedCategoria,
                      items: _categorias.map((categoria) {
                        return DropdownMenuItem<String>(
                          value: categoria.id,
                          child: Text(categoria['nombre']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategoria = value;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    _buildImageSelectionRow(
                      label: 'Imagen Principal',
                      onPressed: _pickMainImage,
                      imageBytes: _mainImageBytes,
                      imageFile: _mainImageFile,
                    ),
                    const SizedBox(height: 24),
                    _buildImageSelectionRow(
                      label: 'Imágenes Adicionales',
                      onPressed: _pickAdditionalImage,
                      imageBytesList: _additionalImageBytes,
                      imageFilesList: _additionalImageFiles,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _registerProduct,
                      child: const Text('Registrar Producto'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildImageSelectionRow({
    required String label,
    required VoidCallback onPressed,
    List<Uint8List>? imageBytesList,
    List<File>? imageFilesList,
    Uint8List? imageBytes,
    File? imageFile,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(
                Icons.add_photo_alternate,
                size: 48,
                color: Colors.grey[600],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                if (imageBytes != null) _buildImagePreview(imageBytes),
                if (imageFile != null) _buildImageFilePreview(imageFile),
                if (imageBytesList != null)
                  ...imageBytesList.map((bytes) => _buildImagePreview(bytes)),
                if (imageFilesList != null)
                  ...imageFilesList.map((file) => _buildImageFilePreview(file)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePreview(Uint8List bytes) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Image.memory(
        bytes,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildImageFilePreview(File file) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Image.file(
        file,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      ),
    );
  }
}
