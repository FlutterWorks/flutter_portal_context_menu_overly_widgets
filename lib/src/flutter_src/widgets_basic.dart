// NOTE adapted from Flutter beta 2.11.0-0.1.pre (notice beta, not stable)
// Please place a `NOTE MODIFIED` marker whenever you change the Flutter code

// ignore_for_file: unnecessary_null_comparison, diagnostic_describe_all_properties

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../anchor.dart';
import '../portal.dart';
import 'rendering_layer.dart';
import 'rendering_proxy_box.dart';

/// A widget that can be targeted by a [CompositedTransformFollower].
///
/// When this widget is composited during the compositing phase (which comes
/// after the paint phase, as described in [WidgetsBinding.drawFrame]), it
/// updates the [link] object so that any [CompositedTransformFollower] widgets
/// that are subsequently composited in the same frame and were given the same
/// [CustomLayerLink] can position themselves at the same screen location.
///
/// A single [CustomCompositedTransformTarget] can be followed by multiple
/// [CompositedTransformFollower] widgets.
///
/// The [CustomCompositedTransformTarget] must come earlier in the paint order than
/// any linked [CompositedTransformFollower]s.
///
/// See also:
///
///  * [CompositedTransformFollower], the widget that can target this one.
///  * [LeaderLayer], the layer that implements this widget's logic.
class CustomCompositedTransformTarget extends SingleChildRenderObjectWidget {
  /// Creates a composited transform target widget.
  ///
  /// The [link] property must not be null, and must not be currently being used
  /// by any other [CustomCompositedTransformTarget] object that is in the tree.
  const CustomCompositedTransformTarget({
    Key? key,
    required this.link,
    Widget? child,
  })  : assert(link != null),
        super(key: key, child: child);

  /// The link object that connects this [CustomCompositedTransformTarget] with one or
  /// more [CompositedTransformFollower]s.
  ///
  /// This property must not be null. The object must not be associated with
  /// another [CustomCompositedTransformTarget] that is also being painted.
  final CustomLayerLink link;

  @override
  CustomRenderLeaderLayer createRenderObject(BuildContext context) {
    return CustomRenderLeaderLayer(
      link: link,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, CustomRenderLeaderLayer renderObject) {
    renderObject.link = link;
  }
}

/// @nodoc
class CustomCompositedTransformFollower extends SingleChildRenderObjectWidget {
  /// @nodoc
  const CustomCompositedTransformFollower({
    Key? key,
    required this.link,
    required this.overlayLink,
    required this.targetSize,
    required this.anchor,
    Widget? child,
  }) : super(key: key, child: child);

  /// @nodoc
  final Anchor anchor;

  /// @nodoc
  final CustomLayerLink link;

  /// @nodoc
  final OverlayLink overlayLink;

  /// @nodoc
  final Size targetSize;

  @override
  CustomRenderFollowerLayer createRenderObject(BuildContext context) {
    return CustomRenderFollowerLayer(
      anchor: anchor,
      link: link,
      overlayLink: overlayLink,
      targetSize: targetSize,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    CustomRenderFollowerLayer renderObject,
  ) {
    renderObject
      ..link = link
      ..overlayLink = overlayLink
      ..targetSize = targetSize
      ..anchor = anchor;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Anchor>('anchor', anchor));
    properties.add(DiagnosticsProperty<CustomLayerLink>('link', link));
    properties
        .add(DiagnosticsProperty<OverlayLink>('overlayLink', overlayLink));
    properties.add(DiagnosticsProperty<Size>('targetSize', targetSize));
  }
}
