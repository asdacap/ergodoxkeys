$devmode = false;

include <keyv2/includes.scad>

ergodox_layout = [
  [1.5, 1, 1, 1, 1,  1,  1, 1, 1, 1, 1, 1.5],
  [1.5, 1, 1, 1, 1,  1,  1, 1, 1, 1, 1, 1.5],
  [1.5, 1, 1, 1, 1,  1,  1, 1, 1, 1, 1, 1.5],
  [1.5, 1, 1, 1, 1,  1,  1, 1, 1, 1, 1, 1.5],
    [1, 1, 1, 1, 1, -1, -1, 1, 1, 1, 1, 1]
];

offset_y = [
  [-1, -1.0, 0, 0,-0.8,-1, 0.0],
  [-1,-1, 0, 0,-0.5,-0.5, 0.0],
  [0,    0, 0.0, 0, 0, 0, 0, 0.0],
  [1,  1, 0, 0,0,0, 0.0],
  [2.5,  2.5, 0, 0,0,1, 0.0],
];

offset_z = [
  [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
  [0.0, 0.05, 0.0, 0.0, 0.0, 0.0, 0.0],
  [0.0, 0.02, 0.0, 0.0, 0.0, 0.0, 0.0],
  [0.0, 0.00, 0.0, 0.0, 0.0, 0.0, 0.0],
  [0.0, 0.05, 0.0, 0.0, 0.0, 0.0, 0.0],
];

// This is only for display
row_layout_offset_x = [0, 0, 0, 0, 9.5, 0.0];
column_layout_offset_y = [0, 0, 3.4, 5.0, 3.4, 2.0, 0.0];

row_offset_x = [0, 0, 0, 0, 0];
row_offset_y = [-7, -3.5, 0, 2.5, 4.5];
row_offset_z = [0.9, 0.4, -0.2, 0.5, 1.5];

column_offset_x = [2, 0, 0, 0, -0.5, -2, 0, 0.0];
column_offset_y = [0, 0, 0, 0, 0, 0, 0.0]; // for pinky
column_offset_z = [0.6, 0.7, 0, -0.2, 0.3, 0.4, 0.0];
column_offset_size = [0.5, 0.5, 0, 0, 0, 0, 0.0]; // Make pinky smaller

extra_height_scale = 3;

// to turn on full sculpting
$double_sculpted = true;
// change this to make the full sculpting more or less aggressive. 200 is default
$double_sculpt_radius = 400;

row_length = len(ergodox_layout[0]);

$rounded_key = !$devmode;
//$minkowski_radius = 0.6;

$stem_type = "cherry";  // [cherry, alps, rounded_cherry, box_cherry, filled, disable]

// because of clearance. 0.8 on each side
$wall_thickness = 1.6;

function 1hand(index, total) = (index % (total)) - (total/2) + 1;
function double_sculpted_column(column, row_length, column_sculpt_profile) =
  (column < row_length/2) ?
  1hand(column, row_length/2):
  1hand(row_length-column-1, row_length/2)*-1;

$clearance_check = $devmode;

$stem_inner_slop = 0.05;
$cherry_bevel = true;

module make_column(column_idx, row_idx, print_right) {
simple_layout(ergodox_layout) {
  // this union is here because, for some reason, you cannot modify special variables
  // that are modified in the scope directly above.
  union() {
    // row declarations treat column 0 as perfectly center, so if we just used
    // $column we'd have a ridiculously looking left-leaning keyboard.
    // value, aka for a board with 2 "keywells", one for each hand
    column_profile = ($column < row_length/2) ? $column : row_length - $column -1;
    column_factor = ($column < row_length/2) ? 1 : -1;
    column_value = double_sculpted_column($column, row_length, "2hands");
    dcs_row($row, column_value){
      // I dont know why this is needed
      union() {
        $dish_type = $devmode ? "disable" : $dish_type;

        // here's where the magic happens and we actually add the extra column height
        extra_height = (column_offset_z[column_profile] + row_offset_z[$row] + offset_z[$row][column_profile])*extra_height_scale-1;
        $total_depth = $total_depth + extra_height;
        $top_skew = column_offset_y[column_profile]+row_offset_y[$row]+offset_y[$row][column_profile];
        $top_skew_x = (column_offset_x[column_profile]+row_offset_x[$row])*column_factor;

        //$dish_depth = 0.8;

        $width_difference = 5;//+column_offset_size[column_profile];
        $height_difference = 6+column_offset_size[column_profile];

        // Key is a bit smaller
        $bottom_key_width = 17.16;
        $bottom_key_height = 17.16;

        if (column_idx == undef || column_profile == column_idx)
        if (row_idx == undef || $row == row_idx)
        if (print_right || $column == column_profile)
        if (!print_right || $column != column_profile)
        translate([row_layout_offset_x[$row], column_layout_offset_y[column_profile]])
        key() {
            
          // fixes an issues with artisan handling
          union()
             sphere(0);

          if ($row == 2 && (column_profile == 4)) {
             //translate([0, 0, 1])
             scale([1,1,0.6])
             sphere(1.5);
          }
          if ($row == 3 && (column_profile == 1)) {
             //translate([0, 0, 1])
             scale([1,1,0.6])
             sphere(1.3);
          }
          /*
          if ($row == 2 && (column_profile == 2)) {
             //translate([0, 0, 1])
             sphere(1.3);
          }
          if ($row == 2 && (column_profile == 3)) {
             //translate([0, 0, 1])
             sphere(1.3);
          }
          */
        }
      }
    }
  }
}
}

//make_column(column_idx=0);
//make_column(column_idx=0, print_right=true);
//make_column(column_idx=1);
//make_column(column_idx=1, print_right=true);
//make_column(column_idx=2);
//make_column(column_idx=2, print_right=true);
//make_column(column_idx=3);
//make_column(column_idx=3, print_right=true);
//make_column(column_idx=4);
//make_column(column_idx=4, print_right=true);
//make_column(column_idx=5);
//make_column(column_idx=5, print_right=true);
//make_column(column_idx=6);
//make_column(column_idx=6, print_right=true);
