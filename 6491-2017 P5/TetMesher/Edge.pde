class Edge
{
  pt a,b;
  
  Edge(pt a_,pt b_)
  {
    a = a_;
    b = b_;
  }
}

// check if two edge has intersection and don't share a  same start point
boolean EdgeIntersection(Edge e1,Edge e2)
{
  if(abs(e1.a.x - e2.a.x) < 0.00001f && abs(e1.a.y - e2.a.y) < 0.00001f
  || abs(e1.a.x - e2.b.x) < 0.00001f && abs(e1.a.y - e2.b.y) < 0.00001f
  || abs(e1.b.x - e2.a.x) < 0.00001f && abs(e1.b.y - e2.a.y) < 0.00001f
  || abs(e1.b.x - e2.b.x) < 0.00001f && abs(e1.b.y - e2.b.y) < 0.00001f)
  return false;
  
  vec AB = V(e1.a,e1.b);
  AB.z = 0;
  
  vec CD = V(e2.a,e2.b);
  CD.z = 0;
  
  vec AC = V(e1.a,e2.a);
  AC.z = 0;
  
  vec AD = V(e1.a,e2.b);
  AD.z = 0;
  
  vec CA = V(e2.a,e1.a);
  CA.z = 0;
  
  vec CB = V(e2.a,e1.b);
  CB.z = 0;
 
  
  return (cross(AB,AC).z > 0 != cross(AB,AD).z > 0) && (cross(CD,CA).z > 0 != cross(CD,CB).z > 0);
  
}
// check if two edges are same in 2D;
boolean SameEdge(Edge e1,Edge e2)
{
  if(abs(e1.a.x - e2.a.x) < 0.00001f && abs(e1.a.y - e2.a.y) < 0.000001f && abs(e1.b.x - e2.b.x) < 0.0001f && abs(e1.b.y - e2.b.y) < 0.0001f)
  return true;
  
  if(abs(e1.a.x - e2.b.x) < 0.00001f && abs(e1.a.y - e2.b.y) < 0.000001f && abs(e1.b.x - e2.a.x) < 0.0001f && abs(e1.b.y - e2.a.y) < 0.0001f)
  return true;
  
  return false;
}
// check if two edges are same in 3D;
boolean SameEdge3D(Edge e1,Edge e2)
{
    if(abs(e1.a.x - e2.a.x) < 0.00001f && abs(e1.a.y - e2.a.y) < 0.00001f && abs(e1.a.z - e2.a.z) < 0.00001f
    && abs(e1.b.x - e2.b.x) < 0.0001f && abs(e1.b.y - e2.b.y) < 0.0001f && abs(e1.b.z - e2.b.z) < 0.0001f)
  return true;
  
  if(abs(e1.a.x - e2.b.x) < 0.00001f && abs(e1.a.y - e2.b.y) < 0.00001f && abs(e1.a.z - e2.b.z) < 0.00001f
  && abs(e1.b.x - e2.a.x) < 0.0001f && abs(e1.b.y - e2.a.y) < 0.0001f && abs(e1.b.z - e2.a.z) < 0.0001f)
  return true;
  
  return false;
  
}

// Add edge to the edge buffer but ignore the same edge(3D)
boolean AddEdge3D(ArrayList<Edge> ebuffer,Edge e)
{
  boolean findflag = false;
  for(int i = 0; i < ebuffer.size();i++)
  {
    if(SameEdge3D(ebuffer.get(i),e))
    {
         findflag = true;
         break;
    }
 
  }
  if(!findflag)
  {
    ebuffer.add(e);
    return true;
  }
  else
  {
    return false;
  }
}

// Add edge to the edge buffer but ignore the same edge(2D)
void AddEdge(ArrayList<Edge> ebuffer,Edge e)
{
  boolean findflag = false;
  for(int i = 0; i < ebuffer.size();i++)
  {
    if(SameEdge(ebuffer.get(i),e))
    {
         findflag = true;
         break;
    }
 
  }
  if(!findflag)
  {
    ebuffer.add(e);
  }
  
  
}