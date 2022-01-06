# Using LudlStage (Last Updated 6/17/2020)

## A Note on Hardware

The code for this project currently works the Ludl MAC6000 microscope stage controller. It may be compatible with other Ludl stage controller models, but
changes may need to be made to the source code as necessary.

The following functions were adapted from https://github.com/DIDSR/eeDAP/tree/master/src/stages/Ludl:

- `stage_check_busy_Ludl`
- `stage_get_joy_speed_Ludl`
- `stage_get_pos_Ludl`
- `stage_move_Ludl`
- `stage_open_Ludl`
- `stage_send_com_Ludl`
- `stage_set_joy_speed_Ludl`
- `stage_set_origin_Ludl`

## Connecting to the Stage with `stage_open_Ludl`

To open connection to the stage, run the command

`ludl = stage_open_Ludl`

If you have not connected to the stage before, you will prompted to enter which COM port the stage is connected to, which is something you will have
to figure out manually. Once you have made your selection, your choice will be stored in a file named `PortNames.mat` inside the 
`LudlStage`directory, so you won't be queried in the future. If you change which COM port the stage is connected to, you will have to 
delete `PortNames.mat` and rerun `stage_open_Ludl`.

As a note, `SerialPortSetup` is the specific function called within stage_open_Ludl that creates `Portnames.mat`. There is no need to call it manually
unless you do not want to go through stage_open_Ludl to do so.

## Checking the Stage for Activity

The stage can be checked to see if it is currently performing any commands using 

`busy = stage_check_busy_Ludl(ludl)`

where `busy` is a boolean indicating whether the stage is busy or not. This function is called within several of the functions.

## Querying and Changing Position in Ludl Coordinates with `stage_get_pos_Ludl` and `stage_move_Ludl`
Commands involving the stage's location coordinates are written in units of Ludl tick marks. Each Ludl tick mark is 50 nm.

To get the stage's position in Ludl coordinates, use the command

`[x_cor,y_cor] = stage_get_pos_Ludl(ludl).Pos`

`[x_cor,y_cor]` gives the values of the x and y coordinates respectively of the stage in units of Ludl
tick marks. 

It should be noted that `stage_get_pos_Ludl` returns more properties of the Ludl stage object than you will probably need, so it is helpful to only 
extract a single property, such as `Pos`.

To move to a specific Ludl coordinate, use the command

`stage_move_Ludl(ludl, [target_x_pos target_y_pos])`

`target_x_pos` and `target_y_pos` are both in units of Ludl tickmarks. It should be noted that `stage_move_Ludl` moves to an absolute position as
opposed to a position relative to where the stage last was.

### Unit Conversion Between mm and ticks

`mm2tick` and `tick2mm` are unit conversion functions that convert from milimeters to ticks and vice versa respectively. They can be implemented as shown:

`dist_tick = mm2tick(ludl, dist_mm)`
`dist_mm = tick2mm(ludl, dist_tick)`

## Controlling the Stage with a Joystick

`stage_get_joy_speed` and `stage_set_joy_speed` can be used to get and set the joystick speed of the hub controller. We have not tested these functions
and they seem to still be in development. It is not recommended to use them.

## Setting the Stage Origin with `stage_set_origin_Ludl`

The purpose of `stage_set_origin_Ludl` is to set the origin of the Ludl coordinate system to the top left corner of the stage. It should be noted 
that the range and size of the tickmarks remain the same. The process can be implimented with the following command:

`ludl = stage_set_origin_Ludl(ludl)`

## Checking for Errors using `error_show`

This function can be used to identify errors as shown:

`error_show(ME)`

where `ME` is a Matlab Exception structure with the following fields:

- identifier
- message
- cause
- stack (array of structures)
	- file (file name where error occured)
	- name (function name where error occured)
	- line (where error occured)

This function is called within most of the other functions to catch errors, so they serve as good examples of how this function can be implemented.

## Closing Connection to the Stage with `stage_close`

Connection to the stage can be closed using `stage_close(ludl)`

