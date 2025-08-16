import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:responsive_framework/responsive_framework.dart';

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);

class ExampleParallax extends StatelessWidget {
  const ExampleParallax({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (final location in locations)
            LocationListItem(
              imageUrl: location.imageUrl,
              name: location.name,
              country: location.place,
            ),
        ],
      ),
    );
  }
}

class LocationListItem extends StatelessWidget {
  LocationListItem({
    super.key,
    this.aspectRatio = 3 / 1,
    required this.imageUrl,
    required this.name,
    required this.country,
    this.customBottomWidget,
    this.customCenterWidget,
    this.usePadding = true,
    this.customFlowWidget,
    this.useClipRect = true,
    this.descriptionIsWhite = false,
    this.useAspectRatio = false,
    this.soildColor,
    this.useResponsiveLayout = true,
  });
  final bool useClipRect;
  final bool descriptionIsWhite;
  final bool usePadding;
  final Widget? customBottomWidget;
  final Widget? customCenterWidget;
  final Widget? customFlowWidget;
  final bool useResponsiveLayout;
  final String imageUrl;
  final Color? soildColor;
  final bool useAspectRatio;
  final String name;
  final String country;
  final GlobalKey _backgroundImageKey = GlobalKey();

  final double aspectRatio;
  @override
  Widget build(BuildContext context) {
    if (useResponsiveLayout) {
      return Center(
        child: ScreenHelper(
          largeTablet: _buildUi(context, kDesktopMaxWidth),
          smallTablet: _buildUi(context, kTabletMaxWidth),
          mobile: _buildUi(context, getMobileMaxWidth(context)),
        ),
      );
    }
    return getBody(context);
  }

  Widget _buildUi(BuildContext context, double width) {
    return MaxWidthBox(
        // minWidth: width,
        maxWidth: width,
        child: Container(
          // height: 400,
          alignment: Alignment.center,
          child: AspectRatio(
              aspectRatio: aspectRatio, child: getClipRRect(context)),
        ));
  }

  Padding getBody(BuildContext context) {
    double carouselContainerHeight = MediaQuery.of(context).size.height *
        (SizeConfig.isMobile(context) ? .5 : .65);
    return Padding(
      padding: usePadding
          ? const EdgeInsets.symmetric(horizontal: 24, vertical: 16)
          : EdgeInsets.zero,
      child: useAspectRatio
          ? AspectRatio(
              aspectRatio: aspectRatio,
              child: getClipRRect(context),
            )
          : SizedBox(
              height: carouselContainerHeight,
              width: double.infinity,
              child: getClipRRect(context),
            ),
    );
  }

  Widget getClipRRect(BuildContext context) {
    if (useClipRect) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: getStack(context),
      );
    } else {
      return getStack(context);
    }
  }

  Stack getStack(BuildContext context) {
    return Stack(
      children: [
        if (customCenterWidget != null)
          if (soildColor != null) Positioned.fill(child: getFlow(context)),
        _buildParallaxBackground(context),
        if (customCenterWidget == null) _buildGradient(context),
        if (customCenterWidget == null) _buildTitleAndSubtitle(),
        if (customCenterWidget != null) _buildCenterWidget(context),
      ],
    );
  }

  Widget _buildCenterWidget(BuildContext context) {
    return Positioned.fill(
      child: Align(alignment: Alignment.centerLeft, child: customCenterWidget!),
    );
  }

  Widget _buildParallaxBackground(BuildContext context) {
    if (soildColor != null) {
      return Positioned.fill(
        child: Container(
          color: soildColor,
        ),
      );
    }
    return getFlow(context);
  }

  Flow getFlow(BuildContext context) {
    return Flow(
      clipBehavior: Clip.antiAlias,
      delegate: ParallaxFlowDelegate(
        scrollable: Scrollable.of(context),
        listItemContext: context,
        backgroundImageKey: _backgroundImageKey,
      ),
      children: [
        if (customFlowWidget != null) customFlowWidget!,
        // FadeInImage(
        //   placeholder: MemoryImage(kTransparentImage),
        //   image: FastCachedImageProvider(imageUrl!),
        //   fit: BoxFit.cover,
        // )
        if (customFlowWidget == null)
          Image.network(
            imageUrl,
            key: _backgroundImageKey,
            fit: BoxFit.fitHeight,
          ),

        // FadeInImage.memoryNetwork(
        //   key: _backgroundImageKey,
        //   // From the transparent_image package
        //   placeholder: kTransparentImage,
        //   image: imageUrl,

        //   fit: BoxFit.cover,
        // ),
      ],
    );
  }

  Widget _buildGradient(BuildContext context) {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              //  Colors.black.withValues(alpha:0.7),
              Theme.of(context).scaffoldBackgroundColor
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0, .95],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleAndSubtitle() {
    return Positioned(
      left: 20,
      bottom: 20,
      child: customBottomWidget != null
          ? customBottomWidget!
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  country,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
    );
  }
}

class ParallaxFlowDelegate extends FlowDelegate {
  ParallaxFlowDelegate({
    required this.scrollable,
    required this.listItemContext,
    required this.backgroundImageKey,
  }) : super(repaint: scrollable.position);

  final ScrollableState scrollable;
  final BuildContext listItemContext;
  final GlobalKey backgroundImageKey;

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    return BoxConstraints.tightFor(
      width: constraints.maxWidth,
    );
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    // Calculate the position of this list item within the viewport.
    final scrollableBox = scrollable.context.findRenderObject() as RenderBox;
    final listItemBox = listItemContext.findRenderObject() as RenderBox;
    final listItemOffset = listItemBox.localToGlobal(
        listItemBox.size.centerLeft(Offset.zero),
        ancestor: scrollableBox);

    // Determine the percent position of this list item within the
    // scrollable area.
    final viewportDimension = scrollable.position.viewportDimension;
    final scrollFraction =
        (listItemOffset.dy / viewportDimension).clamp(0.0, 1.0);

    // Calculate the vertical alignment of the background
    // based on the scroll percent.
    final verticalAlignment = Alignment(0.0, scrollFraction * 2 - 1);

    // Convert the background alignment into a pixel offset for
    // painting purposes.
    final backgroundSize =
        (backgroundImageKey.currentContext!.findRenderObject() as RenderBox)
            .size;
    final listItemSize = context.size;
    final childRect =
        verticalAlignment.inscribe(backgroundSize, Offset.zero & listItemSize);

    // Paint the background.
    context.paintChild(
      0,
      transform:
          Transform.translate(offset: Offset(0.0, childRect.top)).transform,
    );
  }

  @override
  bool shouldRepaint(ParallaxFlowDelegate oldDelegate) {
    return scrollable != oldDelegate.scrollable ||
        listItemContext != oldDelegate.listItemContext ||
        backgroundImageKey != oldDelegate.backgroundImageKey;
  }
}

class Parallax extends SingleChildRenderObjectWidget {
  const Parallax({
    super.key,
    required Widget background,
  }) : super(child: background);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderParallax(scrollable: Scrollable.of(context));
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderParallax renderObject) {
    renderObject.scrollable = Scrollable.of(context);
  }
}

class ParallaxParentData extends ContainerBoxParentData<RenderBox> {}

class RenderParallax extends RenderBox
    with RenderObjectWithChildMixin<RenderBox>, RenderProxyBoxMixin {
  RenderParallax({
    required ScrollableState scrollable,
  }) : _scrollable = scrollable;

  ScrollableState _scrollable;

  ScrollableState get scrollable => _scrollable;

  set scrollable(ScrollableState value) {
    if (value != _scrollable) {
      if (attached) {
        _scrollable.position.removeListener(markNeedsLayout);
      }
      _scrollable = value;
      if (attached) {
        _scrollable.position.addListener(markNeedsLayout);
      }
    }
  }

  @override
  void attach(covariant PipelineOwner owner) {
    super.attach(owner);
    _scrollable.position.addListener(markNeedsLayout);
  }

  @override
  void detach() {
    _scrollable.position.removeListener(markNeedsLayout);
    super.detach();
  }

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! ParallaxParentData) {
      child.parentData = ParallaxParentData();
    }
  }

  @override
  void performLayout() {
    size = constraints.biggest;

    // Force the background to take up all available width
    // and then scale its height based on the image's aspect ratio.
    final background = child!;
    final backgroundImageConstraints =
        BoxConstraints.tightFor(width: size.width);
    background.layout(backgroundImageConstraints, parentUsesSize: true);

    // Set the background's local offset, which is zero.
    (background.parentData as ParallaxParentData).offset = Offset.zero;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // Get the size of the scrollable area.
    final viewportDimension = scrollable.position.viewportDimension;

    // Calculate the global position of this list item.
    final scrollableBox = scrollable.context.findRenderObject() as RenderBox;
    final backgroundOffset =
        localToGlobal(size.centerLeft(Offset.zero), ancestor: scrollableBox);

    // Determine the percent position of this list item within the
    // scrollable area.
    final scrollFraction =
        (backgroundOffset.dy / viewportDimension).clamp(0.0, 1.0);

    // Calculate the vertical alignment of the background
    // based on the scroll percent.
    final verticalAlignment = Alignment(0.0, scrollFraction * 2 - 1);

    // Convert the background alignment into a pixel offset for
    // painting purposes.
    final background = child!;
    final backgroundSize = background.size;
    final listItemSize = size;
    final childRect =
        verticalAlignment.inscribe(backgroundSize, Offset.zero & listItemSize);

    // Paint the background.
    context.paintChild(
        background,
        (background.parentData as ParallaxParentData).offset +
            offset +
            Offset(0.0, childRect.top));
  }
}

class Location {
  const Location({
    required this.name,
    required this.place,
    required this.imageUrl,
  });

  final String name;
  final String place;
  final String imageUrl;
}

const urlPrefix =
    'https://docs.flutter.dev/cookbook/img-files/effects/parallax';
const locations = [
  Location(
    name: 'Mount Rushmore',
    place: 'U.S.A',
    imageUrl: '$urlPrefix/01-mount-rushmore.jpg',
  ),
  Location(
    name: 'Gardens By The Bay',
    place: 'Singapore',
    imageUrl: '$urlPrefix/02-singapore.jpg',
  ),
  Location(
    name: 'Machu Picchu',
    place: 'Peru',
    imageUrl: '$urlPrefix/03-machu-picchu.jpg',
  ),
  Location(
    name: 'Vitznau',
    place: 'Switzerland',
    imageUrl: '$urlPrefix/04-vitznau.jpg',
  ),
  Location(
    name: 'Bali',
    place: 'Indonesia',
    imageUrl: '$urlPrefix/05-bali.jpg',
  ),
  Location(
    name: 'Mexico City',
    place: 'Mexico',
    imageUrl: '$urlPrefix/06-mexico-city.jpg',
  ),
  Location(
    name: 'Cairo',
    place: 'Egypt',
    imageUrl: '$urlPrefix/07-cairo.jpg',
  ),
];
