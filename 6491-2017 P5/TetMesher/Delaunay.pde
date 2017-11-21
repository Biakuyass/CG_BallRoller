class Triangle
{
  pt a,b,c;
  
  int ai,bi,ci;
  
  vec normal;
  Triangle(pt a_,pt b_,pt c_)
  { 
    a = a_;
    b = b_;
    c = c_;
    
    //vec AB = V(a,b);
    //vec BC = V(b,c);
    //vec AC = V(a,c);
    
   // println(cw(AB,BC,AC));
  }
}

class Tetrahedron
{
  pt a,b,c,d;
  Tetrahedron(pt a_,pt b_,pt c_,pt d_)
  { 
    a = a_;
    b = b_;
    c = c_;
    d = d_;
  }
}

// Edge buffer for the final tetrahedrons
ArrayList<Edge> tetrahedron = new ArrayList<Edge>();
ArrayList<Tetrahedron> tet = new ArrayList<Tetrahedron>(); // for test

//buffers used in floor Delaunay
ArrayList<Triangle>  temp_triangles = new ArrayList<Triangle>();
ArrayList<Triangle>  triangles = new ArrayList<Triangle>();
ArrayList<Edge> edge_floor = new ArrayList<Edge>();

//buffers used in ceiling Delaunay
ArrayList<Triangle>  temp_triangles_ceiling = new ArrayList<Triangle>();
ArrayList<Triangle>  triangles_ceiling  = new ArrayList<Triangle>();
ArrayList<Edge> edge_ceiling = new ArrayList<Edge>();


// Temp edge buffers
ArrayList<Edge>  edgebuffer;
ArrayList<Edge>  edgebuffer_Insert;

// Huge Triange for Initial setting
Triangle hugeTri;
Triangle hugeTri_Cell;

//Area that contains the points (2D)
float left,right,bottom,top;

//Indices for P and Q
int [] indices_P;
int [] indices_Q;

//Init indices and the huge triangle to calculate Delaunay on the plane
void Init()
{
  for(int i = 0; i < P.nv;i++)
 {
  P.G[i].z = h_floor;
 }
 for(int i = 0; i < Q.nv;i++)
 {
  Q.G[i].z = h_ceiling;
 }
   edge_floor.clear();
   edge_ceiling.clear();
   tetrahedron.clear();
   tet.clear();
   
}
void Init_Floor()
{

  //floor
  temp_triangles.clear();
  triangles.clear();
  
  indices_P = InitIndices(P);
  hugeTri = InitHugeTri(P);
  
  
  temp_triangles.add(hugeTri);
  //triangles.add(hugeTri);


}
//Init indices and the huge triangle to calculate Delaunay on the plane
void Init_Ceiling()
{
   //celling
  temp_triangles_ceiling.clear();
  triangles_ceiling.clear();
  
  
  indices_Q = InitIndices(Q);
  hugeTri_Cell = InitHugeTri(Q);
  
  temp_triangles_ceiling.add(hugeTri_Cell);
}


void Render()
{
  fill(orange);
  for(int t = 0; t < edge_floor.size();t++)
  {
    pt temp_a = edge_floor.get(t).a;
    pt temp_b = edge_floor.get(t).b;
    beam(temp_a,temp_b,rt);
  }
  
  fill(blue);
  for(int t = 0; t < edge_ceiling.size();t++)
  {
    pt temp_a = edge_ceiling.get(t).a;
    pt temp_b = edge_ceiling.get(t).b;
    beam(temp_a,temp_b,rt);
  }
  for(int i = 0; i < tetrahedron.size(); i++)
  {
      fill(red);
      beam(tetrahedron.get(i).a,tetrahedron.get(i).b,rt);
  } 
}


//Calculate Delaunay in 3D
void Delaunay_3D()
{
    //Floor 3, Ceiling 1
    for(int i = 0; i < triangles.size(); i++)
    {
      int index_record = 0;
      float bulgeRecord = 10000000;
      // find the min bulge
      for(int j = 0; j < Q.nv; j++)
      {
        float bul = bulge(triangles.get(i),Q.G[j]);
        if(bul < bulgeRecord)
        {
          bulgeRecord = bul;
          index_record = j;
        }
      }
      Triangle temp_tri = triangles.get(i);

      
      pt A = temp_tri.a;
      pt B = temp_tri.b;
      pt C = temp_tri.c;
      pt D = Q.G[index_record];
      

      Edge AD = new Edge(A,D);

      Edge BD = new Edge(B,D);
      Edge CD = new Edge(C,D);
      
       //Add correspoinding edges to edge buffer
      AddEdge3D(tetrahedron,AD);
      AddEdge3D(tetrahedron,BD);
      AddEdge3D(tetrahedron,CD); 
      
      // for test
      Tetrahedron temp_tet = new Tetrahedron(A,B,C,D);
      tet.add(temp_tet);
    }
    
    
    //Floor 1, Ceiling 3
    for(int i = 0; i < triangles_ceiling.size(); i++)
    {
      int index_record = 0;
      float bulgeRecord = 10000000;
      // find the min bulge
      for(int j = 0; j < P.nv; j++)
      {
        float bul = bulge_ceiling(triangles_ceiling.get(i),P.G[j]);
        if(bul < bulgeRecord)
        {
          bulgeRecord = bul;
          index_record = j;
        }
      }
      Triangle temp_tri = triangles_ceiling.get(i);

      
      pt A = temp_tri.a;
      pt B = temp_tri.b;
      pt C = temp_tri.c;
      pt D = P.G[index_record];

      Edge AD = new Edge(A,D);
      Edge BD = new Edge(B,D);
      Edge CD = new Edge(C,D);
      
      //Add correspoinding edges to edge buffer
      AddEdge3D(tetrahedron,AD);
      AddEdge3D(tetrahedron,BD);
      AddEdge3D(tetrahedron,CD);
      
      // for test
      Tetrahedron temp_tet = new Tetrahedron(A,B,C,D);
      tet.add(temp_tet);
    }
    

    
    //floor 2 ceiling 2
    for(int i = 0; i < edge_floor.size(); i++)
    {
      
      pt A,B,C,D;
      A = edge_floor.get(i).a;
      B = edge_floor.get(i).b;
      for(int j = 0; j < edge_ceiling.size(); j++)
      {
        boolean flag = true;
        C = edge_ceiling.get(j).a;
        D = edge_ceiling.get(j).b;
        pt center = SphereCenter(A,B,C,D);
        float radius = d(center,A);
        
        for(int m = 0; m < P.nv; m++)
        {
          if(d(P.G[m],center) < radius - 1)
          {
          flag = false;
          break;
          }

          
        }
        for(int k = 0; k < Q.nv; k++)
        {
          if(d(Q.G[k],center) < radius - 1)
          {
          flag = false;
          break;
          }

        }
        
        
        if(flag)
        {
          Edge AC = new Edge(A,C);
          Edge AD = new Edge(A,D);
          Edge BC = new Edge(B,C);
          Edge BD = new Edge(B,D);
      
      
          //AddEdge3D(tetrahedron,AB);
          AddEdge3D(tetrahedron,AC);
          AddEdge3D(tetrahedron,AD);
          AddEdge3D(tetrahedron,BC);
          AddEdge3D(tetrahedron,BD);
          
       // for test
      Tetrahedron temp_tet = new Tetrahedron(A,B,C,D);
      tet.add(temp_tet);
        }
      
      }
      
      
    }
}

//Calculate Delaunay for the Ceiling
void Delaunay_Ceiling()
{
  for(int i = 0; i < indices_Q.length; i++)
  {
    edgebuffer = new ArrayList<Edge>();
    edgebuffer_Insert = new ArrayList<Edge>();
    
    int index = indices_Q[i];
    
    
   // println(temp_triangles.size());
    for(int t = 0; t < temp_triangles_ceiling.size();t++)
    {
      Triangle temp_tri = temp_triangles_ceiling.get(t);
      
      pt center = CircleTri(temp_tri);
      float radius = CircleTri_radius(temp_tri);
      float max_x = center.x + radius;
      
      float distance = sqrt(sq(Q.G[index].x - center.x) + sq(Q.G[index].y - center.y));
      
      // On the right side of the circumcircle
      if(Q.G[index].x > max_x)
      {
        triangles_ceiling.add(temp_tri);
        temp_triangles_ceiling.remove(t);
        t--;
        continue;
      }
      else if(distance > radius) // Not inclued by the circumcircle but not on the right side of it
      {
        continue;
      }
      else // Inclued by the circumcircle
      {
        
       // bad_triangles.add(temp_tri);
        Edge temp_ab = new Edge(temp_tri.a,temp_tri.b);
        Edge temp_bc = new Edge(temp_tri.b,temp_tri.c);
        Edge temp_ac = new Edge(temp_tri.a,temp_tri.c);
        
        
        AddEdge(edgebuffer,temp_ab);
        AddEdge(edgebuffer,temp_bc);
        AddEdge(edgebuffer,temp_ac);
        
        Edge temp_pa = new Edge(Q.G[index],temp_tri.a);
        Edge temp_pb = new Edge(Q.G[index],temp_tri.b);
        Edge temp_pc = new Edge(Q.G[index],temp_tri.c);
        
        AddEdge(edgebuffer_Insert,temp_pa);
        AddEdge(edgebuffer_Insert,temp_pb);
        AddEdge(edgebuffer_Insert,temp_pc);


        temp_triangles_ceiling.remove(t);
        t--;
      } 
    }
    
    //Delete old edges which have intersection with new edges
    for(int m = 0; m < edgebuffer.size();m++)
    {
      for(int k = 0; k < edgebuffer_Insert.size();k++)
      {
        if(EdgeIntersection(edgebuffer_Insert.get(k),edgebuffer.get(m)))
        {
          edgebuffer.remove(m);
          m--;
          break;
        }
      }
    }
    for(int m = 0; m < edgebuffer.size();m++)
    {
      pt tri_a = edgebuffer.get(m).a;
      pt tri_b = edgebuffer.get(m).b;
      pt tri_c = Q.G[index];
      Triangle tri = new Triangle(tri_a,tri_b,tri_c);
      temp_triangles_ceiling.add(tri);
    }
    
  }
  
  for(int t = 0; t < temp_triangles_ceiling.size();t++)
  {
    triangles_ceiling.add(temp_triangles_ceiling.get(t));
  }
  
  //Delete all triangles whose vertics include one of the vertics of huge triangle
  for(int t = 0; t < triangles_ceiling.size();t++)
  {
    pt temp_a = triangles_ceiling.get(t).a;
    pt temp_b = triangles_ceiling.get(t).a;
    pt temp_c = triangles_ceiling.get(t).a;
    
    if(temp_a.x > right || temp_a.x < left || temp_a.y > bottom || temp_a.y < top
     || temp_b.x > right || temp_b.x < left || temp_b.y > bottom || temp_b.y < top
     || temp_c.x > right || temp_c.x < left || temp_c.y > bottom || temp_c.y < top)
    {
      triangles_ceiling.remove(t);
      t--;
    }
    
  }
  
  //Add all edges to the ceiling edge buffer(for Floor 2 Ceiling 2 condition)
   for(int t = 0; t < triangles_ceiling.size();t++)
  {
    pt temp_a = triangles_ceiling.get(t).a;
    pt temp_b = triangles_ceiling.get(t).b;
    pt temp_c = triangles_ceiling.get(t).c;
    
      Edge AB = new Edge(temp_a,temp_b);
      Edge AC = new Edge(temp_a,temp_c);
      Edge BC = new Edge(temp_b,temp_c);
      
      AddEdge(edge_ceiling,AB);
      AddEdge(edge_ceiling,AC);
      AddEdge(edge_ceiling,BC);
  }
  
  
  

  
}
// Calculate Delaunay for the floor
void Delaunay_Floor()
{

  for(int i = 0; i < indices_P.length; i++)
  {
    edgebuffer = new ArrayList<Edge>();
    edgebuffer_Insert = new ArrayList<Edge>();
    
    int index = indices_P[i];
    
    
   // println(temp_triangles.size());
    for(int t = 0; t < temp_triangles.size();t++)
    {
      Triangle temp_tri = temp_triangles.get(t);
      
      pt center = CircleTri(temp_tri);
      float radius = CircleTri_radius(temp_tri);
      float max_x = center.x + radius;
      
      float distance = sqrt(sq(P.G[index].x - center.x) + sq(P.G[index].y - center.y));
      
      if(P.G[index].x > max_x)
      {
        triangles.add(temp_tri);
        temp_triangles.remove(t);
        t--;
        continue;
      }
      else if(distance > radius)
      {
        continue;
      }
      else
      {
      
        Edge temp_ab = new Edge(temp_tri.a,temp_tri.b);
        Edge temp_bc = new Edge(temp_tri.b,temp_tri.c);
        Edge temp_ac = new Edge(temp_tri.a,temp_tri.c);
        
        
        AddEdge(edgebuffer,temp_ab);
        AddEdge(edgebuffer,temp_bc);
        AddEdge(edgebuffer,temp_ac);
        
        Edge temp_pa = new Edge(P.G[index],temp_tri.a);
        Edge temp_pb = new Edge(P.G[index],temp_tri.b);
        Edge temp_pc = new Edge(P.G[index],temp_tri.c);
        
        AddEdge(edgebuffer_Insert,temp_pa);
        AddEdge(edgebuffer_Insert,temp_pb);
        AddEdge(edgebuffer_Insert,temp_pc);
        
        
        temp_triangles.remove(t);
        t--;
      } 
    }
     //Delete old edges which have intersection with new edges
    for(int m = 0; m < edgebuffer.size();m++)
    {
      for(int k = 0; k < edgebuffer_Insert.size();k++)
      {
        if(EdgeIntersection(edgebuffer_Insert.get(k),edgebuffer.get(m)))
        {
          edgebuffer.remove(m);
          m--;
          break;
        }
      }
      

    }
    for(int m = 0; m < edgebuffer.size();m++)
    {
      pt tri_a = edgebuffer.get(m).a;
      pt tri_b = edgebuffer.get(m).b;
      pt tri_c = P.G[index];
      Triangle tri = new Triangle(tri_a,tri_b,tri_c);
      temp_triangles.add(tri);
    }
    
  }
  
 // println(temp_triangles.size());
  for(int t = 0; t < temp_triangles.size();t++)
  {
    triangles.add(temp_triangles.get(t));
  }
  
  //Delete all triangles whose vertics include one of the vertics of huge triangle
  for(int t = 0; t < triangles.size();t++)
  {
    pt temp_a = triangles.get(t).a;
    pt temp_b = triangles.get(t).a;
    pt temp_c = triangles.get(t).a;
    
    if(temp_a.x > right || temp_a.x < left || temp_a.y > bottom || temp_a.y < top
     || temp_b.x > right || temp_b.x < left || temp_b.y > bottom || temp_b.y < top
     || temp_c.x > right || temp_c.x < left || temp_c.y > bottom || temp_c.y < top)
    {
      triangles.remove(t);
      t--;
    }
    
  }
  
  //Add all edges to the floor edge buffer(for Floor 2 Ceiling 2 condition)
  for(int t = 0; t < triangles.size();t++)
  {
    pt temp_a = triangles.get(t).a;
    pt temp_b = triangles.get(t).b;
    pt temp_c = triangles.get(t).c;
    
      Edge AB = new Edge(temp_a,temp_b);
      Edge AC = new Edge(temp_a,temp_c);
      Edge BC = new Edge(temp_b,temp_c);
      
      AddEdge(edge_floor,AB);
      AddEdge(edge_floor,AC);
      AddEdge(edge_floor,BC);
      
    
  }
 
  

  
}

// Calculate a huge triangle that contains all of the vertics on a plane
Triangle InitHugeTri(pts vertics)
{
  float max_x = vertics.G[0].x,min_x = vertics.G[0].x;
  float max_y = vertics.G[0].y,min_y = vertics.G[0].y;
  
  for(int i = 1; i < vertics.nv; i++)
  {
    max_x = vertics.G[i].x > max_x ? vertics.G[i].x : max_x;
    max_y = vertics.G[i].y > max_y ? vertics.G[i].y : max_y;
    
    min_x = vertics.G[i].x < min_x ? vertics.G[i].x : min_x;
    min_y = vertics.G[i].y < min_y ? vertics.G[i].y : min_y;
  }
  
  float z = vertics.G[0].z;
  
  pt a = new pt();
  pt b = new pt();
  pt c = new pt();
  
  float mid_x = (max_x + min_x) / 2.0f;
  
  float left_x = mid_x - (max_x - min_x) - 500;
  float right_x = mid_x + (max_x - min_x) + 500 ; 
  
  float bottom_y = max_y + 500;
  float top_y = min_y - (max_y - min_y) -500;
  
  a.x = left_x;
  a.y = bottom_y;
  a.z = z;
  
  b.x = mid_x;
  b.y = top_y;
  b.z = z;
  
  c.x = right_x;
  c.y = bottom_y;
  c.z = z;
  
  left = min_x;
  right = max_x;
  bottom = max_y;
  top = min_y;
  
  return new Triangle(a,b,c);
}

//sort the vertics from left to right;
int [] InitIndices(pts vertics)
{
  int [] indices = new int [vertics.nv];
  
  for(int i = 0; i < vertics.nv; i++)
  indices[i] = i;
  
  for(int i = 0; i < vertics.nv - 1;i++)
  {
    for(int j = i + 1;j < vertics.nv; j++)
    {
      int a = indices[i];
      int b = indices[j];
      
      if(vertics.G[b].x < vertics.G[a].x)
      {
        indices[i] = b;
        indices[j] = a;
      }
    }
  }
  return indices;
}

// Calculate bulge from floor
float bulge(Triangle tri,pt p)
{
  float result = 0;
  pt center = SphereCenter(tri,p);
  float radius = d(center,p);
  
  result = center.z + radius - h_floor;
  
  return result;
}

// Calculate bulge from ceiling
float bulge_ceiling(Triangle tri,pt p)
{
  float result = 0;
  pt center = SphereCenter(tri,p);
  float radius = d(center,p);
  
  result = abs(center.z - radius - h_ceiling);
  
  return result;
}

//Test if the result for Delaunay is correct
boolean ValidTest()
{
  
  boolean flag = true;
  
  
  for(int i = 0; i < tet.size();i++)
  {
        pt A = tet.get(i).a;
        pt B = tet.get(i).b;
        pt C = tet.get(i).c;
        pt D = tet.get(i).d;
        
        pt center = SphereCenter(A,B,C,D);
        float radius = d(center,A);
        
        for(int m = 0; m < P.nv; m++)
        {
          if(d(P.G[m],center) < radius - 1)
          {
          flag = false;
          break;
          }

          
        }
        for(int k = 0; k < Q.nv; k++)
        {
          if(d(Q.G[k],center) < radius - 1)
          {
          flag = false;
          break;
          }

        }
        
  }
  return flag;
}