function createDialogFromCacheFile width height pos bgcolor fgcolor bitmap bmpstyle style modal autoLayoutOnResize escapeEnable lockHeight lockWidth parent =
(

try( destroyDialog DIALOG_nodeexporter )catch()


rollout ROLLOUT_3d_print "3 D - P R I N T "
(
	ImgTag IT_empty_macro_color_strip "empty_macro_color_Strip" controller:undefined ini:true align:#center height:1 across:1 width:420 bitmap:CONTROL_BITMAPS_STORE[1] labelOnTop:false Control:"imgTag" color:(color 0 120 255)
	on IT_empty_macro_color_strip click  do 
	(
		(

/*--- EventFired: Definition of struct ---*/
execute "struct EventFired_v( Type, Roll, Control, function get prop = ( if hasProperty this ( prop as name ) then getProperty this ( prop as name ) else false  ) )"

/*--- CAST INSTANCE TO GLOBAL VARIABLE ---*/
global EventFired = EventFired_v Type:#click Roll:DIALOG_nodeexporter.ExportTo.ROLLOUT_3d_print Control:DIALOG_nodeexporter.ExportTo.ROLLOUT_3d_print.IT_empty_macro_color_strip 



/* ============= CUSTOM CALLBACK ============= */
(macros.run "_Colors" "empty_macro_color_Strip")
EventFired = undefined /* RESET GLOBAL VARIABLE */
)
	)
	group "EXPORT SETUP" (
	checkbox CBX_fix_position "Fix Position" controller:undefined ini:true across:2 checked:false offset:[16,0] labelOnTop:false Control:"checkbox" toolTip:"For objects to keep position on export\n\n(Create boxes in corners of print plane to keep exported position)"
	checkbox CBX_meshsmooth "Meshsmooth" controller:undefined ini:true across:2 checked:false offset:[0,0] labelOnTop:false Control:"checkbox" toolTip:"Auto turn on first Meshmooth modifier on exported object.\n\nMeshmooth is ONLY ENABLED, NOT ADDED."
	)
	on CBX_fix_position changed val do 
	(
		(

/*--- EventFired: Definition of struct ---*/
execute "struct EventFired_v( Type, Roll, Control, val, function get prop = ( if hasProperty this ( prop as name ) then getProperty this ( prop as name ) else false  ) )"

/*--- CAST INSTANCE TO GLOBAL VARIABLE ---*/
global EventFired = EventFired_v Type:#changed Roll:DIALOG_nodeexporter.ExportTo.ROLLOUT_3d_print Control:DIALOG_nodeexporter.ExportTo.ROLLOUT_3d_print.CBX_fix_position val:val 



/* ============= CUSTOM CALLBACK ============= */
(macros.run "_Export" "_export_fixed_position")
EventFired = undefined /* RESET GLOBAL VARIABLE */
)
	)
	on CBX_meshsmooth changed val do 
	(
		(

/*--- EventFired: Definition of struct ---*/
execute "struct EventFired_v( Type, Roll, Control, val, function get prop = ( if hasProperty this ( prop as name ) then getProperty this ( prop as name ) else false  ) )"

/*--- CAST INSTANCE TO GLOBAL VARIABLE ---*/
global EventFired = EventFired_v Type:#changed Roll:DIALOG_nodeexporter.ExportTo.ROLLOUT_3d_print Control:DIALOG_nodeexporter.ExportTo.ROLLOUT_3d_print.CBX_meshsmooth val:val 



/* ============= CUSTOM CALLBACK ============= */
(macros.run "_Export" "_export_turn_on_meshmooth")
EventFired = undefined /* RESET GLOBAL VARIABLE */
)
	)
	group "ANIMATION" (
	checkbox CBX_export_animation "Animation" controller:undefined ini:true across:2 checked:false offset:[16,0] labelOnTop:false id:"CBX_export_animation" Control:"checkbox" toolTip:"Export animation\n\nFROM: Current Key\n\nTO: End of animation range"
	checkbox CBX_offset "OFFSET" controller:undefined ini:true across:2 checked:false offset:[0,0] labelOnTop:false Control:"checkbox" toolTip:"Offset objects of each exported animation key\n\nMAKES ANIMATION STRIP FROM OBJECTS"
	)
	on CBX_export_animation changed val do 
	(
		(

/*--- EventFired: Definition of struct ---*/
execute "struct EventFired_v( Type, Roll, Control, val, function get prop = ( if hasProperty this ( prop as name ) then getProperty this ( prop as name ) else false  ) )"

/*--- CAST INSTANCE TO GLOBAL VARIABLE ---*/
global EventFired = EventFired_v Type:#changed Roll:DIALOG_nodeexporter.ExportTo.ROLLOUT_3d_print Control:DIALOG_nodeexporter.ExportTo.ROLLOUT_3d_print.CBX_export_animation val:val 



/* ============= CUSTOM CALLBACK ============= */
(macros.run "_Export" "_export_settings_export_animation")
EventFired = undefined /* RESET GLOBAL VARIABLE */
)
	)
	on CBX_offset changed val do 
	(
		(

/*--- EventFired: Definition of struct ---*/
execute "struct EventFired_v( Type, Roll, Control, val, function get prop = ( if hasProperty this ( prop as name ) then getProperty this ( prop as name ) else false  ) )"

/*--- CAST INSTANCE TO GLOBAL VARIABLE ---*/
global EventFired = EventFired_v Type:#changed Roll:DIALOG_nodeexporter.ExportTo.ROLLOUT_3d_print Control:DIALOG_nodeexporter.ExportTo.ROLLOUT_3d_print.CBX_offset val:val 



/* ============= CUSTOM CALLBACK ============= */
(macros.run "_Export" "_export_settings_export_animation_offset")
EventFired = undefined /* RESET GLOBAL VARIABLE */
)
	)
	group "KEEP EXPORTED OBJECTS" (
	checkbox CBX_keep_exported "KEEP EXPORTED" controller:undefined ini:true across:2 checked:false offset:[16,0] labelOnTop:false Control:"checkbox" toolTip:"Keep exported exported obejcts"
	checkbox CBX_layer_by_obj "Layer by obj" controller:undefined ini:true across:2 checked:false offset:[16,0] labelOnTop:false Control:"checkbox" toolTip:"Keep exported exported obejcts"
	checkbox CBX_unsmooth_vertex_color "Unsmooth Vertex Color" controller:undefined ini:true across:2 checked:true offset:[16,0] labelOnTop:false Control:"checkbox" toolTip:"DO NOT SMOOTH VERTEX COLORS"
	checkbox CBX_inner_black "Inner Black" controller:undefined ini:true across:2 checked:false offset:[16,0] labelOnTop:false Control:"checkbox" toolTip:"Set vertex color of inner verts as black"
	edittext ET_exported_suffix "Suffix" controller:undefined ini:true text:"supports-source" across:1 width:368 offset:[0,6] value:"supports-source" labelOnTop:false id:"ET_exported_suffix" Control:"editText"
	)
	on CBX_keep_exported changed val do 
	(
		(

/*--- EventFired: Definition of struct ---*/
execute "struct EventFired_v( Type, Roll, Control, val, function get prop = ( if hasProperty this ( prop as name ) then getProperty this ( prop as name ) else false  ) )"

/*--- CAST INSTANCE TO GLOBAL VARIABLE ---*/
global EventFired = EventFired_v Type:#changed Roll:DIALOG_nodeexporter.ExportTo.ROLLOUT_3d_print Control:DIALOG_nodeexporter.ExportTo.ROLLOUT_3d_print.CBX_keep_exported val:val 



/* ============= CUSTOM CALLBACK ============= */
(macros.run "_Export" "_export_settings_export_animation_keep_exported_objects")
EventFired = undefined /* RESET GLOBAL VARIABLE */
)
	)
	on CBX_layer_by_obj changed val do 
	(
		(

/*--- EventFired: Definition of struct ---*/
execute "struct EventFired_v( Type, Roll, Control, val, function get prop = ( if hasProperty this ( prop as name ) then getProperty this ( prop as name ) else false  ) )"

/*--- CAST INSTANCE TO GLOBAL VARIABLE ---*/
global EventFired = EventFired_v Type:#changed Roll:DIALOG_nodeexporter.ExportTo.ROLLOUT_3d_print Control:DIALOG_nodeexporter.ExportTo.ROLLOUT_3d_print.CBX_layer_by_obj val:val 



/* ============= CUSTOM CALLBACK ============= */
(macros.run "_Export" "_export_settings_export_keep_exported_custom_layer")
EventFired = undefined /* RESET GLOBAL VARIABLE */
)
	)
	on CBX_unsmooth_vertex_color changed val do 
	(
		(

/*--- EventFired: Definition of struct ---*/
execute "struct EventFired_v( Type, Roll, Control, val, function get prop = ( if hasProperty this ( prop as name ) then getProperty this ( prop as name ) else false  ) )"

/*--- CAST INSTANCE TO GLOBAL VARIABLE ---*/
global EventFired = EventFired_v Type:#changed Roll:DIALOG_nodeexporter.ExportTo.ROLLOUT_3d_print Control:DIALOG_nodeexporter.ExportTo.ROLLOUT_3d_print.CBX_unsmooth_vertex_color val:val 



/* ============= CUSTOM CALLBACK ============= */
(macros.run "_Export" "_export_settings_export_unsmooth_vertex_color")
EventFired = undefined /* RESET GLOBAL VARIABLE */
)
	)
	on CBX_inner_black changed val do 
	(
		(

/*--- EventFired: Definition of struct ---*/
execute "struct EventFired_v( Type, Roll, Control, val, function get prop = ( if hasProperty this ( prop as name ) then getProperty this ( prop as name ) else false  ) )"

/*--- CAST INSTANCE TO GLOBAL VARIABLE ---*/
global EventFired = EventFired_v Type:#changed Roll:DIALOG_nodeexporter.ExportTo.ROLLOUT_3d_print Control:DIALOG_nodeexporter.ExportTo.ROLLOUT_3d_print.CBX_inner_black val:val 



/* ============= CUSTOM CALLBACK ============= */
(macros.run "_Export" "_export_settings_export_inner_verts_to_black")
EventFired = undefined /* RESET GLOBAL VARIABLE */
)
	)
	on ET_exported_suffix changed val do 
	(
		(

/*--- EventFired: Definition of struct ---*/
execute "struct EventFired_v( Type, Roll, Control, val, function get prop = ( if hasProperty this ( prop as name ) then getProperty this ( prop as name ) else false  ) )"

/*--- CAST INSTANCE TO GLOBAL VARIABLE ---*/
global EventFired = EventFired_v Type:#changed Roll:DIALOG_nodeexporter.ExportTo.ROLLOUT_3d_print Control:DIALOG_nodeexporter.ExportTo.ROLLOUT_3d_print.ET_exported_suffix val:val 



/* ============= CUSTOM CALLBACK ============= */
(macros.run "_Export" "_export_settings_export_keep_exported_objects_suffix")
EventFired = undefined /* RESET GLOBAL VARIABLE */
)
	)
	local RB_open_in_program_last_state = 1
	group "OUTPUT" (
	radiobuttons RB_export_format "Export format" controller:undefined ini:true across:2 default:1 offset:[-4,0] offsets:#([0,4], [0,4]) labelOnTop:false columns:2 labels:#("obj", "stl") Control:"radiobuttons" toolTip:"Open export file in chitubox after export"
	radiobuttons RB_open_in_program "Open In Program" controller:undefined ini:true across:2 default:1 offset:[-32,0] offsets:#([0,4], [0,4]) labelOnTop:false columns:2 labels:#("Chitubox", "LycheSlicer") Control:"radiobuttons" toolTip:"Open export file in chitubox after export"
	checkbox CBX_project_file_open "Project File Open" controller:undefined ini:true across:2 checked:false offset:[12,6] labelOnTop:false Control:"checkbox"
	checkbox CBX_single_instance "Single Instance" controller:undefined ini:true across:2 checked:true offset:[0,6] labelOnTop:false Control:"checkbox" toolTip:"Close other instances of open in program"
	)
	on RB_export_format changed val do 
	(
		(

/*--- EventFired: Definition of struct ---*/
execute "struct EventFired_v( Type, Roll, Control, val, function get prop = ( if hasProperty this ( prop as name ) then getProperty this ( prop as name ) else false  ) )"

/*--- CAST INSTANCE TO GLOBAL VARIABLE ---*/
global EventFired = EventFired_v Type:#changed Roll:DIALOG_nodeexporter.ExportTo.ROLLOUT_3d_print Control:DIALOG_nodeexporter.ExportTo.ROLLOUT_3d_print.RB_export_format val:val 



/* ============= CUSTOM CALLBACK ============= */
(macros.run "_Export" "_export_print_open_in_program")
EventFired = undefined /* RESET GLOBAL VARIABLE */
)
	)
	on RB_open_in_program changed val do 
	(
		(

/*--- EventFired: Definition of struct ---*/
execute "struct EventFired_v( Type, Roll, Control, val, function get prop = ( if hasProperty this ( prop as name ) then getProperty this ( prop as name ) else false  ) )"

/*--- CAST INSTANCE TO GLOBAL VARIABLE ---*/
global EventFired = EventFired_v Type:#changed Roll:DIALOG_nodeexporter.ExportTo.ROLLOUT_3d_print Control:DIALOG_nodeexporter.ExportTo.ROLLOUT_3d_print.RB_open_in_program val:val 


/* ============= DEFAULT CALLBACK ============= */
if val == RB_open_in_program_last_state then    -- if checked radiobutton is clicked again
	RB_open_in_program.state = val = 0          -- then unselect buttons

RB_open_in_program_last_state = val             -- store value

EventFired.val = val


/* ============= CUSTOM CALLBACK ============= */
(macros.run "_Export" "_export_print_open_in_program")
EventFired = undefined /* RESET GLOBAL VARIABLE */
)
	)
	on CBX_project_file_open changed val do 
	(
		(

/*--- EventFired: Definition of struct ---*/
execute "struct EventFired_v( Type, Roll, Control, val, function get prop = ( if hasProperty this ( prop as name ) then getProperty this ( prop as name ) else false  ) )"

/*--- CAST INSTANCE TO GLOBAL VARIABLE ---*/
global EventFired = EventFired_v Type:#changed Roll:DIALOG_nodeexporter.ExportTo.ROLLOUT_3d_print Control:DIALOG_nodeexporter.ExportTo.ROLLOUT_3d_print.CBX_project_file_open val:val 



/* ============= CUSTOM CALLBACK ============= */
(macros.run "_Export" "_export_open_in_final_file")
EventFired = undefined /* RESET GLOBAL VARIABLE */
)
	)
	on CBX_single_instance changed val do 
	(
		(

/*--- EventFired: Definition of struct ---*/
execute "struct EventFired_v( Type, Roll, Control, val, function get prop = ( if hasProperty this ( prop as name ) then getProperty this ( prop as name ) else false  ) )"

/*--- CAST INSTANCE TO GLOBAL VARIABLE ---*/
global EventFired = EventFired_v Type:#changed Roll:DIALOG_nodeexporter.ExportTo.ROLLOUT_3d_print Control:DIALOG_nodeexporter.ExportTo.ROLLOUT_3d_print.CBX_single_instance val:val 



/* ============= CUSTOM CALLBACK ============= */
(macros.run "_Export" "_export_open_in_close_instances")
EventFired = undefined /* RESET GLOBAL VARIABLE */
)
	)
	group "EXPORT" (
	edittext ET_exclude "Exclude" controller:undefined ini:true text:"supports-source" across:1 width:368 offset:[0,4] value:"support-source" labelOnTop:false Control:"editText" toolTip:"Do not export object, if it`s name match this text"
	button BTN_e_x_p_o_r_t "E X P O R T" controller:undefined ini:true height:64 across:3 offset:[0,6] labelOnTop:false toolTip:"Export selected nodes to files"
	button BTN_print_dummy "Print Dummy" controller:undefined ini:true height:64 across:3 offset:[0,6] labelOnTop:false toolTip:"LMB: Create\Delete dummy palne of 3D printer plane

RMB: Create\Delete dummy of 3D printer volume"
	button BTN_open_files "Open Files" controller:undefined ini:true height:64 across:3 offset:[0,6] labelOnTop:false toolTip:"Open exported files of selected nodes"
	)
	on ET_exclude changed val do 
	(
		(

/*--- EventFired: Definition of struct ---*/
execute "struct EventFired_v( Type, Roll, Control, val, function get prop = ( if hasProperty this ( prop as name ) then getProperty this ( prop as name ) else false  ) )"

/*--- CAST INSTANCE TO GLOBAL VARIABLE ---*/
global EventFired = EventFired_v Type:#changed Roll:DIALOG_nodeexporter.ExportTo.ROLLOUT_3d_print Control:DIALOG_nodeexporter.ExportTo.ROLLOUT_3d_print.ET_exclude val:val 



/* ============= CUSTOM CALLBACK ============= */
(macros.run "_Export" "_export_export_exclude")
EventFired = undefined /* RESET GLOBAL VARIABLE */
)
	)
	on BTN_e_x_p_o_r_t pressed  do 
	(
		(

/*--- EventFired: Definition of struct ---*/
execute "struct EventFired_v( Type, Roll, Control, function get prop = ( if hasProperty this ( prop as name ) then getProperty this ( prop as name ) else false  ) )"

/*--- CAST INSTANCE TO GLOBAL VARIABLE ---*/
global EventFired = EventFired_v Type:#pressed Roll:DIALOG_nodeexporter.ExportTo.ROLLOUT_3d_print Control:DIALOG_nodeexporter.ExportTo.ROLLOUT_3d_print.BTN_e_x_p_o_r_t 



/* ============= CUSTOM CALLBACK ============= */
(macros.run "_Export" "_export_print")
EventFired = undefined /* RESET GLOBAL VARIABLE */
)
	)
	on BTN_print_dummy rightClick  do 
	(
		(

/*--- EventFired: Definition of struct ---*/
execute "struct EventFired_v( Type, Roll, Control, function get prop = ( if hasProperty this ( prop as name ) then getProperty this ( prop as name ) else false  ) )"

/*--- CAST INSTANCE TO GLOBAL VARIABLE ---*/
global EventFired = EventFired_v Type:#rightClick Roll:DIALOG_nodeexporter.ExportTo.ROLLOUT_3d_print Control:DIALOG_nodeexporter.ExportTo.ROLLOUT_3d_print.BTN_print_dummy 



/* ============= CUSTOM CALLBACK ============= */
(macros.run "_Export" "_export_print_create_volume")
EventFired = undefined /* RESET GLOBAL VARIABLE */
)
	)
	on BTN_print_dummy pressed  do 
	(
		(

/*--- EventFired: Definition of struct ---*/
execute "struct EventFired_v( Type, Roll, Control, function get prop = ( if hasProperty this ( prop as name ) then getProperty this ( prop as name ) else false  ) )"

/*--- CAST INSTANCE TO GLOBAL VARIABLE ---*/
global EventFired = EventFired_v Type:#pressed Roll:DIALOG_nodeexporter.ExportTo.ROLLOUT_3d_print Control:DIALOG_nodeexporter.ExportTo.ROLLOUT_3d_print.BTN_print_dummy 



/* ============= CUSTOM CALLBACK ============= */
(macros.run "_Export" "_export_print_create_plane")
EventFired = undefined /* RESET GLOBAL VARIABLE */
)
	)
	on BTN_open_files pressed  do 
	(
		(

/*--- EventFired: Definition of struct ---*/
execute "struct EventFired_v( Type, Roll, Control, function get prop = ( if hasProperty this ( prop as name ) then getProperty this ( prop as name ) else false  ) )"

/*--- CAST INSTANCE TO GLOBAL VARIABLE ---*/
global EventFired = EventFired_v Type:#pressed Roll:DIALOG_nodeexporter.ExportTo.ROLLOUT_3d_print Control:DIALOG_nodeexporter.ExportTo.ROLLOUT_3d_print.BTN_open_files 



/* ============= CUSTOM CALLBACK ============= */
(macros.run "_Export" "_export_print_open_exported_files")
EventFired = undefined /* RESET GLOBAL VARIABLE */
)
	)
	local AUTORUN_EVENTS = Dictionary #string 
	on ROLLOUT_3d_print rolledUp val do
(
	if val then
	(
		if keyboard.controlPressed then
		rollUpOtherRolloutsCallback ( #DIALOG_nodeexporter) ( #ExportTo) ( #ROLLOUT_3d_print)
else
		autoRollUpRolloutCallback ( #DIALOG_nodeexporter) ( #ExportTo) ( #ROLLOUT_3d_print)
)
)
)
rollout ROLLOUT_unreal "U N R E A L "
(
	local BP_materials_dir_prev_state = ""
	group "Materials" (
	label LABEL_materials_path "Materials path" controller:undefined ini:true across:1 offset:[-146,0] labelOnTop:false Control:"label"
	edittext BP_materials_dir "" controller:undefined ini:false across:1 width:368 mode:#getSavePath historyCategory:undefined caption:undefined labelOnTop:false initialDir:"C:/" types:"All files|*.*|" Control:"BrowsePath" filename:undefined
	button BTN_load_mats "Load Mats" controller:undefined ini:true across:4 labelOnTop:false toolTip:"Load materials"
	label fake23247049 "" controller:undefined ini:true labelOnTop:false
	label fake742440887 "" controller:undefined ini:true labelOnTop:false
	label fake435247577 "" controller:undefined ini:true labelOnTop:false
	dropdownList DL_assign_materials "Assign Materials" controller:undefined ini:true selection:0 width:256 across:1 labelOnTop:false Control:"Dropdownlist" toolTip:"Assign material from asset folder"
	)
	on BP_materials_dir changed val do 
	(
		(

/*--- EventFired: Definition of struct ---*/
execute "struct EventFired_v( Type, Roll, Control, val, function get prop = ( if hasProperty this ( prop as name ) then getProperty this ( prop as name ) else false  ) )"

/*--- CAST INSTANCE TO GLOBAL VARIABLE ---*/
global EventFired = EventFired_v Type:#changed Roll:DIALOG_nodeexporter.ExportTo.ROLLOUT_unreal Control:DIALOG_nodeexporter.ExportTo.ROLLOUT_unreal.BP_materials_dir val:val 


/* ============= DEFAULT CALLBACK ============= */
		function valueIsEmpty _string = (( dotNetClass "System.Text.RegularExpressions.RegEx").match _string "^\s+$|^$" ).success
		

		
		/*  IF VALUE HAS CHANGED AND FIELD IS EMPTY */
		if( val != BP_materials_dir_prev_state and valueIsEmpty(val) and valueIsEmpty(BP_materials_dir_prev_state) ) then
		(
			/* OPEN BROWSE DIALOG */ 
			if( (browsed_path = getSavePath initialDir:"C:/" types:"All files|*.*|") != undefined ) then 
			(
				/* IF SUCCESS - PATH HAS BEEN BROWSED */ 
				BP_materials_dir.text    = browsed_path as string
				BP_materials_dir.tooltip = browsed_path as string

				val = EventFired.val = substituteString browsed_path "\\" "\\\\"
			)
			
			else
			(
				/* IF DIALOG WAS CANCELED */ 
				BP_materials_dir_prev_state = val
				BP_materials_dir.tooltip = ""
			)
		)
		else
		(
			BP_materials_dir_prev_state = BP_materials_dir.text
			BP_materials_dir.tooltip = ""
		)

/* ============= CUSTOM CALLBACK ============= */
(macros.run "_Unreal" "_unreal_asset_path")
EventFired = undefined /* RESET GLOBAL VARIABLE */
)
	)
	on BP_materials_dir entered val do 
	(
		(

/*--- EventFired: Definition of struct ---*/
execute "struct EventFired_v( Type, Roll, Control, val, function get prop = ( if hasProperty this ( prop as name ) then getProperty this ( prop as name ) else false  ) )"

/*--- CAST INSTANCE TO GLOBAL VARIABLE ---*/
global EventFired = EventFired_v Type:#entered Roll:DIALOG_nodeexporter.ExportTo.ROLLOUT_unreal Control:DIALOG_nodeexporter.ExportTo.ROLLOUT_unreal.BP_materials_dir val:val 


/* ============= DEFAULT CALLBACK ============= */
if( val != "" ) then
				val = EventFired.val = BP_materials_dir.tooltip = substituteString val "\\" "\\\\"

			else
				BP_materials_dir.tooltip = ""
EventFired = undefined /* RESET GLOBAL VARIABLE */
)
	)
	on BTN_load_mats pressed  do 
	(
		(

/*--- EventFired: Definition of struct ---*/
execute "struct EventFired_v( Type, Roll, Control, function get prop = ( if hasProperty this ( prop as name ) then getProperty this ( prop as name ) else false  ) )"

/*--- CAST INSTANCE TO GLOBAL VARIABLE ---*/
global EventFired = EventFired_v Type:#pressed Roll:DIALOG_nodeexporter.ExportTo.ROLLOUT_unreal Control:DIALOG_nodeexporter.ExportTo.ROLLOUT_unreal.BTN_load_mats 



/* ============= CUSTOM CALLBACK ============= */
(macros.run "_Unreal" "_unreal_load_materials")
EventFired = undefined /* RESET GLOBAL VARIABLE */
)
	)
	on DL_assign_materials selected val do 
	(
		(

/*--- EventFired: Definition of struct ---*/
execute "struct EventFired_v( Type, Roll, Control, val, function get prop = ( if hasProperty this ( prop as name ) then getProperty this ( prop as name ) else false  ) )"

/*--- CAST INSTANCE TO GLOBAL VARIABLE ---*/
global EventFired = EventFired_v Type:#selected Roll:DIALOG_nodeexporter.ExportTo.ROLLOUT_unreal Control:DIALOG_nodeexporter.ExportTo.ROLLOUT_unreal.DL_assign_materials val:val 



/* ============= CUSTOM CALLBACK ============= */
(macros.run "_Unreal" "_unreal_materials")
EventFired = undefined /* RESET GLOBAL VARIABLE */
)
	)
	group "Export" (
	button BTN_export "Export" controller:undefined ini:true height:64 across:2 offset:[0,16] labelOnTop:false toolTip:"LMB: Export selected nodes to files

RMB: Open export folder"
	label fake225570578 "" controller:undefined ini:true labelOnTop:false
	)
	on BTN_export rightClick  do 
	(
		(

/*--- EventFired: Definition of struct ---*/
execute "struct EventFired_v( Type, Roll, Control, function get prop = ( if hasProperty this ( prop as name ) then getProperty this ( prop as name ) else false  ) )"

/*--- CAST INSTANCE TO GLOBAL VARIABLE ---*/
global EventFired = EventFired_v Type:#rightClick Roll:DIALOG_nodeexporter.ExportTo.ROLLOUT_unreal Control:DIALOG_nodeexporter.ExportTo.ROLLOUT_unreal.BTN_export 



/* ============= CUSTOM CALLBACK ============= */
(macros.run "_Unreal" "_unreal_export_open_dir")
EventFired = undefined /* RESET GLOBAL VARIABLE */
)
	)
	on BTN_export pressed  do 
	(
		(

/*--- EventFired: Definition of struct ---*/
execute "struct EventFired_v( Type, Roll, Control, function get prop = ( if hasProperty this ( prop as name ) then getProperty this ( prop as name ) else false  ) )"

/*--- CAST INSTANCE TO GLOBAL VARIABLE ---*/
global EventFired = EventFired_v Type:#pressed Roll:DIALOG_nodeexporter.ExportTo.ROLLOUT_unreal Control:DIALOG_nodeexporter.ExportTo.ROLLOUT_unreal.BTN_export 



/* ============= CUSTOM CALLBACK ============= */
(macros.run "_Unreal" "_unreal_export")
EventFired = undefined /* RESET GLOBAL VARIABLE */
)
	)
	local AUTORUN_EVENTS = Dictionary #string 
	on ROLLOUT_unreal rolledUp val do
(
	if val then
	(
		if keyboard.controlPressed then
		rollUpOtherRolloutsCallback ( #DIALOG_nodeexporter) ( #ExportTo) ( #ROLLOUT_unreal)
else
		autoRollUpRolloutCallback ( #DIALOG_nodeexporter) ( #ExportTo) ( #ROLLOUT_unreal)
)
)
)
rollout ROLLOUT_obj "O B J "
(
	group "Export-Obj" (
	button BTN_export "Export" controller:undefined ini:true height:64 across:2 offset:[0,16] labelOnTop:false toolTip:"Export selected nodes to files"
	label fake541208258 "" controller:undefined ini:true labelOnTop:false
	)
	on BTN_export pressed  do 
	(
		(

/*--- EventFired: Definition of struct ---*/
execute "struct EventFired_v( Type, Roll, Control, function get prop = ( if hasProperty this ( prop as name ) then getProperty this ( prop as name ) else false  ) )"

/*--- CAST INSTANCE TO GLOBAL VARIABLE ---*/
global EventFired = EventFired_v Type:#pressed Roll:DIALOG_nodeexporter.ExportTo.ROLLOUT_obj Control:DIALOG_nodeexporter.ExportTo.ROLLOUT_obj.BTN_export 



/* ============= CUSTOM CALLBACK ============= */
(macros.run "_Export" "_export_obj")
EventFired = undefined /* RESET GLOBAL VARIABLE */
)
	)
	local AUTORUN_EVENTS = Dictionary #string 
	on ROLLOUT_obj rolledUp val do
(
	if val then
	(
		if keyboard.controlPressed then
		rollUpOtherRolloutsCallback ( #DIALOG_nodeexporter) ( #ExportTo) ( #ROLLOUT_obj)
else
		autoRollUpRolloutCallback ( #DIALOG_nodeexporter) ( #ExportTo) ( #ROLLOUT_obj)
)
)
)
rollout ROLLOUT_node_options "N O D E   O P T I O N S "
(
	group "NODES NAME" (
	edittext ET_search_in_name "" controller:undefined ini:true text:"boy" across:3 width:122 labelOnTop:false Control:"editText" toolTip:"Search text in selection names"
	edittext ET_replace_in_name "" controller:undefined ini:true text:"boy-supports" across:3 width:122 labelOnTop:false Control:"editText" toolTip:"Replace text in selection names"
	button BTN_search_replace "Search & Replace" controller:undefined ini:true across:3 labelOnTop:false toolTip:"Regex Search & Replace in names of selection or all objects if nothing selected"
	)
	on ET_search_in_name changed val do 
	(
		(

/*--- EventFired: Definition of struct ---*/
execute "struct EventFired_v( Type, Roll, Control, val, function get prop = ( if hasProperty this ( prop as name ) then getProperty this ( prop as name ) else false  ) )"

/*--- CAST INSTANCE TO GLOBAL VARIABLE ---*/
global EventFired = EventFired_v Type:#changed Roll:DIALOG_nodeexporter.ExportTo.ROLLOUT_node_options Control:DIALOG_nodeexporter.ExportTo.ROLLOUT_node_options.ET_search_in_name val:val 



/* ============= CUSTOM CALLBACK ============= */
(macros.run "Selection" "selection_edit_search_in_names")
EventFired = undefined /* RESET GLOBAL VARIABLE */
)
	)
	on ET_replace_in_name changed val do 
	(
		(

/*--- EventFired: Definition of struct ---*/
execute "struct EventFired_v( Type, Roll, Control, val, function get prop = ( if hasProperty this ( prop as name ) then getProperty this ( prop as name ) else false  ) )"

/*--- CAST INSTANCE TO GLOBAL VARIABLE ---*/
global EventFired = EventFired_v Type:#changed Roll:DIALOG_nodeexporter.ExportTo.ROLLOUT_node_options Control:DIALOG_nodeexporter.ExportTo.ROLLOUT_node_options.ET_replace_in_name val:val 



/* ============= CUSTOM CALLBACK ============= */
(macros.run "Selection" "selection_edit_replace_in_names")
EventFired = undefined /* RESET GLOBAL VARIABLE */
)
	)
	on BTN_search_replace pressed  do 
	(
		(

/*--- EventFired: Definition of struct ---*/
execute "struct EventFired_v( Type, Roll, Control, function get prop = ( if hasProperty this ( prop as name ) then getProperty this ( prop as name ) else false  ) )"

/*--- CAST INSTANCE TO GLOBAL VARIABLE ---*/
global EventFired = EventFired_v Type:#pressed Roll:DIALOG_nodeexporter.ExportTo.ROLLOUT_node_options Control:DIALOG_nodeexporter.ExportTo.ROLLOUT_node_options.BTN_search_replace 



/* ============= CUSTOM CALLBACK ============= */
(macros.run "Selection" "selection_search_and_replace")
EventFired = undefined /* RESET GLOBAL VARIABLE */
)
	)
	local AUTORUN_EVENTS = Dictionary #string 
	on ROLLOUT_node_options rolledUp val do
(
	if val then
	(
		if keyboard.controlPressed then
		rollUpOtherRolloutsCallback ( #DIALOG_nodeexporter) ( #ExportTo) ( #ROLLOUT_node_options)
else
		autoRollUpRolloutCallback ( #DIALOG_nodeexporter) ( #ExportTo) ( #ROLLOUT_node_options)
)
)
)
rollout DIALOG_nodeexporter "NodeExporter"
(
	local ini = "c:\\Users\\vilbur\\AppData\\Local\\Autodesk\\3dsMax\\2023 - 64bit\\ENU\\scripts\\MAXSCRIPT-nodeExporter\\nodeExporter.ini"
	button BTN_create "Create" controller:undefined ini:true height:48 across:3 width:64 pos:[184,24] labelOnTop:false toolTip:"Create Export Node\n\nNode name is exported filename\n\nSelected objects will be linked to new node"
	button BTN_link "Link" controller:undefined ini:true height:48 width:64 across:3 pos:[250,24] labelOnTop:false toolTip:"LINK TO NODE:\n(link selected obgjects to selcted node)"
	button BTN_refresh "Refresh" controller:undefined ini:true height:48 width:64 across:3 pos:[316,24] labelOnTop:false toolTip:"Refresh nodes in list"
	button BTN_group "Group" controller:undefined ini:true height:48 width:64 across:3 pos:[184,72] labelOnTop:false toolTip:"Group selected nodes"
	button BTN_unify "Unify" controller:undefined ini:true height:48 width:64 across:3 pos:[250,72] labelOnTop:false toolTip:"Set size and path of selected export nodes\n\n1st selected node is source object"
	label fake245998314 "" controller:undefined ini:true labelOnTop:false
	multiListBox ML_nodes "Nodes" controller:undefined ini:true selection:#{} height:19 across:2 width:160 offset:[0,-120] labelOnTop:false Event:#selectionEnd Control:"multilistbox" toolTip:"SelectionEnd: Nodes to export

DoubleClicked: Isolate node children\n\nCtrl+LMB: Select node children."
	multiListBox ML_node_groups "Node Groups" controller:undefined ini:true selection:#{} height:9 across:2 width:160 offset:[0,8] labelOnTop:false Event:#selectionEnd Control:"multilistbox" toolTip:"SelectionEnd: Nodes to export

DoubleClicked: Nodes to export"
	on BTN_create pressed  do 
	(
		(

/*--- EventFired: Definition of struct ---*/
execute "struct EventFired_v( Type, Roll, Control, function get prop = ( if hasProperty this ( prop as name ) then getProperty this ( prop as name ) else false  ) )"

/*--- CAST INSTANCE TO GLOBAL VARIABLE ---*/
global EventFired = EventFired_v Type:#pressed Roll:DIALOG_nodeexporter Control:DIALOG_nodeexporter.BTN_create 



/* ============= CUSTOM CALLBACK ============= */
(macros.run "_Export" "_ExportNodePlugin_create")
EventFired = undefined /* RESET GLOBAL VARIABLE */
)
	)
	on BTN_link pressed  do 
	(
		(

/*--- EventFired: Definition of struct ---*/
execute "struct EventFired_v( Type, Roll, Control, function get prop = ( if hasProperty this ( prop as name ) then getProperty this ( prop as name ) else false  ) )"

/*--- CAST INSTANCE TO GLOBAL VARIABLE ---*/
global EventFired = EventFired_v Type:#pressed Roll:DIALOG_nodeexporter Control:DIALOG_nodeexporter.BTN_link 



/* ============= CUSTOM CALLBACK ============= */
(macros.run "_Export" "_ExportNodePlugin_link_selection")
EventFired = undefined /* RESET GLOBAL VARIABLE */
)
	)
	on BTN_refresh pressed  do 
	(
		(

/*--- EventFired: Definition of struct ---*/
execute "struct EventFired_v( Type, Roll, Control, function get prop = ( if hasProperty this ( prop as name ) then getProperty this ( prop as name ) else false  ) )"

/*--- CAST INSTANCE TO GLOBAL VARIABLE ---*/
global EventFired = EventFired_v Type:#pressed Roll:DIALOG_nodeexporter Control:DIALOG_nodeexporter.BTN_refresh 



/* ============= CUSTOM CALLBACK ============= */
(macros.run "_Export" "_ExportNodePlugin_load")
EventFired = undefined /* RESET GLOBAL VARIABLE */
)
	)
	on BTN_group pressed  do 
	(
		(

/*--- EventFired: Definition of struct ---*/
execute "struct EventFired_v( Type, Roll, Control, function get prop = ( if hasProperty this ( prop as name ) then getProperty this ( prop as name ) else false  ) )"

/*--- CAST INSTANCE TO GLOBAL VARIABLE ---*/
global EventFired = EventFired_v Type:#pressed Roll:DIALOG_nodeexporter Control:DIALOG_nodeexporter.BTN_group 



/* ============= CUSTOM CALLBACK ============= */
(macros.run "_Export" "_export_group_nodes")
EventFired = undefined /* RESET GLOBAL VARIABLE */
)
	)
	on BTN_unify pressed  do 
	(
		(

/*--- EventFired: Definition of struct ---*/
execute "struct EventFired_v( Type, Roll, Control, function get prop = ( if hasProperty this ( prop as name ) then getProperty this ( prop as name ) else false  ) )"

/*--- CAST INSTANCE TO GLOBAL VARIABLE ---*/
global EventFired = EventFired_v Type:#pressed Roll:DIALOG_nodeexporter Control:DIALOG_nodeexporter.BTN_unify 



/* ============= CUSTOM CALLBACK ============= */
(macros.run "_Export" "_ExportNodePlugin_unify")
EventFired = undefined /* RESET GLOBAL VARIABLE */
)
	)
	on ML_nodes doubleClicked val do 
	(
		(

/*--- EventFired: Definition of struct ---*/
execute "struct EventFired_v( Type, Roll, Control, val,
selection = for i in Control.selection collect Control.items[i], function get prop = ( if hasProperty this ( prop as name ) then getProperty this ( prop as name ) else false  ) )"

/*--- CAST INSTANCE TO GLOBAL VARIABLE ---*/
global EventFired = EventFired_v Type:#doubleClicked Roll:DIALOG_nodeexporter Control:DIALOG_nodeexporter.ML_nodes val:val 



/* ============= CUSTOM CALLBACK ============= */
(macros.run "_Export" "_export_isolate_node_objects")
EventFired = undefined /* RESET GLOBAL VARIABLE */
)
	)
	on ML_nodes selectionEnd  do 
	(
		(

/*--- EventFired: Definition of struct ---*/
execute "struct EventFired_v( Type, Roll, Control,
selection = for i in Control.selection collect Control.items[i], function get prop = ( if hasProperty this ( prop as name ) then getProperty this ( prop as name ) else false  ) )"

/*--- CAST INSTANCE TO GLOBAL VARIABLE ---*/
global EventFired = EventFired_v Type:#selectionEnd Roll:DIALOG_nodeexporter Control:DIALOG_nodeexporter.ML_nodes 



/* ============= CUSTOM CALLBACK ============= */
(macros.run "_Export" "_ExportNodePlugins_list")
EventFired = undefined /* RESET GLOBAL VARIABLE */
)
	)
	on ML_node_groups doubleClicked val do 
	(
		(

/*--- EventFired: Definition of struct ---*/
execute "struct EventFired_v( Type, Roll, Control, val,
selection = for i in Control.selection collect Control.items[i], function get prop = ( if hasProperty this ( prop as name ) then getProperty this ( prop as name ) else false  ) )"

/*--- CAST INSTANCE TO GLOBAL VARIABLE ---*/
global EventFired = EventFired_v Type:#doubleClicked Roll:DIALOG_nodeexporter Control:DIALOG_nodeexporter.ML_node_groups val:val 



/* ============= CUSTOM CALLBACK ============= */
(macros.run "_Export" "_ExportNodePlugins_groups_list_isolate")
EventFired = undefined /* RESET GLOBAL VARIABLE */
)
	)
	on ML_node_groups selectionEnd  do 
	(
		(

/*--- EventFired: Definition of struct ---*/
execute "struct EventFired_v( Type, Roll, Control,
selection = for i in Control.selection collect Control.items[i], function get prop = ( if hasProperty this ( prop as name ) then getProperty this ( prop as name ) else false  ) )"

/*--- CAST INSTANCE TO GLOBAL VARIABLE ---*/
global EventFired = EventFired_v Type:#selectionEnd Roll:DIALOG_nodeexporter Control:DIALOG_nodeexporter.ML_node_groups 



/* ============= CUSTOM CALLBACK ============= */
(macros.run "_Export" "_ExportNodePlugins_groups_list_select")
EventFired = undefined /* RESET GLOBAL VARIABLE */
)
	)
	local BP_export_path_prev_state = ""
	group "EXPORT-PATH" (
	button BTN_open_export_path "" controller:undefined ini:true across:10 width:16 offset:[-16,0] labelOnTop:false toolTip:"Open Export Path"
	label fake543482087 "" controller:undefined ini:true labelOnTop:false
	label fake632148293 "" controller:undefined ini:true labelOnTop:false
	label fake143274324 "" controller:undefined ini:true labelOnTop:false
	label fake954182055 "" controller:undefined ini:true labelOnTop:false
	label fake861999337 "" controller:undefined ini:true labelOnTop:false
	label fake39649475 "" controller:undefined ini:true labelOnTop:false
	label fake307624683 "" controller:undefined ini:true labelOnTop:false
	label fake581721517 "" controller:undefined ini:true labelOnTop:false
	label fake510717231 "" controller:undefined ini:true labelOnTop:false
	edittext BP_export_path "" border:false controller:undefined ini:true across:1 width:368.0 mode:#getSavePath historyCategory:undefined offset:[5,-24] caption:undefined labelOnTop:false initialDir:"maxFilePath" types:"All files|*.*|" Control:"browsePath" filename:undefined toolTip:"Set\Get export dir of selected nodes"
	checkbox CBX_sub_directory_by_node_name "Sub directory by node name" controller:undefined ini:true across:1 checked:false labelOnTop:false Control:"checkbox" toolTip:"Export each node to custom subfolder of export path\n\nE.G: 'Export_Dir\Node_Name\Node_Name.obj'"
	)
	on BTN_open_export_path pressed  do 
	(
		(

/*--- EventFired: Definition of struct ---*/
execute "struct EventFired_v( Type, Roll, Control, function get prop = ( if hasProperty this ( prop as name ) then getProperty this ( prop as name ) else false  ) )"

/*--- CAST INSTANCE TO GLOBAL VARIABLE ---*/
global EventFired = EventFired_v Type:#pressed Roll:DIALOG_nodeexporter Control:DIALOG_nodeexporter.BTN_open_export_path 



/* ============= CUSTOM CALLBACK ============= */
(macros.run "_Export" "_export_path_2nd")
EventFired = undefined /* RESET GLOBAL VARIABLE */
)
	)
	on BP_export_path changed val do 
	(
		(

/*--- EventFired: Definition of struct ---*/
execute "struct EventFired_v( Type, Roll, Control, val, function get prop = ( if hasProperty this ( prop as name ) then getProperty this ( prop as name ) else false  ) )"

/*--- CAST INSTANCE TO GLOBAL VARIABLE ---*/
global EventFired = EventFired_v Type:#changed Roll:DIALOG_nodeexporter Control:DIALOG_nodeexporter.BP_export_path val:val 


/* ============= DEFAULT CALLBACK ============= */
		function valueIsEmpty _string = (( dotNetClass "System.Text.RegularExpressions.RegEx").match _string "^\s+$|^$" ).success
		

		
		/*  IF VALUE HAS CHANGED AND FIELD IS EMPTY */
		if( val != BP_export_path_prev_state and valueIsEmpty(val) and valueIsEmpty(BP_export_path_prev_state) ) then
		(
			/* OPEN BROWSE DIALOG */ 
			if( (browsed_path = getSavePath initialDir:maxFilePath types:"All files|*.*|") != undefined ) then 
			(
				/* IF SUCCESS - PATH HAS BEEN BROWSED */ 
				BP_export_path.text    = browsed_path as string
				BP_export_path.tooltip = browsed_path as string

				val = EventFired.val = substituteString browsed_path "\\" "\\\\"
			)
			
			else
			(
				/* IF DIALOG WAS CANCELED */ 
				BP_export_path_prev_state = val
				BP_export_path.tooltip = ""
			)
		)
		else
		(
			BP_export_path_prev_state = BP_export_path.text
			BP_export_path.tooltip = ""
		)

/* ============= CUSTOM CALLBACK ============= */
(macros.run "_Export" "_export_path")
EventFired = undefined /* RESET GLOBAL VARIABLE */
)
	)
	on BP_export_path entered val do 
	(
		(

/*--- EventFired: Definition of struct ---*/
execute "struct EventFired_v( Type, Roll, Control, val, function get prop = ( if hasProperty this ( prop as name ) then getProperty this ( prop as name ) else false  ) )"

/*--- CAST INSTANCE TO GLOBAL VARIABLE ---*/
global EventFired = EventFired_v Type:#entered Roll:DIALOG_nodeexporter Control:DIALOG_nodeexporter.BP_export_path val:val 


/* ============= DEFAULT CALLBACK ============= */
if( val != "" ) then
				val = EventFired.val = BP_export_path.tooltip = substituteString val "\\" "\\\\"

			else
				BP_export_path.tooltip = "Set\Get export dir of selected nodes"
EventFired = undefined /* RESET GLOBAL VARIABLE */
)
	)
	on CBX_sub_directory_by_node_name changed val do 
	(
		(

/*--- EventFired: Definition of struct ---*/
execute "struct EventFired_v( Type, Roll, Control, val, function get prop = ( if hasProperty this ( prop as name ) then getProperty this ( prop as name ) else false  ) )"

/*--- CAST INSTANCE TO GLOBAL VARIABLE ---*/
global EventFired = EventFired_v Type:#changed Roll:DIALOG_nodeexporter Control:DIALOG_nodeexporter.CBX_sub_directory_by_node_name val:val 



/* ============= CUSTOM CALLBACK ============= */
(macros.run "_Export" "_export_subfolder_per_node")
EventFired = undefined /* RESET GLOBAL VARIABLE */
)
	)
	group "Export-Options" (
	spinner SPIN_export_size "EXPORT SIZE       " fieldwidth:48 controller:undefined ini:true align:#left across:1 width:96 offset:[16,0] labelOnTop:false range:[0,100,1] id:"SPIN_export_size" Control:"spinner" toolTip:"Export size"
	)
	on SPIN_export_size changed val inSpin do 
	(
		(

/*--- EventFired: Definition of struct ---*/
execute "struct EventFired_v( Type, Roll, Control, val, inSpin, function get prop = ( if hasProperty this ( prop as name ) then getProperty this ( prop as name ) else false  ) )"

/*--- CAST INSTANCE TO GLOBAL VARIABLE ---*/
global EventFired = EventFired_v Type:#changed Roll:DIALOG_nodeexporter Control:DIALOG_nodeexporter.SPIN_export_size val:val inSpin:inSpin 



/* ============= CUSTOM CALLBACK ============= */
(macros.run "_Export" "_export_settings_set_size")
EventFired = undefined /* RESET GLOBAL VARIABLE */
)
	)
	subRollout ExportTo "ExportTo" height:1044 offset:[-12,0] width:398
	local AUTORUN_EVENTS = Dictionary #string 
	on DIALOG_nodeexporter open do
(
	GROUPBOXCREATOR.sortControlsToGroupBoxes( DIALOG_nodeexporter )
)
	on DIALOG_nodeexporter resized val do
(
	waitForResizingEndsTimer(#DIALOG_nodeexporter)
)
	on DIALOG_nodeexporter okToClose do
(
	format "TEST EVENT: #OKTOCLOSE  Rollout: DIALOG_nodeexporter
";
(UiStateSaver_v ini_file:"c:/Users/vilbur/AppData/Local/Autodesk/3dsMax/2023 - 64bit/ENU/scripts/MAXSCRIPT-nodeExporter/nodeExporter.ini").saveControlsAndSubrollouts("DIALOG_nodeexporter")

	true -- IMPORTANT - #oktoclose MUST RETURN BOOLEAN
)
	on DIALOG_nodeexporter DOCKED val do
(
	format "TEST DEFAULT EVENT: #DOCKED  Rollout: DIALOG_nodeexporter
";
(UiStateSaver_v ini_file:"c:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-nodeExporter\nodeExporter.ini").saveDialogDockState("DIALOG_nodeexporter")
	
	format "TEST DEFAULT EVENT: #DOCKED  Rollout: DIALOG_nodeexporter
";
(UiStateSaver_v ini_file:"c:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-nodeExporter\nodeExporter.ini").saveDialogDockState("DIALOG_nodeexporter")
)
	on DIALOG_nodeexporter UNDOCKED val do
(
	format "TEST DEFAULT EVENT: #UNDOCKED  Rollout: DIALOG_nodeexporter
";
(UiStateSaver_v ini_file:"c:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-nodeExporter\nodeExporter.ini").saveDialogState("DIALOG_nodeexporter")
	
	format "TEST DEFAULT EVENT: #UNDOCKED  Rollout: DIALOG_nodeexporter
";
(UiStateSaver_v ini_file:"c:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-nodeExporter\nodeExporter.ini").saveDialogState("DIALOG_nodeexporter")
)
)
rollout ROLLOUT_zbrush "Z B R U S H "
(
	group "MaxToZbrushSync" (
	button BTN_max_zbrush "Max > ZBrush" controller:undefined ini:true height:48 across:2 width:190 labelOnTop:false
	button BTN_zbrush_max "ZBrush > Max" controller:undefined ini:true height:48 width:190 across:2 labelOnTop:false
	)
	on BTN_max_zbrush pressed  do 
	(
		(

/*--- EventFired: Definition of struct ---*/
execute "struct EventFired_v( Type, Roll, Control, function get prop = ( if hasProperty this ( prop as name ) then getProperty this ( prop as name ) else false  ) )"

/*--- CAST INSTANCE TO GLOBAL VARIABLE ---*/
global EventFired = EventFired_v Type:#pressed Roll:DIALOG_nodeexporter.ExportTo.ROLLOUT_zbrush Control:DIALOG_nodeexporter.ExportTo.ROLLOUT_zbrush.BTN_max_zbrush 



/* ============= CUSTOM CALLBACK ============= */
(macros.run "_3DsMaxSync" "_3DsMaxSync_to_zbrush")
EventFired = undefined /* RESET GLOBAL VARIABLE */
)
	)
	on BTN_zbrush_max pressed  do 
	(
		(

/*--- EventFired: Definition of struct ---*/
execute "struct EventFired_v( Type, Roll, Control, function get prop = ( if hasProperty this ( prop as name ) then getProperty this ( prop as name ) else false  ) )"

/*--- CAST INSTANCE TO GLOBAL VARIABLE ---*/
global EventFired = EventFired_v Type:#pressed Roll:DIALOG_nodeexporter.ExportTo.ROLLOUT_zbrush Control:DIALOG_nodeexporter.ExportTo.ROLLOUT_zbrush.BTN_zbrush_max 



/* ============= CUSTOM CALLBACK ============= */
(macros.run "_3DsMaxSync" "_3DsMaxSync_to_max")
EventFired = undefined /* RESET GLOBAL VARIABLE */
)
	)
	local AUTORUN_EVENTS = Dictionary #string 
	on ROLLOUT_zbrush rolledUp val do
(
	if val then
	(
		if keyboard.controlPressed then
		rollUpOtherRolloutsCallback ( #DIALOG_nodeexporter) ( #ExportTo) ( #ROLLOUT_zbrush)
else
		autoRollUpRolloutCallback ( #DIALOG_nodeexporter) ( #ExportTo) ( #ROLLOUT_zbrush)
)
)
)

CreateDialog DIALOG_nodeexporter width:width height:height pos:pos bgcolor:bgcolor fgcolor:fgcolor bitmap:bitmap bmpstyle:bmpstyle style:style modal:modal autoLayoutOnResize:autoLayoutOnResize escapeEnable:escapeEnable lockHeight:lockHeight lockWidth:lockWidth parent:parent 

try(

	AddSubRollout DIALOG_nodeexporter.ExportTo ROLLOUT_node_options rolledUp:true -- nested_level:1

	AddSubRollout DIALOG_nodeexporter.ExportTo ROLLOUT_3d_print rolledUp:false -- nested_level:1

	AddSubRollout DIALOG_nodeexporter.ExportTo ROLLOUT_obj rolledUp:true -- nested_level:1

	AddSubRollout DIALOG_nodeexporter.ExportTo ROLLOUT_unreal rolledUp:true -- nested_level:1

	AddSubRollout DIALOG_nodeexporter.ExportTo ROLLOUT_zbrush rolledUp:false -- nested_level:1
)catch()


DIALOG_nodeexporter-- return
)