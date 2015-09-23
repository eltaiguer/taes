class Joints{
  
  PVector head, neck, torso;
  PVector rightHand, rightElbow, rightHip;
  PVector leftHand, leftElbow, leftHip;
  PVector rightFoot, rightShoulder, rightKnee;
  PVector leftFoot, leftShoulder, leftKnee;

  PVector head2d, neck2d, torso2d;
  PVector rightHand2d, rightElbow2d, rightHip2d;
  PVector leftHand2d, leftElbow2d, leftHip2d;
  PVector rightFoot2d, rightShoulder2d, rightKnee2d;
  PVector leftFoot2d, leftShoulder2d, leftKnee2d;

  // Constructor: Inicializar PVectors en 0?
  Joints(){
    head = new PVector();
    neck = new PVector();
    torso = new PVector();
    rightHand  = new PVector();
    rightElbow = new PVector();
    rightHip = new PVector();
    leftHand  = new PVector();
    leftElbow = new PVector();
    leftHip = new PVector();
    rightFoot  = new PVector();
    rightShoulder = new PVector();
    rightKnee = new PVector();
    leftFoot  = new PVector();
    leftShoulder = new PVector();
    leftKnee = new PVector();

    head2d  = new PVector();
    neck2d = new PVector();
    torso2d = new PVector();
    rightHand2d  = new PVector();
    rightElbow2d = new PVector();
    rightHip2d = new PVector();
    leftHand2d  = new PVector();
    leftElbow2d = new PVector();
    leftHip2d = new PVector();
    rightFoot2d  = new PVector();
    rightShoulder2d = new PVector();
    rightKnee2d = new PVector();
    leftFoot2d  = new PVector();
    leftShoulder2d = new PVector();
    leftKnee2d = new PVector();
  }

  // Actualizar la posicion segun usuario
  void updateJointsPosition(user){
    // Get Head
    context.getJointPositionSkeleton(user, SimpleOpenNI.SKEL_HEAD, head);
    context.convertRealWorldToProjective(head, head2d);

    // Get Nek
    context.getJointPositionSkeleton(user, SimpleOpenNI.SKEL_NECK, neck);
    context.convertRealWorldToProjective(neck, neck2d);

    // Get Torso
    context.getJointPositionSkeleton(user, SimpleOpenNI.SKEL_TORSO, torso);
    context.convertRealWorldToProjective(torso, torso2d);

    // Get right hand
    context.getJointPositionSkeleton(user, SimpleOpenNI.SKEL_RIGHT_HAND, rightHand);
    context.convertRealWorldToProjective(rightHand, rightHand2d);

    // Get right elbow
    context.getJointPositionSkeleton(user, SimpleOpenNI.SKEL_RIGHT_ELBOW, rightElbow);
    context.convertRealWorldToProjective(rightElbow, rightElbow2d);

    // Get right hip
    context.getJointPositionSkeleton(user, SimpleOpenNI.SKEL_RIGHT_HIP, rightHip);
    context.convertRealWorldToProjective(rightHip, rightHip2d);

    // Get left hand
    context.getJointPositionSkeleton(user, SimpleOpenNI.SKEL_LEFT_HAND, leftHand);
    context.convertRealWorldToProjective(leftHand, leftHand2d);

    // Get right elbow
    context.getJointPositionSkeleton(user, SimpleOpenNI.SKEL_LEFT_ELBOW, leftElbow);
    context.convertRealWorldToProjective(leftElbow, leftElbow2d);

    // Get left hip
    context.getJointPositionSkeleton(user, SimpleOpenNI.SKEL_RIGHT_HIP, leftHip);
    context.convertRealWorldToProjective(leftHip, leftHip2d);

    // Get right foot
    context.getJointPositionSkeleton(user, SimpleOpenNI.SKEL_RIGHT_FOOT, rightFoot);
    context.convertRealWorldToProjective(rightFoot, rightFoot2d);

    // Get left foot
    context.getJointPositionSkeleton(user, SimpleOpenNI.SKEL_LEFT_FOOT, leftFoot);
    context.convertRealWorldToProjective(leftFoot, leftFoot2d);

    // Get right shoulder
    context.getJointPositionSkeleton(user, SimpleOpenNI.SKEL_RIGHT_SHOULDER, rightShoulder);
    context.convertRealWorldToProjective(rightShoulder, rightShoulder2d);

    // Get left shoulder
    context.getJointPositionSkeleton(user, SimpleOpenNI.SKEL_LEFT_SHOULDER, leftShoulder);
    context.convertRealWorldToProjective(leftShoulder, leftShoulder2d);

    // Get right knee
    context.getJointPositionSkeleton(user, SimpleOpenNI.SKEL_RIGHT_KNEE, rightKnee);
    context.convertRealWorldToProjective(rightKnee, rightKnee2d);

    // Get left knee
    context.getJointPositionSkeleton(user, SimpleOpenNI.SKEL_LEFT_KNEE, leftKnee);
    context.convertRealWorldToProjective(leftKnee, leftKnee2d);
  }

  // DEBUG: Funcion axuliar paa dibujar los Joints
  void drawJoint(PVector joint) {
    float x_coord = map(joint.x, 0, kWidth, 0, width);
    float y_coord = map(joint.y, 0, kHeight, 0, height);
    ellipse(x_coord, y_coord, 50, 50);
  }

}
