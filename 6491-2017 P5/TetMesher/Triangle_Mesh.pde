

ArrayList<pt> vertices = new ArrayList<pt>();
ArrayList<vec> vertex_normal = new ArrayList<vec>();
Triangle firstTri;

int ball_number = 5;
int ball_circle = 10;
int tube_number = 25;
int tube_circle = 7;
float test_radius = 13;

class Ball
{
  
  pt a;
  ArrayList<ArrayList<pt>> ball_vertices_a;
  ArrayList<ArrayList<pt>> ball_vertices_b;
  
  ArrayList<ArrayList<vec>> ball_normal_a;
  ArrayList<ArrayList<vec>> ball_normal_b;
  int resolution_ball = ball_number;
  int s_circlenumber = ball_circle;
  
  Ball(){VerticesArrayInit();}
  
  void VerticesArrayInit()
  {
    ball_vertices_a = new ArrayList<ArrayList<pt>>();
    ball_vertices_b = new ArrayList<ArrayList<pt>>();
    ball_normal_a = new ArrayList<ArrayList<vec>>();
    ball_normal_b = new ArrayList<ArrayList<vec>>();
    
    for(int i = 0; i < resolution_ball;i++)
    {
      ArrayList<pt> temp_array = new ArrayList<pt>();
      ball_vertices_a.add(temp_array);
      
      ArrayList<pt> temp_array2 = new ArrayList<pt>();
      ball_vertices_b.add(temp_array2);
      
      ArrayList<vec> temp_array3 = new ArrayList<vec>();
      ball_normal_a.add(temp_array3);
      
      ArrayList<vec> temp_array4 = new ArrayList<vec>();
      ball_normal_b.add(temp_array4);
    }
  }
  
  void Generate_BallA()
  {
     int number = s_circlenumber; // vertices number of a cross section of the tube;
    vec normal = new vec(0,0,1);
    for(int i = 0; i < ball_vertices_a.size();i++)
    {
      vec temp_vec = V(rb,U(normal));
      pt end_point = P(a,temp_vec);
      
      float t = (float)i / (ball_vertices_a.size() - 1);
      pt center = L(a,t,end_point);
      
     vec dir_x = U(cross(normal,new vec(0,1,1)));
     vec dir_y = U(cross(normal,dir_x));
     
     vec start_dir = dir_x;
     float delta_angle = 2 * PI / (number - 1);
     float radius = sqrt(1 - t * t) * rb;
     
      for(int j = 0; j < number;j++)
      {
        vec dir = U(R(start_dir,delta_angle * j,dir_x,dir_y));
        dir = V(radius,dir);
        pt temp_vertex = P(center,dir);
        ball_vertices_a.get(i).add(temp_vertex);
        
        vec temp_normal = U(V(a,temp_vertex));
        ball_normal_a.get(i).add(temp_normal);
        
       //  pt test = P(a,10,temp_normal);
       //  beam(temp_vertex,test,rm);
         
         vertices.add(temp_vertex);
         vertex_normal.add(temp_normal);
      }
    }
  }
  void Generate_BallB()
  {
     int number = s_circlenumber; // vertices number of a cross section of the tube;
    vec normal = new vec(0,0,1);
    for(int i = 0; i < ball_vertices_b.size();i++)
    {
      vec temp_vec = V(-rb,U(normal));
      pt end_point = P(a,temp_vec);
      
      float t = (float)i / (ball_vertices_b.size() - 1);
      pt center = L(a,t,end_point);
      
     vec dir_x = U(cross(normal,new vec(0,1,1)));
     vec dir_y = U(cross(normal,dir_x));
     
     vec start_dir = dir_x;
     float delta_angle = 2 * PI / (number - 1);
     float radius = sqrt(1 - t * t) * rb;
     
      for(int j = 0; j < number;j++)
      {
        vec dir = U(R(start_dir,delta_angle * j,dir_x,dir_y));
        dir = V(radius,dir);
        pt temp_vertex = P(center,dir);
        ball_vertices_b.get(i).add(temp_vertex);
        
        vec temp_normal = U(V(temp_vertex,a));
        ball_normal_b.get(i).add(temp_normal);
        
        vertices.add(temp_vertex);
        vertex_normal.add(temp_normal);
       //  pt test = P(a,10,temp_normal);
       //  beam(temp_vertex,test,rm);
      }
    }
  }
  
  
  
  void Render(ArrayList<ArrayList<pt>> vertices,ArrayList<ArrayList<vec>> normals)
  {
    for(int i = 0; i < vertices.size() - 1;i++)
    {
      for(int j = 0; j < vertices.get(i).size();j++)
      {
        int next_j = (j + 1) % (vertices.get(i).size());

        beginShape();
        normal(normals.get(i).get(j));
        vertex(vertices.get(i).get(j));
        
        normal(normals.get(i).get(next_j));
        vertex(vertices.get(i).get(next_j));
        
        normal(normals.get(i + 1).get(next_j));
        vertex(vertices.get(i + 1).get(next_j));

        endShape();


        beginShape();
        
        normal(normals.get(i).get(j));
        vertex(vertices.get(i).get(j));

        normal(normals.get(i + 1).get(next_j));
        vertex(vertices.get(i + 1).get(next_j));
        
        normal(normals.get(i + 1).get(j));
        vertex(vertices.get(i + 1).get(j));
        
        endShape();
 
      }
    }
  }
  
  void Render()
  {
    Render(ball_vertices_a,ball_normal_a);
    Render(ball_vertices_b,ball_normal_b);
  }
  
  
}
class Tube
{
  float r; // Radius of the ball and tube
  pt a,b; // Start and End Point
  
  ArrayList<ArrayList<pt>> tube_vertices;
  ArrayList<ArrayList<vec>> tube_normal;

  
  int resolution_tube = tube_number;
  int t_circlenumber = tube_circle;
  
  Tube()
  {
    VerticesArrayInit();
  };
  Tube(pt a_,pt b_)
  {
     a = a_;
     b = b_;
     
     VerticesArrayInit();
  }
  Tube(pt a_,pt b_,float r_)
  {
    a = a_;
    b = b_;
    r = r_; 
    
    VerticesArrayInit();
    
  }
  void VerticesArrayInit()
  {
    tube_vertices = new ArrayList<ArrayList<pt>>();
    for(int i = 0; i < resolution_tube;i++)
    {
      ArrayList<pt> temp_array = new ArrayList<pt>();
      tube_vertices.add(temp_array);
    }
    tube_normal = new ArrayList<ArrayList<vec>>();
    for(int i = 0; i < resolution_tube;i++)
    {
      ArrayList<vec> temp_array = new ArrayList<vec>();
      tube_normal.add(temp_array);
    }
    
    
  }
  
  void Generate_Tube()
  {
    int number = t_circlenumber; // vertices number of a cross section of the tube;
    vec normal = V(a,b);
    for(int i = 0; i < tube_vertices.size();i++)
    {
      float t = (float)i / (tube_vertices.size() - 1); 
      pt center = L(a,t,b);
      
     vec dir_x = U(cross(normal,new vec(0,1,1)));
     vec dir_y = U(cross(normal,dir_x));
     
     vec start_dir = dir_x;
     float delta_angle = 2 * PI / (number - 1);
     
     
      for(int j = 0; j < number;j++)
      {
        vec dir = U(R(start_dir,delta_angle * j,dir_x,dir_y));
        dir = V(rb,dir);
        pt temp_vertex = P(center,dir);
        tube_vertices.get(i).add(temp_vertex);
        
        vec temp_normal = U(dir);
        tube_normal.get(i).add(temp_normal);
        
        vertices.add(temp_vertex);
        vertex_normal.add(temp_normal);
      }
    }
  }

 void Render(ArrayList<ArrayList<pt>> vertices,ArrayList<ArrayList<vec>> normals)
  {
    for(int i = 0; i < vertices.size() - 1;i++)
    {
      for(int j = 0; j < vertices.get(i).size();j++)
      {
        int next_j = (j + 1) % (vertices.get(i).size());
        
        beginShape();
        normal(normals.get(i).get(j));
        vertex(vertices.get(i).get(j));
        
        normal(normals.get(i).get(next_j));
        vertex(vertices.get(i).get(next_j));
        
        normal(normals.get(i + 1).get(next_j));
        vertex(vertices.get(i + 1).get(next_j));

        endShape();


        beginShape();
        
        normal(normals.get(i).get(j));
        vertex(vertices.get(i).get(j));

        normal(normals.get(i + 1).get(next_j));
        vertex(vertices.get(i + 1).get(next_j));
        
        normal(normals.get(i + 1).get(j));
        vertex(vertices.get(i + 1).get(j));
        
        endShape();
 
      }
    }
    
   
    
  }
  
  
  void Render(ArrayList<ArrayList<pt>> vertices)
  {
    for(int i = 0; i < vertices.size() - 1;i++)
    {
      for(int j = 0; j < vertices.get(i).size();j++)
      {
        int next_j = (j + 1) % (vertices.get(i).size());
        
        beginShape();
        vertex(vertices.get(i).get(j));
        vertex(vertices.get(i).get(next_j));
        vertex(vertices.get(i + 1).get(next_j));
        endShape();

        beginShape();
        vertex(vertices.get(i).get(j));
        vertex(vertices.get(i + 1).get(next_j));
        vertex(vertices.get(i + 1).get(j));
        endShape();
 
      }
    }
  }
  void Render()
  {
    Render(tube_vertices,tube_normal); 
  }
  
   void GenerateFirstTri()
    {
      int i = int(tube_vertices.size() / 2.0f);
      int j = int(tube_vertices.get(i).size() / 2.0f);
      
      firstTri = new Triangle(tube_vertices.get(i).get(j),tube_vertices.get(i).get(j + 1),tube_vertices.get(i + 1).get(j + 1));
      firstTri.normal = tube_normal.get(i).get(j);
    }
  
}

void Render_TriMesh(boolean stroke,boolean render)
{
  vertices.clear();
  if(stroke)
  {
    stroke(1);
    strokeWeight(1);
  }
  else
  {
    noStroke();
  }

  fill(red);
  //fill(orange);
  for(int t = 0; t < edge_floor.size();t++)
  {
    Tube temp = new Tube(edge_floor.get(t).a,edge_floor.get(t).b);
    temp.Generate_Tube();

  if(render)
    temp.Render();
  }
  
  //fill(blue);
  for(int t = 0; t < edge_ceiling.size();t++)
  {
    Tube temp = new Tube(edge_ceiling.get(t).a,edge_ceiling.get(t).b);
    temp.Generate_Tube();

   if(render)
    temp.Render();
  }
  
  //fill(red);
  for(int t = 0; t < tetrahedron.size(); t++)
  {
    Tube temp = new Tube(tetrahedron.get(t).a,tetrahedron.get(t).b);
    temp.Generate_Tube();
    
    if(t == 0)
    temp.GenerateFirstTri();

    if(render)
    temp.Render();
  } 
  
  for(int t = 0; t < Q.nv; t++)
  {
    Ball ball = new Ball();
    ball.a = Q.G[t];
    
    ball.Generate_BallA();
    ball.Generate_BallB();
    
    if(render)
    ball.Render();
    
  }
  
  for(int t = 0; t < P.nv; t++)
  {
    Ball ball = new Ball();
    ball.a = P.G[t];
    ball.Generate_BallA();
    ball.Generate_BallB();
    
    if(render)
    ball.Render();
    
  }
  
  println(vertices.size());

}
 