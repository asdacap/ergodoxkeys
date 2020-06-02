set -e 

openscad --autocenter -o column0.stl column0.scad &
openscad --autocenter -o column1.stl column1.scad &
openscad --autocenter -o column2.stl column2.scad &
openscad --autocenter -o column3.stl column3.scad &
openscad --autocenter -o column4.stl column4.scad &
openscad --autocenter -o column5.stl column5.scad &
openscad --autocenter -o row0.stl row0.scad &
openscad --autocenter -o row1.stl row1.scad &
openscad --autocenter -o row2.stl row2.scad &
openscad --autocenter -o row3.stl row3.scad &
openscad --autocenter -o row4.stl row4.scad &
openscad --autocenter -o allcolumn.stl allcolumn.scad &

wait
