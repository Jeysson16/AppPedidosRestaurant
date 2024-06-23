import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant_app/app/global/preferencias/pref_usuarios.dart';
import 'package:restaurant_app/servicios_firebase/firebase_service_producto.dart';

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
          _isLoading = false;
        });
      } catch (e) {
        print('Error al cargar categorías: $e');
      }
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
        print('URL de imagen principal: $_mainImageUrl');

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
        print('URLs de imágenes adicionales: $_additionalImageUrls');

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
        print('Producto registrado en Firestore');

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
                  children: [
                    TextField(
                      controller: _nombreController,
                      decoration:
                          const InputDecoration(labelText: 'Nombre del producto'),
                    ),
                    TextField(
                      controller: _descripcionController,
                      decoration: const InputDecoration(labelText: 'Descripción'),
                    ),
                    TextField(
                      controller: _precioController,
                      decoration: const InputDecoration(labelText: 'Precio'),
                      keyboardType: TextInputType.number,
                    ),
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
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _pickMainImage,
                          child: const Text('Seleccionar Imagen Principal'),
                        ),
                        const SizedBox(width: 20),
                        _mainImageBytes != null
                            ? Image.memory(
                                _mainImageBytes!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              )
                            : _mainImageFile != null
                                ? Image.file(
                                    _mainImageFile!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  )
                                : Container(),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _pickAdditionalImage,
                          child: const Text('Seleccionar Imágenes Adicionales'),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: SizedBox(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: kIsWeb
                                  ? _additionalImageBytes.length
                                  : _additionalImageFiles.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: kIsWeb
                                      ? Image.memory(
                                          _additionalImageBytes[index],
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.file(
                                          _additionalImageFiles[index],
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
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
}
