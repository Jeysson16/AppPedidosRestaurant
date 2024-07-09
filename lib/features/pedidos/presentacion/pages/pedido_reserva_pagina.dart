import 'dart:convert';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:restaurant_app/app/global/preferencias/pref_usuarios.dart';
import 'package:restaurant_app/app/global/view/components/my_button_rounded.dart';
import 'package:restaurant_app/features/pedidos/data/repositorios/pedido_repostorio.dart';
import 'package:restaurant_app/features/pedidos/dominio/entidades/detalle.dart';
import 'package:restaurant_app/features/pedidos/dominio/entidades/pedido.dart';
import 'package:restaurant_app/features/pedidos/presentacion/bloc/pedido/presentacion_pedidos_bloc.dart';
import 'package:restaurant_app/features/pedidos/presentacion/components/decoracion_ticket_pedido.dart';
import 'package:restaurant_app/features/pedidos/presentacion/pages/confirmacion_pedido.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PedidoReservaPagina extends StatefulWidget {
  final PresentacionPedidosBloc bloc;
  const PedidoReservaPagina({
    super.key,
    required this.bloc,
  });

  @override
  State<PedidoReservaPagina> createState() => _PedidoReservaPaginaState();
}

class _PedidoReservaPaginaState extends State<PedidoReservaPagina> {
  DateTime selectedDate = DateTime.now();
  bool showTimePicker = false;
  TimeOfDay selectedTime = TimeOfDay.now();
  @override
  void initState() {
    super.initState();
    // Inicializa la configuración regional
    initializeDateFormatting('es_ES', null).then((_) {
      setState(() {
        // Esto asegura que la fecha se renderice correctamente después de la inicialización
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final pedidoRepository = FirebasePedidoRepository();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.1, // Ajusta el tamaño según tus necesidades
              child: _buildMonthsList(),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.08, // Ajusta el tamaño según tus necesidades
              child: _buildDaysList(),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.2, // Ajusta el tamaño según tus necesidades
              child: _buildTimeSelector(),
            ),
            const SizedBox(
              height: 10,
            ),
            _buildPedido(),
            const SizedBox(
              height: 30,
            ),
            _buildDetallesPedido(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.08,
          child: MyButtonRounded(
            onTap: () async {
              DateTime fechaHoraSeleccionada = DateTime(
                selectedDate.year,
                selectedDate.month,
                selectedDate.day,
                selectedTime.hour + 1,
                selectedTime.minute,
              );
              final prefs = await SharedPreferences.getInstance();
              final idSucursal = prefs.getString('sucursalId') ?? '';
              final idUsuario = prefs.getString('usuarioDni');
              String descripcion =
                  'Pedido creado como reserva para el $fechaHoraSeleccionada';

              // Calcular detalles del pedido
              List<DetallePedido> detallesPedido =
                  widget.bloc.carrito.map((item) {
                final double descuento = (item.producto.promocion ?? 0) *
                    item.cantidad.toDouble(); // Calcular descuento
                DetallePedido detalle = DetallePedido(
                  cantidad: item.cantidad,
                  producto: item.producto,
                  observaciones: item.observaciones.join(', '),
                  descripcion: item.obtenerDescripcion(),
                  precioUnitario: item.producto.precio,
                  estado: 'Sin Atención',
                  descuento: descuento,
                );
                return detalle;
              }).toList();

              // Crear el pedido
              Pedido pedido = Pedido(
                descripcion: descripcion,
                precio: widget.bloc.totalCarritoPrecio(),
                horaInicioServicio: fechaHoraSeleccionada,
                esDelivery: false,
                sucursalId: idSucursal,
                detalles: detallesPedido,
                fechaReserva: fechaHoraSeleccionada,
              );

              // Llamar al servicio para enviar el pedido
              await pedidoRepository.crearPedidoUsuario(pedido, idUsuario!);

              // Mostrar el mensaje de éxito
              // ignore: use_build_context_synchronously

              // Limpiar el carrito de compras en el bloc
              widget.bloc.carrito.clear();
              widget.bloc
                  .changeToNormal(); // Cambiar el estado a normal después de realizar el pedido

              Navigator.push(
                // ignore: use_build_context_synchronously
                context,
                MaterialPageRoute(
                  builder: (context) => const FaceIDView(),
                ),
              );
            },
            text: "Confirmar",
            precio: '',
          ),
        ),
      ),
    );
  }

  Widget _buildPedido() {
    final preferencias =
        PreferenciasUsuario(); // Obtener instancia de PreferenciasUsuario
    DateTime fechaHoraSeleccionada = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour + 1,
      selectedTime.minute,
    );
    // Obtener el nombre de la sucursal y aplicar transformaciones
    String sucursalNombre = preferencias.sucursalNombre ?? '';
    sucursalNombre = sucursalNombre.replaceAll('Sucursal ', '');
    sucursalNombre = sucursalNombre.trim();
    return SizedBox(
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(22),
                    topRight: Radius.circular(22)),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        'D Gilberth',
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      const Spacer(),
                      const ComidaContainer(),
                      Expanded(
                          child: Stack(
                        children: [
                          Center(
                            child: Icon(
                              Icons.fastfood_rounded,
                              color:
                                  Theme.of(context).colorScheme.inverseSurface,
                            ),
                          ),
                          SizedBox(
                              height: 20,
                              child: Flex(
                                  direction: Axis.horizontal,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: List.generate(
                                      (MediaQuery.of(context).size.width / 55)
                                          .floor(),
                                      (index) => SizedBox(
                                            width: 2,
                                            height: 1,
                                            child: DecoratedBox(
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .inverseSurface)),
                                          )))),
                        ],
                      )),
                      const ComidaContainer(),
                      const Spacer(),
                      Text(
                        '  S/. ${widget.bloc.totalCarritoPrecio()}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.inverseSurface,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: 100,
                          child: Text(
                            sucursalNombre,
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inverseSurface
                                    .withOpacity(0.8)),
                          )),
                      Text(
                        ' ${selectedTime.hour + 1}H ${selectedTime.minute}M',
                        style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.inverseSurface),
                      ),
                      Text(
                        '                 Items: ${widget.bloc.totalCarritoElementos()}',
                        style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(context)
                                .colorScheme
                                .inverseSurface
                                .withOpacity(0.8)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              color: Theme.of(context).colorScheme.primary,
              child: Row(
                children: [
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ))),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: List.generate(
                          (MediaQuery.of(context).size.width / 15).floor(),
                          (index) => SizedBox(
                              width: 5,
                              height: 1,
                              child: DecoratedBox(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surface)))),
                    ),
                  )),
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ))),
                  )
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(22),
                    bottomRight: Radius.circular(22)),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            '${selectedDate.day} ${DateFormat('MMMM', 'es_ES').format(selectedDate)[0].toUpperCase()}${DateFormat('MMMM', 'es_ES').format(selectedDate).substring(1)}',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inverseSurface,
                                fontSize: 14),
                          ),
                          Text(
                            "Reserva",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inverseSurface,
                                fontSize: 12),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            DateFormat('dd/MM/yy').format(DateTime.now()),
                            style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inverseSurface,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "Creada",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inverseSurface,
                                fontSize: 12),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '${preferencias.usuarioDni!.substring(0, 8)}',
                            style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inverseSurface,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "Cliente",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inverseSurface,
                                fontSize: 12),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDetallesPedido() {
    final preferencias =
        PreferenciasUsuario(); // Obtener instancia de PreferenciasUsuario
    DateTime fechaHoraSeleccionada = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour + 1,
      selectedTime.minute,
    );
    List<PedidoSeleccionadoItem> carrito = widget.bloc.carrito;

    List<Map<String, dynamic>> carritoJson =
        carrito.map((item) => item.toJson()).toList();
    String carritoJsonString = jsonEncode(carritoJson);

    // Obtener el nombre de la sucursal y aplicar transformaciones
    String sucursalNombre = preferencias.sucursalNombre ?? '';
    sucursalNombre = sucursalNombre.replaceAll('Sucursal ', '');
    sucursalNombre = sucursalNombre.trim();
    return SizedBox(
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(22),
                    topRight: Radius.circular(22)),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        'D Gilberth',
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      const Spacer(),
                      const ComidaContainer(),
                      Expanded(
                          child: Stack(
                        children: [
                          Center(
                            child: Icon(
                              Icons.fastfood_rounded,
                              color:
                                  Theme.of(context).colorScheme.inverseSurface,
                            ),
                          ),
                          SizedBox(
                              height: 20,
                              child: Flex(
                                  direction: Axis.horizontal,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: List.generate(
                                      (MediaQuery.of(context).size.width / 55)
                                          .floor(),
                                      (index) => SizedBox(
                                            width: 2,
                                            height: 1,
                                            child: DecoratedBox(
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .inverseSurface)),
                                          )))),
                        ],
                      )),
                      const ComidaContainer(),
                      const Spacer(),
                      Text(
                        '  S/. ${widget.bloc.totalCarritoPrecio()}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.inverseSurface,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: 100,
                          child: Text(
                            sucursalNombre,
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inverseSurface
                                    .withOpacity(0.8)),
                          )),
                      Text(
                        ' ${selectedTime.hour + 1}H ${selectedTime.minute} M',
                        style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.inverseSurface),
                      ),
                      Text(
                        '                 Items: ${widget.bloc.totalCarritoElementos()}',
                        style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(context)
                                .colorScheme
                                .inverseSurface
                                .withOpacity(0.8)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              color: Theme.of(context).colorScheme.inversePrimary,
              child: Row(
                children: [
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ))),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: List.generate(
                          (MediaQuery.of(context).size.width / 15).floor(),
                          (index) => SizedBox(
                              width: 5,
                              height: 1,
                              child: DecoratedBox(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surface)))),
                    ),
                  )),
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ))),
                  )
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary,
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            '${selectedDate.day} ${DateFormat('MMMM', 'es_ES').format(selectedDate)[0].toUpperCase()}${DateFormat('MMMM', 'es_ES').format(selectedDate).substring(1)}',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inverseSurface,
                                fontSize: 14),
                          ),
                          Text(
                            "Reserva",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inverseSurface,
                                fontSize: 12),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            DateFormat('dd/MM/yy').format(DateTime.now()),
                            style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inverseSurface,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "Creada",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inverseSurface,
                                fontSize: 12),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '${preferencias.usuarioDni!.substring(0, 8)}',
                            style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inverseSurface,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "Cliente",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inverseSurface,
                                fontSize: 12),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            Column(
              children: List.generate(widget.bloc.carrito.length, (index) {
                final item = widget.bloc.carrito[index];
                final observacionesString = item.observaciones.join(', ');
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Flex(
                              direction: Axis.horizontal,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: List.generate(
                                  (MediaQuery.of(context).size.width / 15)
                                      .floor(),
                                  (index) => SizedBox(
                                      width: 5,
                                      height: 1,
                                      child: DecoratedBox(
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface)))),
                            ),
                          )),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(
                                    item.producto.imagenPrincipal!),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '${item.producto.nombre}',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inverseSurface,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                ' S/. ${(item.cantidad * item.producto.precio).toStringAsFixed(2)}',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Cantidad: ${item.cantidad}',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inverseSurface,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              observacionesString,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inverseSurface,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(22),
                    bottomRight: Radius.circular(22)),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: List.generate(
                              (MediaQuery.of(context).size.width / 15).floor(),
                              (index) => SizedBox(
                                  width: 5,
                                  height: 1,
                                  child: DecoratedBox(
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface)))),
                        ),
                      )),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: BarcodeWidget(
                            barcode: Barcode.code128(),
                            data: 'https://www.youtube.com',
                            drawText: false,
                            color: Theme.of(context).colorScheme.primary,
                            width: MediaQuery.of(context).size.width - 100,
                            height: 70,
                          ),
                        ),
                      )

                      /*
                      Column(
                        children: [
                          Text(
                            '${selectedDate.day} ${DateFormat('MMMM', 'es_ES').format(selectedDate)[0].toUpperCase()}${DateFormat('MMMM', 'es_ES').format(selectedDate).substring(1)}',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inverseSurface,
                                fontSize: 14),
                          ),
                          Text(
                            "Reserva",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inverseSurface,
                                fontSize: 12),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            DateFormat('dd/MM/yy').format(DateTime.now()),
                            style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inverseSurface,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "Creada",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inverseSurface,
                                fontSize: 12),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '${preferencias.usuarioDni!.substring(0, 8)}',
                            style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inverseSurface,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "Cliente",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inverseSurface,
                                fontSize: 12),
                          ),
                        ],
                      )
                      */
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMonthsList() {
    DateTime now = DateTime.now();
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 12,
      itemBuilder: (context, index) {
        DateTime month = DateTime(now.year, now.month + index, 1);
        if (index > 0 && month.isBefore(now)) {
          return Container(); // No mostrar meses anteriores al actual
        }
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedDate = month;
            });
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.3,
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                '${DateFormat('MMMM', 'es_ES').format(month)[0].toUpperCase()}${DateFormat('MMMM', 'es_ES').format(month).substring(1)}',
                style: TextStyle(
                  color: selectedDate == month
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.inverseSurface,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDaysList() {
    DateTime firstDayOfMonth =
        DateTime(selectedDate.year, selectedDate.month, 1);
    DateTime lastDayOfMonth =
        DateTime(selectedDate.year, selectedDate.month + 1, 0);
    List<Widget> days = [];

    for (int i = 1; i <= lastDayOfMonth.day; i++) {
      DateTime day = DateTime(selectedDate.year, selectedDate.month, i);
      bool isSelected = day.day == selectedDate.day;

      days.add(GestureDetector(
        onTap: () {
          if (day.isAfter(DateTime.now()) ||
              day.isAtSameMomentAs(DateTime.now())) {
            setState(() {
              selectedDate = day;
              showTimePicker = true;
            });
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                DateFormat('EEE', 'es_ES').format(day),
                style: TextStyle(
                  color: isSelected
                      ? Theme.of(context).colorScheme.surface
                      : Theme.of(context).colorScheme.inverseSurface,
                  fontSize: 14,
                ),
              ),
              Text(
                i.toString(),
                style: TextStyle(
                  color: isSelected
                      ? Theme.of(context).colorScheme.surface
                      : Theme.of(context).colorScheme.inverseSurface,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ));
    }

    return ListView(
      scrollDirection: Axis.horizontal,
      children: days,
    );
  }

  Widget _buildTimeSelector() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      transform:
          Matrix4.translationValues(0.0, showTimePicker ? 0.0 : -500.0, 0.0),
      child: Container(
        color: Theme.of(context).colorScheme.surface.withOpacity(1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTimeWheelSelector(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeWheelSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTimeWheel(
          itemCount: 12,
          initialItem: selectedTime.hourOfPeriod %
              12, // Ajuste para mostrar correctamente AM/PM
          onSelectedItemChanged: (index) {
            setState(() {
              int newHour =
                  index + (selectedTime.period == DayPeriod.pm ? 12 : 0);
              selectedTime = selectedTime.replacing(hour: newHour % 24);
            });
          },
          itemBuilder: (context, index) {
            return Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inverseSurface,
                  fontSize: 24,
                ),
              ),
            );
          },
        ),
        _buildTimeWheel(
          itemCount: 60,
          initialItem: selectedTime.minute,
          onSelectedItemChanged: (index) {
            setState(() {
              selectedTime = selectedTime.replacing(minute: index);
            });
          },
          itemBuilder: (context, index) {
            return Center(
              child: Text(
                index.toString().padLeft(2, '0'),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inverseSurface,
                  fontSize: 24,
                ),
              ),
            );
          },
        ),
        _buildTimeWheel(
          itemCount: 2,
          initialItem: selectedTime.period == DayPeriod.am ? 0 : 1,
          onSelectedItemChanged: (index) {
            setState(() {
              int newHour = selectedTime.hour % 12 + (index == 0 ? 0 : 12);
              selectedTime = selectedTime.replacing(hour: newHour % 24);
            });
          },
          itemBuilder: (context, index) {
            return Center(
              child: Text(
                index == 0 ? 'AM' : 'PM',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inverseSurface,
                  fontSize: 24,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTimeWheel({
    required int itemCount,
    required int initialItem,
    required void Function(int) onSelectedItemChanged,
    required Widget Function(BuildContext, int) itemBuilder,
  }) {
    return Container(
      width: 50,
      height: 100,
      child: ListWheelScrollView.useDelegate(
        itemExtent: 40,
        diameterRatio: 1.2,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: onSelectedItemChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          builder: itemBuilder,
          childCount: itemCount,
        ),
      ),
    );
  }
}
