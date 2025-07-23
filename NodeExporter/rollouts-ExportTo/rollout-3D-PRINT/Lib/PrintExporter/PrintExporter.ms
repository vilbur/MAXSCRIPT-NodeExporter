filein( getFilenamePath(getSourceFileName()) + "/../PrinterVolume/PrinterVolume.ms" )	-- "./../PrinterVolume/PrinterVolume.ms"


/** Print exporter
  *
  * Template files for new projects: -- "./../../Final-Files-Templates/"
  *
  * @param 2DMatrix open_in_programs #( #("C:\Path\to\program.exe", "project_file_extension") )
  *
  * How to export objects on exact position and rotation:
  * 		1) Create animation of nodes with desired position and rotation
  * 		2) Last animation key of node is set to export
  * 		3) If position key is set, then dummy boxes are exported in corners of printer plate (this will keep objects on right position)
 */
struct PrintExporter_v
(
	/* construct */
	ExportNodePlugins,


	/* properties */
	params	= Dictionary #( #EXPORT_FORMAT, "obj" ) #( #EXPORT_SCALE, 1 ) #( #SUBDIR_BY_NODE, false ) #( #FIX_POSITION, false ) #( #OPEN_IN, 0 ) #( #PROJECT_FILE_OPEN, false ) #( #EXCLUDE, "" ) #( #ANIMATION, false ) #( #KEEP_EXPORTED, false )  ,

	open_in_programs = #( #("C:/Program Files/CHITUBOX  V1.9.4/Chitubox.exe", "chitubox"), #("C:/Program Files/LycheeSlicer/LycheeSlicer.exe", "lys")),

	exported_paths = #(),

	anim_keys	= Dictionary #( #position, 0 ) #( #rotation, 0 ),

	fetch_state	= Dictionary #( #layer_manager_open, true ),

	fix_position_dummy = #(),

	success_message = "",
	
	offset = [0,0,0],

	offset_x_gap = 1.0,
	
	/* dependency */
	Exporter,

	/* reference */
	/* inhered */

	/** Export eachodes
	  * Manage scene on export
	 */
	function export =
	(
		format "\n"; print "PrintExporter_v.export()"
		format "\n-----------\nDICTIONARY:params:%\n" params; for data_pair in params do format "%:	%\n" data_pair.key data_pair.value

		--if LayerManager.isDialogOpen() then
		--	LayerManager.closeDialog()

		this._setExporterOptions()

		this._holdMaxState()

		current_time = currentTime.frame as integer
		format "current_time: %\n" current_time
		

		
		end_time = if params[#ANIMATION] then animationRange.end.frame as integer else current_time
		format "end_time: %\n" end_time
		export_keys = for export_key = current_time to end_time collect export_key 
		
		if params[#ANIMATION] and not queryBox ("Export animation of keys " + export_keys as string ) title:"EXPORT ANIMATION"  beep:false then
			 return false
			 --params[#ANIMATION] = false
		
		format "EXPORT_KEYS: %\n" export_keys
		
		this._fixExportPosition()
		
		keep_exported = params[#KEEP_EXPORTED] and queryBox ("Keep copies of exported objects ?") title:"PrintExporter_v"
		
		try(
			--this._setExportLastKeyFrame
			
			for i = 1 to export_keys.count do 
			(
				export_key = export_keys[i]
				--this._holdMaxState()
				
				format "export_key: %\n" export_key
				this._setTimeSlider (export_key)
				
				/*------------------------------------------------------------------------------
					EXPORT NODE
				--------------------------------------------------------------------------------*/
				for selected_node in this.ExportNodePlugins do
					this._exportNode (selected_node) offset_x:(if i == 1 then false else DIALOG_nodeexporter.CBX_offset.state ) frame:i keep_exported:keep_exported
			
				--this._fetchMaxState()
			)


			this._setSuccessMessage()

			this._openExportedFiles()

			delete this.fix_position_dummy

			this._setTimeSlider (current_time)
		
			this._successMessage()

		)catch(

			format "\n\n*** EXPORTER ERROR ***\n\n"
			format "\n——————————————— ERROR IN FILE ———————————————\n\n%\n" (getSourceFileName())
			format "\n————————————————— EXCEPTION —————————————————\n\n%\n" (getCurrentException())
			format "\n——————————————————— TRACE ———————————————————\n%\n"   (getCurrentExceptionStackTrace())

			this._fetchMaxState()
		)
	),

	/** Open in chitubox
	  *
	  * @param array paths_to_open
	  *
	  * FORMAT OF COMMAND TO OPEN FILES IN CHITUBOX:
	  * 		ShellLaunch "C:/Chitubox.exe" "\"c:\\File_1.obj\" \"c:\\File_1.obj\""
	  *
	 */
	function openInProgram paths_to_open =
	(
		--format "\n"; print "PrintExporter_v.openInProgram()"
		--format "this._getOpenInProgramPath()	= % \n" (this._getOpenInProgramPath())
		files_paths_string = ""
		--format "files_paths_string	= % \n" files_paths_string
		for path_to_open in paths_to_open where doesFileExist path_to_open do files_paths_string += " \""+path_to_open+"\""

		DOSCommand ( "start \"\" "  + "\""+ this._getOpenInProgramPath() +"\" " + files_paths_string )
	),



	/** Get export file path
	 */
	function getExportFilePath ExportNodePlugin =
	(
		--format "\n"; print "ExporterSetup_v.getExportFilePath()"
		/** Get frame suffix
		 */
		function getFrameSuffix = if ( currentTime_frame = (currentTime.frame as integer ) as string ).count < 2 then "0" + currentTime_frame else currentTime_frame

		subdir = if this.params[#SUBDIR_BY_NODE] then "/"+ExportNodePlugin.name + "/" else "/"

		filename = ExportNodePlugin.name
		
		if params[#ANIMATION] then
			filename += "-" + (getFrameSuffix())

		--format "FILENAME: %\n" filename
		filename += "." + this.params[#EXPORT_FORMAT]
		
		export_path =  (this._getExportDir(ExportNodePlugin.export_dir)) + subdir + filename


		( dotNetObject "System.Text.RegularExpressions.Regex" @"[\\/]+" ).Replace export_path "\\\\" -- return
	),


	private


	/*------------------------------------------------------------------------------

		EXPORT NODE

	--------------------------------------------------------------------------------*/
	function _exportNode ExportNodePlugin keep_exported:false offset_x:false frame:undefined =
(
		--format "\n"; print "PrintExporter_v._exportNode()"
		--format "ExportNodePlugin: %\n" ExportNodePlugin

		max create mode

		export_path 	= this.getExportFilePath(ExportNodePlugin)
		export_objs_source	= ExportNodePlugin.getAllChildren()
		
		
		--format "EXPORT_OBJECTS: %\n" export_objects

		select export_objs_source
		
		node_children_size = abs ( selection.max.x - selection.min.x )
		
		if offset_x then
			this.offset.x += node_children_size + offset_x_gap
		
		
		/* ENABLE MODIFIERS */
		if this.params[#MESHSMOOTH] then
            for obj in export_objs_source where ( _mod = obj.modifiers[ meshsmooth ]) != undefined do
                _mod.enabled = true

		/*------------------------------------------------------------------------------
			COPY OBJECTS TO EXPORT
		--------------------------------------------------------------------------------*/		
				
		export_copies = this._getCopyOfExportObjects(export_objs_source)

		export_objects = this._excludeObjects(export_copies)
		
		
		if this.params[#UNSMOOTH_VERTEX_COLOR] then
			this._collapseSmoothAndUnsmoothVertexColor(export_objects)
		
		/*------------------------------------------------------------------------------
			EXPORT
		--------------------------------------------------------------------------------*/
		export_result = Exporter.export ( export_objects + this.fix_position_dummy ) (export_path)
		
		/*------------------------------------------------------------------------------
			DELETE OR RENMA EXPORTED OBJECT 
		--------------------------------------------------------------------------------*/
		if keep_exported then
		(
			/* RENAME OBJECTS BY EXPORT FILENAME */ 
			--for export_copy in export_copies do
			for i = 1 to export_copies.count do
			(
				export_copy = export_copies[i]
				
				if findItem export_objects export_copy > 0 then
				(
					/* RENAME OBJECT */ 
					export_copy.name = getFilenameFile(export_path)
					
					/* COPY VERTEX COLOR */ 
					if this.params[#UNSMOOTH_VERTEX_COLOR] then
						copyVertexColors export_objects[i] export_copy
					
				)
				else
					delete export_copy -- delete excluded objects
			)
		)
		else
			delete export_copies
		

		--/* APPEND EXPORT PATH TO OTHER PATHS */
		if export_result != false then
			append this.exported_paths export_path
	),
	
	/** Get copy of export objects
	 */
	function _getCopyOfExportObjects export_objs =
	(
		--format "\n"; print "PrintExporter_v._getCopyOfExportObjects()"
		export_copies = #()
		
		/* CLONE NODES FOR EXPORT */ 
		maxOps.CloneNodes export_objs expandHierarchy:true newNodes:&export_copies --offset:this.offset

		/* COLLAPSE CLONES */ 
		for obj in export_copies do
			convertTo obj PolyMeshObject
			
		/* OFFSET FRAME */ 
		move export_copies this.offset		
		
		for i = 1 to export_copies.count do
		(
			export_copies[i].parent = undefined
			
			export_copies[i].name = export_objs[i].name
		)		
		
		export_copies --return
	),
	
	/** Collapse smooth and unsmooth vertex color
	 */
	function _collapseSmoothAndUnsmoothVertexColor export_objects =
	(
		--format "\n"; print "PrintExporter_v._collapseSmoothAndUnsmoothVertexColor()"
		for obj in export_objects do
		(
			msmooth_found = false
			
			for i = 1 to obj.modifiers.count while not msmooth_found where classOf obj.modifiers[i] == meshsmooth do
				msmooth_found = true
			
			if msmooth_found then
				smoothAndKeepVertexColors( obj )
		)
	),

	/** Set exporter
	 */
	function _setExporterOptions =
	(
		--format "\n"; prOptionsint "PrintExporter_v._setExporter()"
		Exporter = case this.params[#EXPORT_FORMAT] of
		(
			"obj":  ExporterOBJ_v(#Print)
			"stl":	ExporterSTL_v()
		)

		Exporter.setPresetFile("print")

		Exporter.setExportScale(this.params[#EXPORT_SCALE])
	),


	/** Hold max state
	 */
	function _holdMaxState =
	(
		--format "\n"; print "PrintExporter_v._holdMaxState()"
		holdMaxFile()

		this.fetch_state[#layer_manager_open] = LayerManager.isDialogOpen()

	),

	/** Fetch max state
	 */
	function _fetchMaxState =
	(
		--format "\n"; print "PrintExporter_v._fetchMaxState()"
		print "PrintExporter: FETCHING SCENE"

		fetchMaxFile quiet:true

		if this.fetch_state[#layer_manager_open] then
			macros.run "Layers" "LayerManager"

		sliderTime = this._getLastAnimKey()
	),

	/** Open exported files
	 */
	function _openExportedFiles =
	(
		format "\n"; print "PrintExporter_v._openExportedFiles()"
		format "this.exported_paths	= % \n" this.exported_paths

		if this.params[#OPEN_IN] > 0 and this.exported_paths.count > 0 then
		(
			this._addProjectFileToOpenPaths()

			--if this.params[#OPEN_IN] > 0 then
			--(
			if this.params[#CLOSE_INSTANCES] then
				this._killInstances()

				this.openInProgram(this.exported_paths)
			--)
		)
	),

	/** Get path to final file where exported files will be merged
	  *
	  *  Name of merge is parent group of nodes
	  *  Path of merge is export path of first selected node
	  *
	  */
	function _addProjectFileToOpenPaths =
	(

		if this.params[#PROJECT_FILE_OPEN] then
		(
			node_groups = makeUniqueArray( for _node in this.ExportNodePlugins where _node.parent != undefined and isGroupHead _node.parent collect _node.parent)

			if node_groups.count > 0 then
			(
				extension = this.open_in_programs[this.params[#OPEN_IN]][2]

				final_file = (this._getExportDir(this.ExportNodePlugins[1].export_dir)) + "\\" + node_groups[1].name + "." + extension

				if not doesFileExist final_file then
					copyFile  ( getFilenamePath(getSourceFileName()) + "..\\..\\Final-Files-Templates\\template." + extension ) final_file -- COPY EMPTY FILE "./../../Final-Files-Templates/template.chitubox"

				this.exported_paths = #( final_file ) + this.exported_paths
			)
		)
	),


	/** Move time slider to last key, if export nodes has animated position or rotastion
		*
		*
	    */
    function _setExportLastKeyFrame =
	(
		--format "\n"; print "PrintExporter_v._setExportLastKeyFrame()"
		this.anim_keys[#position]	= this._getLastKeyOfAnimation(#position)
		this.anim_keys[#rotation]	= this._getLastKeyOfAnimation(#rotation)

		this._setTimeSlider(this._getLastAnimKey())
	),
	
	/** Get last anim key
	 */
	function _getLastAnimKey =
	(
		--format "\n"; print "PrintExporter_v._getLastAnimKey()"

		anim_key_values = for data_pair in anim_keys where data_pair.value != 0 collect data_pair.value

		if anim_key_values.count > 0 then
			amax anim_key_values --return
		else
			0 --return
	),

    /** create boxes in corners of print plane to keep exported position
     */
    function _fixExportPosition =
	(
		--format "\n"; print "PrintExporter_v._fixExportPosition()"
		delete this.fix_position_dummy
		--this.fix_position_dummy = if this.params[#FIX_POSITION] or this.anim_keys[#position] > 0 then
		this.fix_position_dummy = if this.params[#FIX_POSITION] then
			(PrinterVolume_v(this.params[#EXPORT_SCALE])).fixPositionionObjects()
		else
			#()
	),

	/** Check if selected nodes has animation keys
	  *
	  * @param name controller_type #position|#rotation|#scale
	  *
	  * @return integer of last key of animation
	 */
	function _getLastKeyOfAnimation controller_type =
	(
		--format "\n"; print "ExporterSetup_v._getLastKeyOfRotateAnimation()"
		last_keyframe 	= 0

		for ExportNodePlugin in this.ExportNodePlugins where (node_anim_keys = ExportNodePlugin.getAnimationKeys(controller_type) ).count > 0 do
			if node_anim_keys[node_anim_keys.count] > last_keyframe then  -- get last key if higher
				last_keyframe = node_anim_keys[node_anim_keys.count]

		last_keyframe --return
	),


	/** Export dir consist of CURRENT SCENE PATH + RELATIVE PATH of ExportNodePlugin.export_dir
	*
	*/
	function _getExportDir node_export_dir =
	(
		maxFilePath + (trimLeft node_export_dir ".\\")
	),

	/** Set time slider
	 */
	function _setTimeSlider keyframe =
	(
		--format "\n"; print "ExporterSetup_v.setTimeSlider()"
		sliderTime = keyframe

		
		--current_keyframe	= (( sliderTime ) as string ) as integer

		/* MOVE TIME SLIDER */
		--if current_keyframe != keyframe then
		--	if queryBox ("Exported nodes has animation of rotation.\n\nWould you like to export key "+keyframe as string +" ?" ) title:"Export animation key"  beep:false then
		--		sliderTime = keyframe
	),


	/** Get open in program path
	 */
	function _getOpenInProgramPath =
	(
		--format "\n"; print "PrintExporter_v.getEnInProgramPath()"
		--format "this.params[#OPEN_IN]	= % \n" this.params[#OPEN_IN]

		if this.params[#OPEN_IN] == 0 then
		(
			format "\n"; print ("PrintExporter_v.getEnInProgramPath()\n\nWARNING: No open file has been chosen.\n\nFIRST IS USED: " + this.open_in_programs[1][1] )


			this.open_in_programs[1]
		)
		else
			this.open_in_programs[this.params[#OPEN_IN]][1] --return
	),

	/** Kill instances of open in program
	 */
	function _killInstances =
	(
		--format "\n"; print "PrintExporter_v._killInstances()"

		DOSCommand ("taskkill /IM "+ filenameFromPath( this._getOpenInProgramPath()))
	),


	/** Exclude obejcts matching name
	 */
	function _excludeObjects export_objects =
	(
		--format "\n"; print "PrintExporter_v.excludeObejcts()"

		export_objects = deepCopy export_objects -- copy to avoid modifyng source array
		
		/** Matching name
		 */
		function matchingName _string pattern = (( dotNetClass "System.Text.RegularExpressions.RegEx" ).match _string pattern ( dotNetClass "System.Text.RegularExpressions.RegexOptions" ).IgnoreCase ).success

		if ( params[#EXCLUDE] ) != "" then
		(
			pattern = ".*("+params[#EXCLUDE]+").*"

			for i = export_objects.count to 1 by -1 where matchingName export_objects[i].name pattern do
				deleteItem export_objects (findItem export_objects export_objects[i])
		)

		export_objects --return
	),


	/** set Success message
	 */
	function _setSuccessMessage =
	(
		--format "\n"; print "PrintExporter_v._successMessage()"
		for exported_path in exported_paths do success_message += filenameFromPath(exported_path) + "\n"
	),

	/** Success message
	 */
	function _successMessage =
	(
		--format "\n"; print "PrintExporter_v._successMessage()"
		if this.exported_paths.count == 0 then
			return false

		--print ("\n\n------------------------- EXPORT SUCCESFULL -------------------------\n\n" + success_message)

		format "\n\n----- EXPORTED FILES: -----	% \n" success_message
		--messageBox success_message title:"EXPORT SUCCESFULL"  beep:false
		format "\nEXPORT SUCCESFULL"

	),

	/**
	 */
	on create do
	(
		format "\n"; print "PrintExporter.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
