import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class FaceDetectionPage extends StatefulWidget {
  @override
  _FaceDetectionPageState createState() => _FaceDetectionPageState();
}

class _FaceDetectionPageState extends State<FaceDetectionPage>
    with AutomaticKeepAliveClientMixin {
  ARKitController arkitController;
  ARKitNode node;
  String anchorId;

  ARKitNode leftEye;
  ARKitNode rightEye;

  @override
  void dispose() {
    arkitController?.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Face Detection Sample')),
        body: Container(
          child: ARKitSceneView(
            configuration: ARKitConfiguration.faceTracking,
            onARKitViewCreated: onARKitViewCreated,
          ),
        ),
      );

  void onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;
    this.arkitController.onAddNodeForAnchor = _handleAddAnchor;
    this.arkitController.onUpdateNodeForAnchor = _handleUpdateAnchor;
  }

  void _handleAddAnchor(ARKitAnchor anchor) {
    if (!(anchor is ARKitFaceAnchor)) {
      return;
    }
    final material = ARKitMaterial(fillMode: ARKitFillMode.lines);
    final ARKitFaceAnchor faceAnchor = anchor;
    faceAnchor.geometry.materials.value = [material];

    anchorId = anchor.identifier;
    node = ARKitNode(geometry: faceAnchor.geometry);
    arkitController.add(node, parentNodeName: anchor.nodeName);

    leftEye = _createEye(faceAnchor.leftEyeTransform);
    arkitController.add(leftEye, parentNodeName: anchor.nodeName);
    rightEye = _createEye(faceAnchor.rightEyeTransform);
    arkitController.add(rightEye, parentNodeName: anchor.nodeName);
  }

  ARKitNode _createEye(Matrix4 transform) {
    final position = vector.Vector3(
      transform.getColumn(3).x,
      transform.getColumn(3).y,
      transform.getColumn(3).z,
    );
    final material = ARKitMaterial(
      diffuse: ARKitMaterialProperty(color: Colors.yellow),
    );
    final sphere = ARKitBox(
        materials: [material], width: 0.03, height: 0.03, length: 0.03);

    return ARKitNode(geometry: sphere, position: position);
  }

  void _handleUpdateAnchor(ARKitAnchor anchor) {
    if (anchor is ARKitFaceAnchor) {
      final ARKitFaceAnchor faceAnchor = anchor;
      arkitController.updateFaceGeometry(node, anchor.identifier);
      _updateEye(leftEye, faceAnchor.leftEyeTransform,
          faceAnchor.blendShapes['eyeBlink_L']);
      _updateEye(rightEye, faceAnchor.rightEyeTransform,
          faceAnchor.blendShapes['eyeBlink_R']);
      double faceDistance = _updateDistance(anchor);
      _updateState(faceDistance, faceAnchor.leftEyeTransform,
          faceAnchor.rightEyeTransform);
    }
  }

  void _updateEye(ARKitNode node, Matrix4 transform, double blink) {
    final scale = vector.Vector3(1, 1 - blink, 1);
    node.scale.value = scale;
  }

  double _updateDistance(ARKitAnchor anchor) {
    final position = vector.Vector3(
      anchor.transform.getColumn(3).x,
      anchor.transform.getColumn(3).y,
      anchor.transform.getColumn(3).z,
    );
    final faceDistance =
        _calculateDistanceBetweenPoints(position, vector.Vector3.zero());

    return faceDistance;
  }

  void _updateState(double faceDistance, Matrix4 leftEye, Matrix4 rightEye) {
    print("faceDistance $faceDistance leftEye $leftEye rightEye $rightEye");
  }

  double _calculateDistanceBetweenPoints(vector.Vector3 A, vector.Vector3 B) {
    final length = A.distanceTo(B);
    return length; //length * 100 is cms
  }
}
