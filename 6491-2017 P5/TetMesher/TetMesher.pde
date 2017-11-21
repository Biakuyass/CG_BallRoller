//  ******************* LITM: Layer-Interpolating Tet Mesh, 2017 ***********************
Boolean 
  animating=true, 
  PickedFocus=false, 
  center=true, 
  track=false, 
  showViewer=false, 
  showBalls=true, 
  showControl=true, 
  showCurve=true, 
  showPath=true, 
  showKeys=true, 
  showSkater=false, 
  scene1=false, 
  solidBalls=false, 
  showCorrectedKeys=true, 
  showQuads=true, 
  showVecs=true, 
  showTube=true, 
  flipped = false;
float 
  h_floor=0, h_ceiling=600, h=h_floor, 
  t=0, 
  s=0, 
  rb=30, rt=rb/2, // radius of the balls and tubes
  rm = 1;
int
  f=0, maxf=2*30, level=4, method=5, choice = 1;
String SDA = "angle";
float defectAngle=0;
pts P = new pts(); // polyloop in 3D
pts Q = new pts(); // second polyloop in 3D
pts R, S; 

int count = 0;
int size_record = 1;
boolean complete_flag = false;


void setup() {
  myFace = loadImage("data/pic.jpg");  // load image from file pic.jpg in folder data *** replace that file with your pic of your own face
  textureMode(NORMAL);          
  size(900, 900, P3D); // P3D means that we will do 3D graphics
  //size(600, 600, P3D); // P3D means that we will do 3D graphics
  P.declare(); 
  Q.declare(); // P is a polyloop in 3D: declared in pts
  //P.resetOnCircle(6,100); Q.copyFrom(P); // use this to get started if no model exists on file: move points, save to file, comment this line
  P.loadPts("data/pts");  
  Q.loadPts("data/pts2"); // loads saved models from file (comment out if they do not exist yet)
  noSmooth();
  frameRate(30);
  R=P; 
  S=Q;
}
int test = 0;
void draw() {

  // lights();
  background(255);
  hint(ENABLE_DEPTH_TEST); 
  pushMatrix();   // to ensure that we can restore the standard view before writing on the canvas
  setView();  // see pick tab
  showFloor(h); // draws dance floor as yellow mat
  doPick(); // sets Of and axes for 3D GUI (see pick Tab)
  R.SETppToIDofVertexWithClosestScreenProjectionTo(Mouse()); // for picking (does not set P.pv)

  // Prepare for Delaunay calculation
  Init();
  Init_Floor();
  Delaunay_Floor();
  Init_Ceiling();
  Delaunay_Ceiling();
  // Calculate Delauney in 3D space
  Delaunay_3D();

  //Delaunay Triangle without ball pivot
  if (choice == 1)
  {
    fill(orange); 
    P.drawBalls(rb);
    fill(green); 
    Q.drawBalls(rb);  
    fill(red, 100); 
    R.showPicked(rb+5); 

    Render();
    buffer_reset();
  } else if (choice == 2) // Generate and the vertices of the tubes and balls and render the triangle mesh with stroke
  {
    buffer_reset();
    Render_TriMesh(true, true);
  } else if (choice == 3) 
  {
    buffer_reset();
    Render_TriMesh(false, true); // Generate and the vertices of the tubes and balls and render the triangle mesh without stroke
  } else if (choice == 4 )
  {
    if (pendingTriangles.size() <= 0 && !complete_flag)
    {
      BallPivot_Clear();
      Render_TriMesh(false, false);
      BallPivot_Init();
    }

    BallPivot(vertices);
    stroke(1);
    fill(green);
    Render_BallPivot();
  } else if (choice == 5)
  {
    fill(orange); 
    P.drawBalls(rb);
    fill(green); 
    Q.drawBalls(rb);  
    fill(red, 100); 
    R.showPicked(rb+5);

    pendingTriangles.clear();

    BallPivot_Clear();
    BallPivot_Init();
    fill(green);
    BallPivot(test_vertex);
    Render_BallPivot();  

    buffer_reset();
  }


  // Test for Delaunay Tetrahedron
  /*if(!ValidTest())
   {
   println("Error" + test++);
   }*/



  popMatrix(); // done with 3D drawing. Restore front view for writing text on canvas
  hint(DISABLE_DEPTH_TEST); // no z-buffer test to ensure that help text is visible

  //*** TEAM: please fix these so that they provice the correct counts
  scribeHeader("Site count: "+3+" floor + "+7+" ceiling", 1);
  scribeHeader("Beam count: "+3+" floor + "+7+" ceiling +"+6+" mixed", 2);
  scribeHeader("Tet count: "+20, 3);

  // used for demos to show red circle when mouse/key is pressed and what key (disk may be hidden by the 3D model)
  if (mousePressed) {
    stroke(cyan); 
    strokeWeight(3); 
    noFill(); 
    ellipse(mouseX, mouseY, 20, 20); 
    strokeWeight(1);
  }
  if (keyPressed) {
    stroke(red); 
    fill(white); 
    ellipse(mouseX+14, mouseY+20, 26, 26); 
    fill(red); 
    text(key, mouseX-5+14, mouseY+4+20); 
    strokeWeight(1);
  }
  if (scribeText) {
    fill(black); 
    displayHeader();
  } // dispalys header on canvas, including my face
  if (scribeText && !filming) displayFooter(); // shows menu at bottom, only if not filming
  if (filming && (animating || change)) saveFrame("FRAMES/F"+nf(frameCounter++, 4)+".tif");  // save next frame to make a movie
  change=false; // to avoid capturing frames when nothing happens (change is set uppn action)
  change=true;
}