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
 h_floor=0, h_ceiling=600,  h=h_floor,
  t=0, 
  s=0,
  rb=30, rt=rb/2, // radius of the balls and tubes
  rm = 1;
int
  f=0, maxf=2*30, level=4, method=5,choice = 1;
String SDA = "angle";
float defectAngle=0;
pts P = new pts(); // polyloop in 3D
pts Q = new pts(); // second polyloop in 3D
pts R, S; 
    

void setup() {
  myFace = loadImage("data/pic.jpg");  // load image from file pic.jpg in folder data *** replace that file with your pic of your own face
  textureMode(NORMAL);          
  size(900, 900, P3D); // P3D means that we will do 3D graphics
  //size(600, 600, P3D); // P3D means that we will do 3D graphics
  P.declare(); Q.declare(); // P is a polyloop in 3D: declared in pts
  //P.resetOnCircle(6,100); Q.copyFrom(P); // use this to get started if no model exists on file: move points, save to file, comment this line
  P.loadPts("data/pts");  
  Q.loadPts("data/pts2"); // loads saved models from file (comment out if they do not exist yet)
  noSmooth();
  frameRate(30);
  R=P; S=Q;
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
 
 
 for(int i = 0; i < P.nv;i++)
 {
  P.G[i].z = h_floor;
 }
 for(int i = 0; i < Q.nv;i++)
 {
  Q.G[i].z = h_ceiling;
 }
    

  if(showBalls) 
    {
   // fill(orange); P.drawBalls(rb);
   // fill(green); Q.drawBalls(rb);  
   // fill(red,100); R.showPicked(rb+5); 
    }
 // Prepare for Delaunay calculation
    Init();
    // Calculate Dalaunay triangles(Floor)
    Init_Floor();
    Delaunay_Floor();
    // Calculate Dalaunay triangles(Ceiling)
    Init_Ceiling();
    Delaunay_Ceiling();
    
   // Calculate Delauney in 3D space
    Delaunay_3D();
    
    //Delaunay Triangle without ball pivot
    if(choice == 1)
    {
     fill(orange); P.drawBalls(rb);
     fill(green); Q.drawBalls(rb);  
     fill(red,100); R.showPicked(rb+5); 
     Render();
    }
    else if(choice == 2) // Generate and the vertices of the tubes and balls and render the triangle mesh with stroke
    Render_TriMesh(true,true);
    else if(choice == 3) //
    {
      Render_TriMesh(false,true); // Generate and the vertices of the tubes and balls and render the triangle mesh without stroke 
      /*Tube test = new Tube(Q.G[0],P.G[0]);
      test.Generate_Tube();
      test.Generate_Ball();
      stroke(1);
      test.Render();*/
    }
    else if(choice == 4 )
    {
      //For test
      /*vertices.clear();
      Tube test = new Tube(Q.G[0],P.G[0]);
      test.Generate_Tube();
      test.GenerateFirstTri();
      println(vertices.size());*/
     // test.Render();    
         Render_TriMesh(false,false);
         fill(green);
         BallPivot_Init();
         BallPivot(vertices);
         Render_BallPivot();  
    }
    else if(choice == 5)
    {
       fill(orange); P.drawBalls(rb);
       fill(green); Q.drawBalls(rb);  
       fill(red,100); R.showPicked(rb+5);
     
       Render_TriMesh(false,false);
       fill(green);
         
       BallPivot_Init();
         //test
       BallPivot(test_vertex);
       Render_BallPivot();  
    }
    

    // Test for Delaunay Tetrahedron
    /*if(!ValidTest())
    {
      println("Error" + test++);
    }*/
    
    
    

    //Sphere center test
   /* pt pt_test = SphereCenter(triangles.get(0),Q.G[0]);
    beam(pt_test,triangles.get(0).a,rt);
    beam(pt_test,triangles.get(0).b,rt);
    beam(pt_test,triangles.get(0).c,rt);
    beam(pt_test,Q.G[0],rt);
    
    println(d(Q.G[0],pt_test));
    println(d(triangles.get(0).a,pt_test));
    println(d(triangles.get(0).b,pt_test));
    println(d(triangles.get(0).c,pt_test));*/
  /* Triangle test = InitHugeTri(P);
    
    beam(test.a,test.b,rt);
    beam(test.a,test.c,rt);
    beam(test.c,test.b,rt);*/
    
   // EdgeIntersection();
    
    /*pt pt_test = CircleTri(test);
    beam(pt_test,test.a,rt);
    beam(pt_test,test.b,rt);
    beam(pt_test,test.c,rt);*/
    //show(pt_test,rt);*/
    
    //Test for indices
   /* for(int i = 0; i < P.nv;i++)
    {
      println(indices_P[i] + "  " + P.G[indices_P[i]].z);
    }*/
    
   // println(P.G[0].x + "  " + P.G[0].y + "  " + P.G[0].z);
   // println(Q.G[0].x + "  " + Q.G[0].y + "  " + Q.G[0].z);
    
    
  // Tube a = new Tube();
  // println(a.tube_vertices.get(0).get(0).x);
    
    
  popMatrix(); // done with 3D drawing. Restore front view for writing text on canvas
  hint(DISABLE_DEPTH_TEST); // no z-buffer test to ensure that help text is visible

  //*** TEAM: please fix these so that they provice the correct counts
  scribeHeader("Site count: "+3+" floor + "+7+" ceiling",1);
  scribeHeader("Beam count: "+3+" floor + "+7+" ceiling +"+6+" mixed",2);
  scribeHeader("Tet count: "+20,3);
 
  // used for demos to show red circle when mouse/key is pressed and what key (disk may be hidden by the 3D model)
  if(mousePressed) {stroke(cyan); strokeWeight(3); noFill(); ellipse(mouseX,mouseY,20,20); strokeWeight(1);}
  if(keyPressed) {stroke(red); fill(white); ellipse(mouseX+14,mouseY+20,26,26); fill(red); text(key,mouseX-5+14,mouseY+4+20); strokeWeight(1); }
  if(scribeText) {fill(black); displayHeader();} // dispalys header on canvas, including my face
  if(scribeText && !filming) displayFooter(); // shows menu at bottom, only if not filming
  if(filming && (animating || change)) saveFrame("FRAMES/F"+nf(frameCounter++,4)+".tif");  // save next frame to make a movie
  change=false; // to avoid capturing frames when nothing happens (change is set uppn action)
  change=true;
  }