// lib/draggable_container.dart
import 'package:flutter/material.dart';

class DraggableContainer extends StatefulWidget {
  final Offset offset;
  final String imagePath;
  final Size imageSize;
  final Function(Offset) onDragEnd;
  final VoidCallback onTap;

  const DraggableContainer({
    super.key,
    required this.offset,
    required this.imagePath,
    required this.imageSize,
    required this.onDragEnd,
    required this.onTap,
  });

  @override
  _DraggableContainerState createState() => _DraggableContainerState();
}

class _DraggableContainerState extends State<DraggableContainer> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.offset.dx,
      top: widget.offset.dy,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Draggable(
          feedback: Material(
            color: Colors.transparent,
            child: Image.asset(
              widget.imagePath,
              width: widget.imageSize.width,
              height: widget.imageSize.height,
              opacity: const AlwaysStoppedAnimation(0.5),
            ),
          ),
          childWhenDragging: Container(
            color: Colors.transparent,
            width: widget.imageSize.width,
            height: widget.imageSize.height,
          ),
          onDragEnd: (details) {
            final RenderBox renderBox = context.findRenderObject() as RenderBox;
            Offset localOffset = renderBox.globalToLocal(details.offset);
            localOffset += Offset(widget.offset.dx, widget.offset.dy);
            widget.onDragEnd(localOffset);
          },
          child: Image.asset(
            widget.imagePath,
            width: widget.imageSize.width,
            height: widget.imageSize.height,
          ),
        ),
      ),
    );
  }
}
