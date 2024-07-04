import 'package:flutter/material.dart';
import 'package:restaurant_app/features/productos/data/models/seleccion.dart';
import 'package:restaurant_app/features/productos/dominio/entidades/producto.dart';
import 'package:restaurant_app/app/global/view/components/my_button_rounded.dart';

class ProductosDetalles extends StatefulWidget {
  const ProductosDetalles({
    super.key,
    required this.product,
    required this.imageProvider,
    required this.onProductoAgregado,
  });

  final Producto product;
  final ImageProvider imageProvider;
  final Function(
    List<Seleccion> selecciones, // Change to a list of selections
  ) onProductoAgregado;

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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Hero(
                      tag:
                          'list_${widget.product.id}_details_${selecciones.length}',
                      child: Image(
                        image: widget.imageProvider,
                        fit: BoxFit.fitWidth,
                        height: MediaQuery.of(context).size.height * 0.26,
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
                  Column(
                    children: List.generate(selecciones.length, (index) {
                      return _buildSelectionCard(index);
                    }),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: S/. ${calcularPrecioTotal().toStringAsFixed(2)}',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      IconButton(
                        onPressed: _addNewSelection,
                        icon: Icon(Icons.add,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 80),
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
                child: MyButtonRounded(
                  onTap: () => _agregarCarrito(context),
                  text: "Agregar al carrito",
                  icono: const Icon(
                    Icons.add_shopping_cart_outlined,
                    color: Colors.white,
                  ),
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

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Pedido ${index + 1}',
                    style: Theme.of(context).textTheme.headlineSmall),
                IconButton(
                  onPressed: () => _removeSelection(index),
                  icon: Icon(Icons.remove_circle,
                      color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildCantidadSelector(index),
            const SizedBox(height: 10),
            if (widget.product.tamanos!.isNotEmpty) _buildTamanoSelector(index),
            const SizedBox(height: 10),
            if (widget.product.variantes != null &&
                widget.product.variantes!.isNotEmpty)
              _buildVarianteSelector(index),
            const SizedBox(height: 10),
            if (widget.product.agregados != null &&
                widget.product.agregados!.isNotEmpty)
              _buildAgregadosSelector(index),
            const SizedBox(height: 10),
            _buildObservacionTextField(index),
          ],
        ),
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
            Text(seleccion.cantidad.toString(),
                style: TextStyle(color: Theme.of(context).colorScheme.primary)),
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
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      ),
      initiallyExpanded: true,
      subtitle: Text(
        'Selecciona como deseas tu ${widget.product.nombre}',
        style: TextStyle(
          color: Theme.of(context).colorScheme.inverseSurface,
          fontSize: 12,
        ),
      ),
      collapsedIconColor: Theme.of(context).colorScheme.primary,
      leading: Icon(Icons.food_bank_outlined,
          color: Theme.of(context).colorScheme.primary),
      children: List.generate(widget.product.variantes!.length, (i) {
        return GestureDetector(
          onTap: () {
            setState(() {
              seleccion.selectedVarianteIndex = i;
            });
          },
          child: ListTile(
            title: Text(widget.product.variantes![i].nombre),
            leading: Radio<int>(
              value: i,
              groupValue: seleccion.selectedVarianteIndex,
              onChanged: (int? value) {
                setState(() {
                  seleccion.selectedVarianteIndex = value!;
                });
              },
            ),
          ),
        );
      }),
    );
  }

  Widget _buildAgregadosSelector(int index) {
    final seleccion = selecciones[index];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Agregados',
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: List.generate(widget.product.agregados!.length, (i) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: seleccion.selectedAgregados[i] > 0
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.inverseSurface,
                ),
                borderRadius: BorderRadius.circular(20),
                color: seleccion.selectedAgregados[i] > 0
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                    : null,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (seleccion.selectedAgregados[i] > 0)
                            seleccion.selectedAgregados[i]--;
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
                          seleccion.selectedAgregados[i]++;
                        });
                      },
                      icon: Icon(Icons.add,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.product.agregados![i].nombre,
                      style: TextStyle(
                        color: seleccion.selectedAgregados[i] > 0
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.inverseSurface,
                        fontWeight: FontWeight.bold,
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
}
