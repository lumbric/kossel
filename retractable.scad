include <configuration.scad>;

use <microswitch.scad>;

height = 30.5;

height2 = 30.5;

// distance between bottom of switch and z=0
height3 = 7;

// change if you are not using a 1.5mm allen
tunnel = 2.4;

face_offset = 4;

foot_height = 6.5;

module foot() {
  difference() {
    translate([12.5, 0, 0]) rotate([0, 0, -60])
      translate([-12.5, 0, foot_height/2.]) rotate([0, 0, -60]) union() {
        cylinder(r=5, h=foot_height, center=true, $fn=24);
        translate([10, 0, 0])
            cube([20, 10, foot_height], center=true);
    }
    translate([0, -10, 0])
      cube([40, 20, 20], center=true);
    translate([12.5, 0, 0]) {
      // Space for bowden push fit connector.
      cylinder(r=6.49, h=3*height, center=true, $fn=32);
      for (a = [60:120:359]) {
        rotate([0, 0, a]) translate([-12.5, 0, 0])
          cylinder(r=m3_wide_radius, h=20, center=true, $fn=12);
      }
    }
  }
}

module retractable() {
  difference() {
    union() {
      translate([0, 0, height/2])
        cylinder(r=6, h=height, center=true, $fn=32);
      translate([0, -3, height/2])
        cube([12, 6, height], center=true);
      // Lower part on the left.
      translate([-6, 0, height2/2])
        cylinder(r=6, h=height2, center=true, $fn=32);
      translate([-3, 0, height2/2])
        cube([6, 12, height2], center=true);
      translate([-3, -3, height2/2])
        cube([18, 6, height2], center=true);
      // Feet for vertical M3 screw attachment.
      rotate([0, 0, 90]) {
        foot();
        scale([1, -1, 1]) foot();
      }
    }
    translate([-19, 0, height-7]) rotate([0, 15, 0])
      cube([20, 20, height], center=true);
    cylinder(r=tunnel/2+extra_radius, h=3*height, center=true, $fn=12);
    translate([0, -6, height-1])
      cube([tunnel-0.5, 12, height], center=true);
    // cut for upper position of allen
    rotate([0, 0, 30]) translate([0, -6, height+11])
      cube([tunnel, 12, height], center=true);
    // Safety needle spring.
    translate([-4.5, 0, height-11]) rotate([90, 0, 0])
      cylinder(r=2.5/2, h=40, center=true, $fn=12);
    translate([-4, 0, height-2]) rotate([90, 0, 0])
      cylinder(r=1/2, h=40, center=true, $fn=12);
    // Effector screw heads.
    for (x = [-1, 1])
      rotate([0, 0, -x*330]) translate([x*12.5, 0, foot_height-3])
        cylinder(r=m3_nut_radius, h=30, $fn=6);
    // Flat front face.
    translate([0, -face_offset-10, height/2]) difference() {
      cube([30, 20, 2*height], center=true);
    }
    // Sub-miniature micro switch.
    translate([-2.5, -face_offset-3, height3 + 2.5]) {
      % microswitch();
      for (x = [-9.5/2, 9.5/2]) {
        translate([x, 0, 0]) rotate([90, 0, 0])
          cylinder(r=2.5/2, h=40, center=true, $fn=12);
      }
    }
  }
}

retractable();
