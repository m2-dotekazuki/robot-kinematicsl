float baseAngle = 0; // ベースの回転角度
float angle1 = 0;
float angle2 = 0;
float angle3 = 0;

// 視点制御用変数
float rotX = 0;
float rotY = 0;

// ターゲットの位置
PVector targetPos;

// スコア
int score = 0;

// キーの状態を保持するための変数
boolean[] keyState = new boolean[256];

void setup() {
  size(800, 600, P3D);
  resetTarget();
}

void draw() {
  background(200);
  lights();
  
  translate(width / 2, height / 2, -500);
  rotateX(rotX);
  rotateY(rotY);
  
  updateAngles();
  
  PVector armEndPos = drawRobot(); // ロボットを描画し、末端の位置を取得
  
  drawTarget();
  
  checkCollision(armEndPos);
}

PVector drawRobot() {
  pushMatrix();
  translate(0, 125, 0);
  rotateY(baseAngle);
  translate(0, 125, 0);
  fill(150);
  box(100, 100, 50);

  translate(0, -50, 0);
  rotateZ(angle1);
  translate(0, -50, 0);
  fill(100, 100, 250);
  box(20, 100, 20);
  
  translate(0, -50, 0);
  rotateZ(angle2);
  translate(0, -75, 0);
  fill(100, 250, 100);
  box(20, 150, 20);
  
  translate(0, -75, 0);
  rotateZ(angle3);
  translate(0, -50, 0);
  fill(250, 100, 100);
  box(20, 100, 20);
  
  // 末端の位置を計算
  PVector armEndPos = new PVector(0, -50, 0);
  armEndPos = armEndPos.add(new PVector(0, -100, 0)); // 第1関節
  armEndPos = armEndPos.add(new PVector(0, -150, 0)); // 第2関節
  armEndPos = armEndPos.add(new PVector(0, -100, 0)); // 第3関節
  armEndPos = new PVector(modelX(armEndPos.x, armEndPos.y, armEndPos.z), modelY(armEndPos.x, armEndPos.y, armEndPos.z), modelZ(armEndPos.x, armEndPos.y, armEndPos.z));
  
  popMatrix();
  
  return armEndPos; // 末端の実際の位置を返す
}

void drawTarget() {
  pushMatrix();
  translate(targetPos.x, targetPos.y, targetPos.z);
  fill(255, 215, 0);
  sphere(20);
  popMatrix();
}

void keyPressed() {
  keyState[key] = true;
}

void keyReleased() {
  keyState[key] = false;
}

void updateAngles() {
  if (keyState['z']) {
    baseAngle += radians(5);
  } else if (keyState['x']) {
    baseAngle -= radians(5);
  }
  if (keyState['q']) {
    angle1 += radians(5);
  } else if (keyState['a']) {
    angle1 -= radians(5);
  }
  if (keyState['w']) {
    angle2 += radians(5);
  } else if (keyState['s']) {
    angle2 -= radians(5);
  }
  if (keyState['e']) {
    angle3 += radians(5);
  } else if (keyState['d']) {
    angle3 -= radians(5);
  }
}

void mouseDragged() {
  float rate = 0.01;
  rotY += (mouseX - pmouseX) * rate;
  rotX += (mouseY - pmouseY) * rate;
}

void checkCollision(PVector armEndPos) {
  // 末端とターゲットの距離を計算
  float distance = PVector.dist(armEndPos, targetPos);
  
  // 衝突判定の閾値
  float collisionThreshold = 30; // 適宜調整
  
  if (distance < collisionThreshold) {
    score++; // スコアを増やす
    println("Score: " + score); // コンソールにスコアを表示
    resetTarget(); // ターゲットをリセット
  }
}

void resetTarget() {
  // ターゲットを新たな位置に設定
  targetPos = new PVector(random(-200, 200), random(-200, 200), random(-200, 200));
}
