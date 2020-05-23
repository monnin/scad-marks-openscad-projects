logo_filename = 
   "G:\\USM\\Templates, Common Info, etc\\USM Logos\\USMLogo_Classic.dxf";

my_name = "Mark Monnin";

piece_width =  3.9;         // Total size (units controlled by slicer program)
piece_depth = 2.25;         // Mostly size of base

back_loc = 1.25;            // From front (controls # of cards it can hold)
frontback_angle = 15;       // In degrees

    // Note: Front and back height are height of the face (aka "pre-rotate")
back_height = 2.5;         // Controls the height of the back
front_height = 1.0;

side_height = 0.5;


side_thickness  = 0.1;
base_thickness  = 0.1;
front_thickness = 0.1;
back_thickness  = 0.1;

// These control the amount of emboss of the picture & words
logo_thickness  = 0.07;
font_thickness  = 0.07;

margin = 0.1;   // Bottom and left margin of the logo, top margin of the text



round_tops = true;

font_name = "Liberation Sans:style=Bold";
font_size = 0.25;

//---------------------------------------------------------------------------

module parallelogram(l,w,h,loff) {
    CubePoints = [
      [  0,  0,  0 ],  //0
      [ l,  0,  0 ],  //1
      [ l,  w,  0 ],  //2
      [  0,  w,  0 ],  //3
      [  -loff,  0,  h ],  //4
      [ l-loff,  0,  h ],  //5
      [ l-loff,  w,  h ],  //6
      [  -loff,  w,  h ]]; //7
      
    CubeFaces = [
      [0,1,2,3],  // bottom
      [4,5,1,0],  // front
      [7,6,5,4],  // top
      [5,6,2,1],  // right
      [6,7,3,2],  // back
      [7,4,0,3]]; // left
      
    polyhedron( CubePoints, CubeFaces );
}


module parallelogram2(l,w,h,deg) {
    rotate([0,deg,0])
        multmatrix([[1,0,0,0],
                    [0,1,0,0],
                    [tan(deg),0,1,0]]) 
            union() {
                cube([l,w,h]);
                
                if (round_tops) 
                    translate([l/2,w/2,h])
                        rotate([0,90,0]) 
                        cylinder(h=l, r1=w/2, r2=w/2,
                         center=true, $fn=100);
                 };
    }


//---------------------------------------------------------------------------
   
// Base
cube(size=[piece_width,piece_depth,base_thickness], center=true);

   
//  Front
translate([-piece_width/2,-piece_depth/2,+base_thickness/2])
 rotate([-frontback_angle,0,0])
   union() {
        cube(size=[piece_width,front_thickness,front_height],center=false);
        color("white")
          translate([margin,-logo_thickness+front_thickness/2,margin])
            resize( newsize=[piece_width-margin*2,logo_thickness,
                         front_height-margin*2])
              rotate([90,0,0]) 
                  linear_extrude(height=logo_thickness,center=true)
                        import(logo_filename);
       
        if (round_tops) 
            translate([piece_width/2,front_thickness/2,front_height])
              rotate([0,90,0]) 
                cylinder(h=piece_width, r1=front_thickness/2, r2=front_thickness/2,
                         center=true, $fn=100);
           
       }
   
// Back
translate([-piece_width/2,back_loc-piece_depth/2,0]) 
  rotate([-frontback_angle,0,0])
      union() {
        cube(size=[piece_width,back_thickness,back_height],center=false);
        color("white")
          translate([piece_width/2,-font_thickness+back_thickness/2,back_height-font_size-margin])
            rotate([90,0,0])
              linear_extrude(height=font_thickness,center=true) 
                text(text=my_name, font=font_name, size=font_size, 
                     halign="center",spacing=1.1);
          
        if (round_tops) 
            translate([piece_width/2,back_thickness/2,back_height])
              rotate([0,90,0]) 
                cylinder(h=piece_width, r1=back_thickness/2, r2=back_thickness/2,
                         center=true, $fn=100);
    }
    
// Parallelogram sides

translate([-piece_width/2+side_thickness,-piece_depth/2,base_thickness/2])
  rotate([0,0,90])
        parallelogram2(back_loc,side_thickness,side_height, frontback_angle);


translate([+piece_width/2,-piece_depth/2,base_thickness/2])
  rotate([0,0,90])
    parallelogram2(back_loc,side_thickness,side_height, frontback_angle);
