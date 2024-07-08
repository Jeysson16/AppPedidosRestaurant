import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:restaurant_app/features/productos/data/models/seleccion.dart';
import 'package:restaurant_app/features/productos/dominio/entidades/producto.dart';
import 'package:restaurant_app/app/global/view/components/my_button_rounded.dart';
import 'package:restaurant_app/features/productos/presentacion/components/vista_galeria.dart';

class ProductosDetalles extends StatefulWidget {
  const ProductosDetalles({
    super.key,
    required this.product,
    required this.imageProvider,
    required this.onProductoAgregado,
  });

  final Producto product;
  final ImageProvider imageProvider;
  final Function(List<Seleccion> selecciones) onProductoAgregado;

  @override
  _ProductosDetallesState createState() => _ProductosDetallesState();
}

class _ProductosDetallesState extends State<ProductosDetalles> {
  List<Seleccion> selecciones = [];
  String heroTag = '';

  @override
  void initState() {
    super.initState();
    _addNewSelection(); // Initialize with one selection
  }

  void _addNewSelection() {
    setState(() {
      selecciones.add(
        Seleccion(
          cantidad: 1,
          selectedTamanoIndex: 0,
          selectedVarianteIndex: 0,
          selectedAgregados:
              List<int>.filled(widget.product.agregados?.length ?? 0, 0),
          observacion: '',
        ),
      );
    });
  }

  void _removeSelection(int index) {
    setState(() {
      if (selecciones.length > 1) {
        selecciones.removeAt(index);
      }
    });
  }

  void _updateSelection(int index, Seleccion updatedSelection) {
    setState(() {
      selecciones[index] = updatedSelection;
    });
  }

  double calcularPrecioTotal() {
    double total = 0.0;
    for (var seleccion in selecciones) {
      total += widget.product.precio * seleccion.cantidad;

      if (widget.product.variantes != null &&
          widget.product.variantes!.isNotEmpty) {
        total +=
            widget.product.variantes![seleccion.selectedVarianteIndex].precio *
                seleccion.cantidad;
      }

      if (widget.product.tamanos != null &&
          widget.product.tamanos!.isNotEmpty) {
        total += widget.product.tamanos![seleccion.selectedTamanoIndex].precio *
            seleccion.cantidad;
      }

      for (int i = 0; i < seleccion.selectedAgregados.length; i++) {
        total += widget.product.agregados![i].precio *
            seleccion.selectedAgregados[i];
      }

      // Aplicar promoción si existe
      if (widget.product.promocion != null && widget.product.promocion! > 0) {
        total -= widget.product.promocion! * seleccion.cantidad;
      }
    }

    return total;
  }

  void _agregarCarrito(BuildContext context) {
    setState(() {
      heroTag = 'details';
    });
    widget.onProductoAgregado(selecciones);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:
            BackButton(color: Theme.of(context).colorScheme.inverseSurface),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onLongPress: () {
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return ImageGalleryDialog(
                            images: widget.product.galeria!,
                            initialIndex: 0,
                            tag:
                                'list_${widget.product.id}_details_${selecciones.length}',
                          );
                        },
                      );
                    },
                    child: Hero(
                      tag:
                          'list_${widget.product.id}_details_${selecciones.length}',
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.26,
                        child: PageView.builder(
                          itemCount: widget.product.galeria!.length,
                          itemBuilder: (context, index) {
                            return Image.network(
                              widget.product.galeria![index],
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.product.nombre,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.inverseSurface,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.product.descripcion,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.inverseSurface,
                        ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Divider(
                            color: Theme.of(context).colorScheme.primary,
                            thickness: 3,
                            endIndent: 10,
                            indent: 10,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Lista de tus Pedidos',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge
                                      ?.copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inverseSurface,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: List.generate(selecciones.length, (index) {
                      return _buildSelectionCard(index);
                    }),
                  ),
                  Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Divider(
                            color: Theme.of(context).colorScheme.primary,
                            thickness: 3,
                            endIndent: 10,
                            indent: 10,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
                                onPressed: _addNewSelection,
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inverseSurface
                                          .withOpacity(0.4),
                                    ),
                                  ),
                                  backgroundColor:
                                      Theme.of(context).colorScheme.surface,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      'Agregar otro pedido',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inverseSurface,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Icon(
                                      Icons.add_circle_outline,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inverseSurface,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 80,
        color: Theme.of(context).colorScheme.surface,
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.favorite_border,
                    color: Theme.of(context).colorScheme.inverseSurface,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: MyButtonRounded(
                        onTap: () => _agregarCarrito(context),
                        text: "Agregar al carrito",
                        precio: calcularPrecioTotal().toStringAsFixed(2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionCard(int index) {
    final seleccion = selecciones[index];
    final subtotal = calcularSubtotal(seleccion);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color:
                Theme.of(context).colorScheme.inverseSurface.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCantidadSelector(index),
              const Spacer(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (widget.product.promocion != null &&
                        widget.product.promocion! > 0) ...[
                      Text(
                        'S/. ${widget.product.precio.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.lineThrough,
                              fontSize:
                                  16, // Tamaño reducido para el precio original
                            ),
                      ),
                      const SizedBox(height: 5), // Espacio entre los textos
                      Text(
                        'S/. ${(subtotal).toStringAsFixed(2)}',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize:
                                  26, // Tamaño normal o resaltado para el precio promocional
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ] else
                      Text(
                        'S/. ${subtotal.toStringAsFixed(2)}',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize:
                                  26, // Tamaño normal para el subtotal sin promoción
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  _removeSelection(index);
                },
                icon: Icon(
                  Icons.remove_circle_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          if (widget.product.tamanos!.isNotEmpty) ...[
            _buildTamanoSelector(index),
            const SizedBox(height: 10),
          ],
          if (widget.product.variantes != null &&
              widget.product.variantes!.isNotEmpty) ...[
            _buildVarianteSelector(index),
            const SizedBox(height: 10),
          ],
          if (widget.product.agregados != null &&
              widget.product.agregados!.isNotEmpty) ...[
            _buildAgregadosSelector(index),
            const SizedBox(height: 10),
          ],
          _buildObservacionTextField(index),
        ],
      ),
    );
  }

  Widget _buildCantidadSelector(int index) {
    final seleccion = selecciones[index];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                if (seleccion.cantidad > 1) {
                  setState(() {
                    seleccion.cantidad--;
                  });
                }
              },
              icon: Icon(Icons.remove,
                  color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(seleccion.cantidad.toString(),
                style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.inverseSurface)),
            const SizedBox(
              width: 5,
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  seleccion.cantidad++;
                });
              },
              icon:
                  Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTamanoSelector(int index) {
    final seleccion = selecciones[index];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tamaño',
            style: TextStyle(color: Theme.of(context).colorScheme.primary)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: List.generate(widget.product.tamanos!.length, (i) {
            return ChoiceChip(
              label: Text(widget.product.tamanos![i].nombre),
              selected: seleccion.selectedTamanoIndex == i,
              onSelected: (bool selected) {
                setState(() {
                  seleccion.selectedTamanoIndex =
                      selected ? i : seleccion.selectedTamanoIndex;
                });
              },
              selectedColor: Theme.of(context).colorScheme.primary,
            );
          }),
        ),
      ],
    );
  }

  Widget _buildVarianteSelector(int index) {
    final seleccion = selecciones[index];

    return ExpansionTile(
      title: Text(
        'Variante',
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
      initiallyExpanded: true,
      subtitle: Text(
        'Selecciona como deseas tu ${widget.product.nombre}',
        style: TextStyle(
          color: Theme.of(context).colorScheme.inverseSurface,
          fontSize: 14,
        ),
      ),
      collapsedIconColor: Theme.of(context).colorScheme.primary,
      shape: Border(
        bottom: BorderSide(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ),
      leading: Icon(Icons.food_bank_outlined,
          color: Theme.of(context).colorScheme.primary),
      tilePadding: const EdgeInsets.symmetric(horizontal: 15.0),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: List.generate(widget.product.variantes!.length, (i) {
              return Column(
                children: [
                  ListTile(
                    title: Text(widget.product.variantes![i].nombre),
                    leading: Radio<int>(
                      value: i,
                      groupValue: seleccion.selectedVarianteIndex,
                      onChanged: (int? value) {
                        setState(() {
                          seleccion.selectedVarianteIndex = value!;
                        });
                      },
                      activeColor: Theme.of(context).colorScheme.primary,
                    ),
                    onTap: () {
                      setState(() {
                        seleccion.selectedVarianteIndex = i;
                      });
                    },
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildAgregadosSelector(int index) {
    final seleccion = selecciones[index];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'Agrega las porciones que desees',
            style: TextStyle(
              color: Theme.of(context).colorScheme.inverseSurface,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          alignment: WrapAlignment.center,
          children: List.generate(widget.product.agregados!.length, (i) {
            return SizedBox(
              width: MediaQuery.of(context).size.width *
                  0.9, // Adjust width to center the items
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (seleccion.selectedAgregados[i] > 0) {
                              seleccion.selectedAgregados[i]--;
                            }
                          });
                        },
                        icon: Icon(Icons.remove,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      Text(
                        '${seleccion.selectedAgregados[i]}',
                        style: TextStyle(
                          color: seleccion.selectedAgregados[i] > 0
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.inverseSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (seleccion.selectedAgregados[i] < 5) {
                              seleccion.selectedAgregados[i]++;
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.surface,
                                  content: Text(
                                    'Solo se pueden agregar 5 porciones por platillo',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inverseSurface,
                                    ),
                                  ),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          });
                        },
                        icon: Icon(Icons.add,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.product.agregados![i].nombre,
                          style: TextStyle(
                            color: seleccion.selectedAgregados[i] > 0
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.inverseSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (seleccion.selectedAgregados[i] > 0)
                        Text(
                          ' (${(widget.product.agregados![i].precio * seleccion.selectedAgregados[i]).toStringAsFixed(2)})',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildObservacionTextField(int index) {
    final seleccion = selecciones[index];

    return TextField(
      style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface),
      decoration: InputDecoration(
        labelText: 'Observación',
        labelStyle:
            TextStyle(color: Theme.of(context).colorScheme.inverseSurface),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      onChanged: (value) {
        setState(() {
          seleccion.observacion = value;
        });
      },
    );
  }

  double calcularSubtotal(Seleccion seleccion) {
    double subtotal = widget.product.precio * seleccion.cantidad;

    if (widget.product.variantes != null &&
        widget.product.variantes!.isNotEmpty) {
      subtotal +=
          widget.product.variantes![seleccion.selectedVarianteIndex].precio *
              seleccion.cantidad;
    }

    if (widget.product.tamanos != null && widget.product.tamanos!.isNotEmpty) {
      subtotal +=
          widget.product.tamanos![seleccion.selectedTamanoIndex].precio *
              seleccion.cantidad;
    }

    for (int i = 0; i < seleccion.selectedAgregados.length; i++) {
      subtotal +=
          widget.product.agregados![i].precio * seleccion.selectedAgregados[i];
    }
    // Aplicar promoción si existe
    if (widget.product.promocion != null && widget.product.promocion! > 0) {
      subtotal -= widget.product.promocion! * seleccion.cantidad;
    }

    return subtotal;
  }
}
