import 'package:flutter/material.dart';
import 'package:restaurant_app/features/productos/dominio/entidades/producto.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/features/pedidos/presentacion/bloc/pedido/presentacion_pedidos_bloc.dart';
import 'package:restaurant_app/app/global/view/components/my_button_rounded.dart';

class ProductosDetalles extends StatefulWidget {
  const ProductosDetalles({super.key, required this.product, required this.imageProvider, required this.onProductoAgregado});

  final Producto product;
  final ImageProvider imageProvider;
  final VoidCallback onProductoAgregado;

  @override
  _ProductosDetallesState createState() => _ProductosDetallesState();
}

class _ProductosDetallesState extends State<ProductosDetalles> {
  int selectedSizeIndex = 0;
  int selectedVarianteIndex = 0;
  List<int> selectedAgregados = [];
  String heroTag = '';
  int cantidad = 1;

  void _agregarCarrito(BuildContext context) {
    final bloc = Provider.of<PresentacionPedidosBloc>(context, listen: false);
    bloc.addProducto(
      producto: widget.product,
      cantidad: cantidad,
      observacion: '',
      selectedSizeIndex: selectedSizeIndex,
      selectedVarianteIndex: selectedVarianteIndex,
      selectedAgregados: selectedAgregados,
    );
    setState(() {
      heroTag = 'details';
    });
    widget.onProductoAgregado();
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    if (widget.product.agregados != null) {
      selectedAgregados = List<int>.filled(widget.product.agregados!.length, 0);
    }
  }

  double calcularPrecioTotal() {
    double total = widget.product.precio * cantidad;

    if (widget.product.variantes != null && widget.product.variantes!.isNotEmpty) {
      total += widget.product.variantes![selectedVarianteIndex].precio * cantidad;
    }

    if (widget.product.tamanos != null && widget.product.tamanos!.isNotEmpty) {
      total += widget.product.tamanos![selectedSizeIndex].precio * cantidad;
    }

    for (int i = 0; i < selectedAgregados.length; i++) {
      total += widget.product.agregados![i].precio * selectedAgregados[i];
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Theme.of(context).colorScheme.inverseSurface),
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
                      tag: 'list_${widget.product.id}_$heroTag',
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
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (cantidad > 1) cantidad--;
                          });
                        },
                        icon: Icon(Icons.remove, color: Theme.of(context).colorScheme.primary),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        cantidad.toString(),
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            cantidad++;
                          });
                        },
                        icon: Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
                      ),
                      const Spacer(),
                      Text(
                        'S/. ${calcularPrecioTotal().toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Acerca de ${widget.product.nombre}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).colorScheme.inverseSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                  ),
                  const SizedBox(height: 15),
                  Text(widget.product.descripcion),
                  const SizedBox(height: 20),
                  if (widget.product.tamanos!.isNotEmpty) ...[
                    Text(
                      '¿De qué tamaño lo deseas?',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Theme.of(context).colorScheme.inverseSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(widget.product.tamanos!.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: ChoiceChip(
                              label: Text(widget.product.tamanos![index].nombre),
                              selected: selectedSizeIndex == index,
                              onSelected: (bool selected) {
                                setState(() {
                                  selectedSizeIndex = selected ? index : selectedSizeIndex;
                                });
                              },
                              selectedColor: Theme.of(context).colorScheme.primary,
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  if (widget.product.variantes != null && widget.product.variantes!.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    ExpansionTile(
                      title: Text(
                        'Escoge como la quieres',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      initiallyExpanded: true,
                      subtitle: Text(
                        'Selecciona como deseas tus ${widget.product.nombre}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inverseSurface,
                          fontSize: 12,
                        ),
                      ),
                      collapsedIconColor: Theme.of(context).colorScheme.primary,
                      leading: Icon(Icons.food_bank_outlined, color: Theme.of(context).colorScheme.primary),
                      children: List.generate(widget.product.variantes!.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedVarianteIndex = index;
                            });
                          },
                          child: ListTile(
                            title: Text(widget.product.variantes![index].nombre),
                            leading: Radio<int>(
                              value: index,
                              groupValue: selectedVarianteIndex,
                              onChanged: (int? value) {
                                setState(() {
                                  selectedVarianteIndex = value!;
                                });
                              },
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                  const SizedBox(height: 10),
                  if (widget.product.agregados != null && widget.product.agregados!.isNotEmpty) ...[
                    Text(
                      'Agrega la porción que deseas a tu ${widget.product.nombre}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Theme.of(context).colorScheme.inverseSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: List.generate(widget.product.agregados!.length, (index) {
                        String agregadoNombre = widget.product.agregados![index].nombre;
                        double precio = widget.product.agregados![index].precio;
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: selectedAgregados[index] > 0
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.inverseSurface,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            color: selectedAgregados[index] > 0
                                ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                                : null,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (selectedAgregados[index] > 0) selectedAgregados[index]--;
                                    });
                                  },
                                  icon: Icon(Icons.remove, color: Theme.of(context).colorScheme.primary),
                                ),
                                Text(
                                  '${selectedAgregados[index]}',
                                  style: TextStyle(
                                    color: selectedAgregados[index] > 0
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context).colorScheme.inverseSurface,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedAgregados[index]++;
                                    });
                                  },
                                  icon: Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  agregadoNombre,
                                  style: TextStyle(
                                    color: selectedAgregados[index] > 0
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context).colorScheme.inverseSurface,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (selectedAgregados[index] > 0)
                                  Text(
                                    ' (${(precio * selectedAgregados[index]).toStringAsFixed(2)})',
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
}
