import 'dart:ui';
import 'package:firebase_flutter/Firebase/Authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


class ExampleParallax extends StatefulWidget {
  const ExampleParallax({
    Key? key,
  }) : super(key: key);

  @override
  _ExampleParallaxState createState() => _ExampleParallaxState();
}

class _ExampleParallaxState extends State<ExampleParallax> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Authenticate authclass  = Authenticate();
  @override
  Widget build(BuildContext context) {
    Map productmap = ModalRoute
        .of(context)
        ?.settings
        .arguments as Map;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: Text("Shop"),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: InkWell(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'Cart');
                },
                child: Icon(
                  Icons.shopping_cart,
                  size: 26.0,
                ),
              ),
              onTap: () {},
            ),
          ),
          PopupMenuButton<int>(
            onSelected: (item) => onSelected(context, item, authclass),
            itemBuilder: (context) =>
            [
              PopupMenuItem<int>(
                child: Text("Settings"),
                value: 0,
              ),
              PopupMenuItem<int>(
                child: Text("???"),
                value: 1,
              ),
              PopupMenuItem<int>(
                child: Text("Sign Out"),
                value: 2,
              ),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Edit'),
            ),
            ListTile(
              title: const Text('Your Order'),
              onTap: () {
                Navigator.pushNamed(context, 'Orders');
              },
            ),
            ListTile(
              title: const Text('Add Items'),
              onTap: () {
                Navigator.pushNamed(context, 'Add').then((value) =>
                    setState(() {}));
              },
            ),
            ListTile(
              title: const Text('Remove Items'),
              onTap: () {
                Navigator.pushNamed(context, 'Remove').then((value) =>
                    setState(() {}));
              },
            ),
          ],
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          children: fetch(productmap, context),
        ),
      ),
    );
  }

  List<Widget> fetch(Map? productmap, BuildContext context) {
    List<LocationListItem> grid = [];
    productmap?.forEach((key, value) {
      grid.add(LocationListItem(imageUrl: value["image"],
        name: value["title"],
        productmap: productmap,));
    });

    return grid;
  }

  void onSelected(BuildContext context, int item, Authenticate authclass) {
    switch (item) {
      case 0:
        Navigator.pushNamed(context, 'Settings');
        break;
      case 1:
      //???
        break;
      case 2:
        authclass.signOut();
        break;
    }
  }
}
class LocationListItem extends StatelessWidget {
  LocationListItem({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.productmap

  }) : super(key: key);

  final String imageUrl;
  final String name;
  final Map productmap;
  final GlobalKey _backgroundImageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: AspectRatio(
        aspectRatio: 17 / 9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              _buildParallaxBackground(context),
              _buildGradient(),
              _buildTitleAndSubtitle(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParallaxBackground(BuildContext context) {
    return Flow(
      delegate: ParallaxFlowDelegate(
        scrollable: Scrollable.of(context)!,
        listItemContext: context,
        backgroundImageKey: _backgroundImageKey,
      ),
      children: [
        GestureDetector(
          child: Image.network(
            imageUrl,
            key: _backgroundImageKey,
            fit: BoxFit.cover,
          ),
          onTap: (){
            Nav(context);
          },
        ),
      ],
    );
  }

  void Nav(BuildContext context)
  {
    int index =1;
    for(int i=1;i<=productmap.length;i++)
    {
      if(productmap["$i"]["image"] == imageUrl)
      {
        index = i;
        break;
      }
    }
    Navigator.pushNamed(context, 'Individual', arguments: {
      'index' : index,
      'productmap' : productmap
    });
  }

  Widget _buildGradient() {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.6, 0.95],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleAndSubtitle() {
    return Positioned(
      left: 20,
      bottom: 20,
      child: Column(
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
  Parallax({
    required Widget background,
  }) : super(child: background);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderParallax(scrollable: Scrollable.of(context)!);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderParallax renderObject) {
    renderObject.scrollable = Scrollable.of(context)!;
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
    required this.imageUrl,
  });
  final String name;
  final String imageUrl;
}
