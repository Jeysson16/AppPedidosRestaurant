import 'package:flutter/material.dart';
import 'package:restaurant_app/features/productos/presentacion/controller/sliver_controll_controller.dart';
import 'package:restaurant_app/features/productos/presentacion/widget/background_sliver.dart';
import 'package:restaurant_app/features/productos/presentacion/widget/list_item_header_sliver.dart';
import 'package:restaurant_app/features/productos/presentacion/widget/my_heather_title.dart';
import 'package:restaurant_app/features/productos/presentacion/widget/sliver_body_items.dart';
import 'package:restaurant_app/features/productos/presentacion/widget/sliver_header_data.dart';


class HomeSliverWithTab extends StatefulWidget {
  final SliverScrollController bloc;
  const HomeSliverWithTab({super.key, required this.bloc});

  @override
  State<HomeSliverWithTab> createState() => _HomeSliverWithTabState();
}

class _HomeSliverWithTabState extends State<HomeSliverWithTab> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: NotificationListener(
          onNotification: (scroll) {
            if (scroll is ScrollUpdateNotification) {
              widget.bloc.valueScroll.value = scroll.metrics.extentInside;
            }
            return true;
          },
          child: Scrollbar(
            radius: const Radius.circular(8),
            child: ValueListenableBuilder(
                valueListenable: widget.bloc.globalOffsetValue,
                builder: (_, double valueCurrentScroll, __) {
                  return CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    controller: widget.bloc.scrollControllerGlobally,
                    slivers: [
                      _FlexibleSpaceBarHeader(
                        valueScroll: valueCurrentScroll,
                        bloc: widget.bloc,
                      ),
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: _HeaderSliver(bloc: widget.bloc),
                      ),
                      for (var i = 0; i < widget.bloc.listCategory.length; i++) ...[
                        SliverPersistentHeader(
                          delegate: MyHeaderTitle(
                            widget.bloc.listCategory[i].nombre,
                            (visible) => widget.bloc.refreshHeader(
                              i,
                              visible,
                              lastIndex: i > 0 ? i - 1 : null,
                            ),
                          ),
                        ),
                        SliverBodyItems(
                          listItem: widget.bloc.listCategory[i].productos,
                        )
                      ]
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}

class _FlexibleSpaceBarHeader extends StatelessWidget {
  const _FlexibleSpaceBarHeader({
    required this.valueScroll,
    required this.bloc,
  });

  final double valueScroll;
  final SliverScrollController bloc;

  @override
  Widget build(BuildContext context) {
    final sizeHeight = MediaQuery.of(context).size.height;
    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      stretch: true,
      expandedHeight: 250,
      pinned: valueScroll < 90 ? true : false,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            BackgroundSliver(bannerUrls: bloc.bannerUrls),
            Positioned(
              right: 10,
              top: (sizeHeight + 20) - bloc.valueScroll.value,
              child: const Icon(Icons.favorite, size: 30),
            ),
            Positioned(
              left: 10,
              top: (sizeHeight + 20) - bloc.valueScroll.value,
              child: const Icon(Icons.arrow_back, size: 30),
            ),
          ],
        ),
      ),
    );
  }
}

const _maxHeaderExtent = 100.0;

class _HeaderSliver extends SliverPersistentHeaderDelegate {
  _HeaderSliver({required this.bloc});

  final SliverScrollController bloc;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final percent = shrinkOffset / _maxHeaderExtent;
    if (percent > 0.1) {
      bloc.visibleHeader.value = true;
    } else {
      bloc.visibleHeader.value = false;
    }
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: _maxHeaderExtent,
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      AnimatedOpacity(
                        opacity: percent > 0.1 ? 1 : 0,
                        duration: const Duration(milliseconds: 300),
                        child: const Icon(Icons.arrow_back),
                      ),
                      AnimatedSlide(
                        duration: const Duration(milliseconds: 300),
                        offset: Offset(percent < 0.1 ? -0.18 : 0.1, 0),
                        curve: Curves.easeIn,
                        child: const Text(
                          'Kavsoft Bakery',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: percent > 0.1
                        ? ListItemHeaderSliver(bloc: bloc)
                        : const SliverHeaderData(),
                  ),
                )
              ],
            ),
          ),
        ),
        if (percent > 0.1)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: percent > 0.1
                  ? Container(
                      height: 0.5,
                      color: Colors.white10,
                    )
                  : null,
            ),
          )
      ],
    );
  }

  @override
  double get maxExtent => _maxHeaderExtent;

  @override
  double get minExtent => _maxHeaderExtent;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}