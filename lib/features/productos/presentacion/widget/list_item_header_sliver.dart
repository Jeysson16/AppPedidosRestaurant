import 'package:flutter/material.dart';
import 'package:restaurant_app/features/productos/data/models/my_header.dart';
import 'package:restaurant_app/features/productos/presentacion/controller/sliver_controll_controller.dart';
import 'package:restaurant_app/features/productos/presentacion/widget/get_box_offset.dart';

class ListItemHeaderSliver extends StatelessWidget {
  const ListItemHeaderSliver({
    super.key,
    required this.bloc,
  });

  final SliverScrollController bloc;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final itemsOffset = bloc.listOffSetItemHeader;

    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) => true,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
              right: size.width -
                  (itemsOffset[itemsOffset.length - 1] -
                      itemsOffset[itemsOffset.length - 2])),
          physics: const NeverScrollableScrollPhysics(),
          controller: bloc.scrollControllerItemHeader,
          scrollDirection: Axis.horizontal,
          child: ValueListenableBuilder(
            valueListenable: bloc.headerNotifier,
            builder: (context, MyHeader? snapshot, __) {
              return Row(
                children: List.generate(
                  bloc.listCategory.length,
                  (index) {
                    return GetBoxOffset(
                      offset: (offSet) {
                        return itemsOffset[index] = offSet.dx;
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                          top: 8,
                          bottom: 8,
                          right: 8,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: index == snapshot!.index ? Theme.of(context).colorScheme.primary.withOpacity(0.1) : null,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          bloc.listCategory[index].nombre,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: index == snapshot.index
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
