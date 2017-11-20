// Calculate the Sphere Center with a triangle and a radius r
pt SphereCenter(pt A,pt B,pt C,float r)
{
  pt result = new pt();
  
  vec AB = V(A,B);
  vec AC = V(A,C);
  
  Triangle temp_tri = new Triangle(A,B,C);
  pt center = CircleTri(temp_tri);
  
  vec BP = V(B,center);
  vec N = U(cross(AB,AC));
  
  float t1 =  (r * r - n2(BP));
   // float error
  if(t1 < 0 && t1 > -0.1)
  t1 = 0;
  
  float t2 = dot(N,BP) * dot(N,BP);
  float t3 = dot(N,BP);
  
  float s = sqrt(t1 + t2) - t3;
  
  result = P(center,s,N);
  
  return result;
  
}

//Calculate sphere center for (3,1)(floor 3,ceiling 1 or the opposite) condition
pt SphereCenter(Triangle tri,pt p)
{
  pt A = tri.a;
  pt B = tri.b;
  pt C = tri.c;
  pt center = CircleTri(tri);
  
  vec AB = V(A,B);
  vec AC = V(A,C);
  vec DB = V(p,B);
  vec normal = N(AB,AC);
  vec DB_norm = U(DB);
  vec DP = V(p,center);
  
  float s = (dot(DB,DB_norm) / 2.0f -  dot(DP,DB_norm)) / dot(normal,DB_norm);
  
  pt result = P(center,s,normal);
  
  return result;
}

// Sphere center used for Floor 2, Ceiling 2 condition;
pt SphereCenter(pt a,pt b, pt c, pt d)
{  
  
   float x1 = a.x,y1 = a.y,z1 = a.z; 
   float x2 = b.x,y2 = b.y,z2 = b.z; 
   float x3 = c.x,y3 = c.y,z3 = c.z; 
   float x4 = d.x,y4 = d.y,z4 = d.z; 

  
    float a11,a12,a13,a21,a22,a23,a31,a32,a33,b1,b2,b3,d0,d1,d2,d3;  
    a11=2*(x2-x1); a12=2*(y2-y1); a13=2*(z2-z1);  
    a21=2*(x3-x2); a22=2*(y3-y2); a23=2*(z3-z2);  
    a31=2*(x4-x3); a32=2*(y4-y3); a33=2*(z4-z3);  
    b1=x2*x2-x1*x1+y2*y2-y1*y1+z2*z2-z1*z1;  
    b2=x3*x3-x2*x2+y3*y3-y2*y2+z3*z3-z2*z2;  
    b3=x4*x4-x3*x3+y4*y4-y3*y3+z4*z4-z3*z3;  
    d0=a11*a22*a33+a12*a23*a31+a13*a21*a32-a11*a23*a32-a12*a21*a33-a13*a22*a31;  
    d1=b1*a22*a33+a12*a23*b3+a13*b2*a32-b1*a23*a32-a12*b2*a33-a13*a22*b3;  
    d2=a11*b2*a33+b1*a23*a31+a13*a21*b3-a11*a23*b3-b1*a21*a33-a13*b2*a31;  
    d3=a11*a22*b3+a12*b2*a31+b1*a21*a32-a11*b2*a32-a12*a21*b3-b1*a22*a31;  
    pt result = new pt();
    result.x=d1/d0;  
    result.y=d2/d0;  
    result.z=d3/d0; 
    
    return result;
}  

// Calculate the Sphere Center with a triangle, a radius r and a correct normal vector
pt SphereCenter(pt A,pt B,pt C,float r,vec nor)
{
  pt result = new pt();
  
  vec AB = V(A,B);
  vec AC = V(A,C);
  
  Triangle temp_tri = new Triangle(A,B,C);
  
  pt center = CircleTri(temp_tri);
  
  vec BP = V(B,center);
  
  vec N = U(cross(AB,AC));
  if(dot(N,nor) < 0)
  {
    N = V(-1,N);
  }
  
  

  float t1 =  (r * r - n2(BP));
   
   // float error
  if(t1 < 0 && t1 > -0.1)
  t1 = 0;
  
  float t2 = dot(N,BP) * dot(N,BP);
  float t3 = dot(N,BP);
  
  float s = sqrt(t1 + t2) - t3;
  
  result = P(center,s,N);
  
  return result;
  
}

pt SphereCenter(Triangle tri,float r)
{
  return SphereCenter(tri.a,tri.b,tri.c,r);

}
pt SphereCenter(Triangle tri,float r,vec nor)
{
  return SphereCenter(tri.a,tri.b,tri.c,r,nor);

}

// Calculate the radius of circumcircle
float CircleTri_radius(pt A,pt B,pt C)
{
  Triangle temp_tri = new Triangle(A,B,C);
  return CircleTri_radius(temp_tri);
}

// Calculate the center of circumcircle
pt CircleTri(Triangle tri)
{
  pt A = tri.a;
  pt B = tri.b;
  pt C = tri.c;
  
  vec AB = V(A,B);
  vec AC = V(A,C);
  vec BC = V(B,C);
  
  vec normal = N(AB,AC);
  vec u = N(normal,AB);
  vec AC_norm = U(AC);
  
  float t = dot(AC_norm,BC) / (2 * dot(u,AC_norm));
  
  pt temp = new pt();
  temp.x = (tri.a.x + tri.b.x) / 2.0f;
  temp.y = (tri.a.y + tri.b.y) / 2.0f;
  temp.z = (tri.a.z + tri.b.z) / 2.0f;
  
  pt P = P(temp,t,u);
  
  return P;
}

float CircleTri_radius(Triangle tri)
{
  pt center = CircleTri(tri);
  
  return sqrt(sq(tri.a.x - center.x) + sq(tri.a.y - center.y));
  
}