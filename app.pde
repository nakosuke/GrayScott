//gray scott model  2V + U \to 3V
int csize = 200;
float cell_width = 800.0 / float(csize);

float[][] state_u = new float[csize][csize];
float[][] state_v = new float[csize][csize];

float dx = 0.01;
float du = 2e-5;
float dv = 1e-5;
float dt = 1;

float f = 0.04, k = 0.06; //amorphous
//float f = 0.035, k = 0.065;  // spots
//float f = 0.012, k = 0.05;  // wandering bubbles
//float f = 0.025, k = 0.05;  // waves
//float f = 0.022, k = 0.051; // stripe
//float f = 0.026, k = 0.06; //tapioka1
//float f = 0.0208, k = 0.06; //tapioka2

void setup(){
  size(800,800);
  initialize();
  noStroke();
  frameRate(60);
}

void draw(){
  project();
  update_state();
}

void initialize(){
  int i,j;
  for( i = 0; i < csize; i++){
    for(j = 0; j < csize; j++){
      state_u[i][j] = 1;
      state_v[i][j] = 0;
    }
  }
  
  for( i = csize/2 - 10 ; i < csize/2 + 10; i++){
    for(j = csize/2 - 10 ; j < csize/2 + 10; j++){
      state_u[i][j] = 0.5;
      state_v[i][j] = 0.25;
    }
  }
  
  for( i = 0; i < csize; i++){
    for(j = 0; j < csize; j++){
      state_u[i][j] += 0.1   * random(0,1) ;
      state_v[i][j] += 0.1  * random(0,1) ;
    }
  }
}

void project(){
  int i,j;
  for( i =0; i < csize; i++){
    for( j =0 ; j < csize; j++){
      fill(255.0 * state_u[i][j]);
      rect( cell_width * j , cell_width * i , cell_width , cell_width);
    }
  }
}

void update_state(){
  int i,j;
  int t = 0 , count =16;   //16 reaction per 1 draw
  float[][] state_du = new float[csize][csize];
  float[][] state_dv = new float[csize][csize];
  
  float u,un,ue,uw,us;
  float v,vn,ve,vw,vs;
  int i_minus1, j_minus1, i_plus1, j_plus1;
  float uspread, vspread;
  
  for(t=count; t>0; t--){
    for(i=0; i<csize; i++){
      for(j=0; j<csize; j++){
         if(j==0) {j_minus1 = csize-1;}
         else     {j_minus1 = j-1;}
         if(i==0) {i_minus1 = csize-1;} 
         else     {i_minus1 = i-1;}
         if(j==csize-1) {j_plus1 = 0;}
         else          {j_plus1 = j+1;}
         if(i==csize-1) {i_plus1 = 0;}
         else          {i_plus1 = i+1;}
        
         u = state_u[i][j];
         un = state_u[i_minus1][j];
         ue = state_u[i][j_minus1];
         uw = state_u[i][j_plus1];
         us = state_u[i_plus1][j];
         
         v = state_v[i][j];
         vn = state_v[i_minus1][j];
         ve = state_v[i][j_minus1];
         vw = state_v[i][j_plus1];
         vs = state_v[i_plus1][j];
         
         uspread = du * ((un+ue+us+uw - 4.0*u) / (dx*dx));
         vspread = dv * ((vn+ve+vs+vw - 4.0*v) / (dx*dx));
         
         //state_du[i][j] = uspread;
         //state_dv[i][j] = vspread;
         
         state_du[i][j] = uspread - u*v*v + f*(1.0-u);
         state_dv[i][j] = vspread + u*v*v - (f+k)*v;
      }
    }
    for(i=0; i<csize; i++){
      for(j=0; j<csize; j++){
        state_u[i][j] += dt*state_du[i][j];
        state_v[i][j] += dt*state_dv[i][j];
      }
    }
  }
}
