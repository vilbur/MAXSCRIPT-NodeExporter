--filein( getFilenamePath(getSourceFileName()) + "/../PrinterVolume/PrinterVolume.ms" )	-- "./../PrinterVolume/PrinterVolume.ms"

filein( getFilenamePath(getSourceFileName()) + "/PrintPostExporter/PrintPostExporter.ms" )	--"./PrintPostExporter/PrintPostExporter.ms"

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
	ExportNodesToExport,


    /* properties */
    params = Dictionary #( #EXPORT_FORMAT,	"obj" )\
                        #( #EXPORT_SCALE,	1 )\
                        #( #SUBDIR_BY_NODE,	false )\
                        #( #FIX_POSITION,	false )\
                        #( #PROJECT_FILE_OPEN,	false )\
                        #( #ANIMATION,	false )\
                        #( #UNSMOOTH_VERTEX_COLOR,	false )\
                        #( #KEEP_EXPORTED,	false )\
                        #( #INNER_BLACK,	false )\
                        #( #OFFSET,	false )\
                        #( #EXPORTED_SUFFIX,	"" )\
                        #( #EXCLUDE,	"" )\
                        #( #OPEN_IN,	0 ),
                        --#( #LAYER_BY_OBJ,	false )\

	open_in_programs = #( #("C:/Program Files/CHITUBOX  V1.9.4/Chitubox.exe", "chitubox"), #("C:/Program Files/LycheeSlicer/LycheeSlicer.exe", "lys")),

	exported_paths = #(),

	anim_keys	= Dictionary #( #position, 0 ) #( #rotation, 0 ),

	fetch_state	= Dictionary #( #layer_manager_open, true ),
	
	vertex_colors_source	= Dictionary #STRING,

	fix_position_dummy = #(),

	success_message = "",
	
	offset = [0,0,0],

	offset_x_gap = 1.0,
	
	/* dependency */
	Exporter,
	PrintPostExporter,

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
			--LayerManager.closeDialog()

		this._setExporter()

		this._holdMaxState()

		current_time = currentTime.frame as integer
		
		end_time = if params[#ANIMATION] then animationRange.end.frame as integer else current_time

		export_keys = for export_key = current_time to end_time collect export_key 
		
		if params[#ANIMATION] and not queryBox ("EXPORT ANIMATION ?\n\n FRAMES: " + (amin export_keys) as string +" - "+ (amax export_keys) as string ) title:"EXPORT ANIMATION"  beep:false then
			 return false
			 --params[#ANIMATION] = false
		
		format "EXPORT_KEYS: %\n" export_keys
		
		this._fixExportPosition()
		
		keep_exported = params[#KEEP_EXPORTED] and queryBox ("Keep copies of exported objects ?") title:"PrintExporter_v"
		
		try(
			/* SAVE VERTEX COLORS */ 
			if keep_exported and this.params[#UNSMOOTH_VERTEX_COLOR] then
				for selected_node in this.ExportNodesToExport do
					this._saveVertexColors (selected_node)
			
			for frame in export_keys do 
			(
				format "frame: %\n" frame
				this._setTimeSlider (frame)
				
				/*------------------------------------------------------------------------------
					EXPORT NODES
				--------------------------------------------------------------------------------*/
				for selected_node in this.ExportNodesToExport do
				(
					export_node = if not keep_exported then selected_node else this._cloneExportObjects selected_node offset_x:this.params[#OFFSET] frame:frame
					
					this._exportNode (export_node) --frame:frame --offset_x:this.params[#OFFSET] frame:frame keep_exported:keep_exported
					
					if keep_exported then
					(
						--PrintPostExporter = PrintPostExporter_v exported_objects:exported_objects filename:filename
						PrintPostExporter = PrintPostExporter_v exported_objects:( export_node.getAllChildren() )
						--PrintPostExporter = PrintPostExporter_v()
					
						PrintPostExporter.moveToLayer export_node.text
					
					--	/* RENAME OBJECTS BY EXPORT FILENAME */ 
					--	for i = 1 to source_objects.count do
					--	(
					--		convertTo exported_objects[i] PolyMeshObject
					--		
					--		PrintPostExporter.exported_object = exported_objects[i]
					--		PrintPostExporter.source_object   = source_objects[i]
					--
					--		/* RENAME EXPORTED COPY */ 
					--		PrintPostExporter.renameObject (this._getFrameSuffix(frame)) params[#EXPORTED_SUFFIX]
					--		
					--		--/* ADD SUFFIX */ 
					--		--PrintPostExporter.addSuffix(params[#EXPORTED_SUFFIX])
					--		
					--		/* COPY VERTEX COLOR */ 
					--		if this.params[#UNSMOOTH_VERTEX_COLOR] then
					--			PrintPostExporter.copyVertexColors(vertex_colors_source[ (getHandleByAnim source_objects[i]) as string ])
					--		
					--		if this.params[#INNER_BLACK] then
					--			PrintPostExporter.setBlackVertexColorToInnerVerts()
					--	
					--		/* REPLACE OLD VERSION OF OBJECT */ 
					--		PrintPostExporter.replaceOldVersionOfCopy(ExportNodePlugin_offset)
					--		
					--		/* ADD TO LAYER */ 
					--		--if params[#LAYER_BY_OBJ] then
					--			--PrintPostExporter.moveToLayer()
					--		
					--	)
					--			
					--	/* DELETE EXCLUDED OBJECTS */ 
					--	for i = 1 to export_copies.count where findItem exported_objects export_copies[i] == 0 do
					--		delete export_copies[i]
					--			
					)
				)
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
	function getExportFilePath ExportNode = --frame:undefined =
	(
		--format "\n"; print "ExporterSetup_v.getExportFilePath()"
	

		subdir = if this.params[#SUBDIR_BY_NODE] then "/"+ExportNode.name + "/" else "/"

		filename = ExportNode.name
		
		--if params[#ANIMATION] then
		--if frame != undefined then 
			--filename += "-" + (this._getFrameSuffix(frame))

		--format "FILENAME: %\n" filename
		filename += "." + this.params[#EXPORT_FORMAT]
		
		export_path =  (this._getExportDir(ExportNode.export_dir)) + subdir + filename


		( dotNetObject "System.Text.RegularExpressions.Regex" @"[\\/]+" ).Replace export_path "\\\\" -- return
	),


	private


	/*==============================================================================
	
			EXPORT NODE
	
	================================================================================*/
	function _exportNode ExportNode = --keep_exported:false offset_x:false =
    (
        format "\n"; print "PrintExporter_v._exportNode()"

		max create mode

		export_path = this.getExportFilePath(ExportNode) --frame:frame

		export_node_children = ExportNode.getAllChildren()
				
		select export_node_children
			
		/* ENABLE MODIFIERS */
		if this.params[#MESHSMOOTH] then
            for obj in export_node_children where ( _mod = obj.modifiers[ meshsmooth ]) != undefined do
                _mod.enabled = true

				
		/* EXPORTED OBJECTS */ 
		export_objects = this._excludeObjects(export_node_children)
		
		/*------------------------------------------------------------------------------
			EXPORT
		--------------------------------------------------------------------------------*/
		export_result = Exporter.export ( export_objects + this.fix_position_dummy ) (export_path)
		

		/* APPEND EXPORT PATH TO OTHER PATHS */
		if export_result != false then
			append this.exported_paths export_path
	),
	
	/** 
	  *	
	  */
	function _cloneExportObjects ExportNode  offset_x:false frame:undefined =
    (
        format "\n"; print "PrintExporter_v._cloneExportObjects()"
		--max create mode
		ExportNode_clone = undefined 
        --export_node_children = ExportNode.getAllChildren()
	
		/*------------------------------------------------------------------------------
			COPY OBJECTS TO EXPORT
		--------------------------------------------------------------------------------*/		
		offset = this._getOffsetByExportNodeWidth ExportNode frame

		/* COPY EVEN EXCLUDED OBJECTS because of keep hierarchy */ 
		export_clones = this._getCopyOfExportObjects(ExportNode) offset
		
		for export_clone in export_clones where classOf export_clone == ExportNodePlugin do
			ExportNode_clone = export_clone
			
			
		ExportNode_clone.text = ExportNode.text + "-" + this._getFrameSuffix frame
		
		ExportNode_clone --return
		
		
		--if frame != undefined then 
			--ExportNodePlugin_offset = this._moveToExportPosition(export_copies)(filename)(ExportNode)(frame)
		
		/* GET SOURCE OBJECTS OF EXPORTED OBJECTS */ 
		
		/* EXPORTED OBJECTS */ 
		--export_objects = this._excludeObjects(export_clones)
		
		--exported_objects = this._excludeObjects(export_copies)
		
		/*------------------------------------------------------------------------------
			EXPORT
		--------------------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------------------
			DELETE OR RENAME EXPORTED OBJECT 
		--------------------------------------------------------------------------------*/
		--if keep_exported then
		--(
		--	format "EXPORT_SOURCES.COUNT: %\n" source_objects.count
		--	PrintPostExporter = PrintPostExporter_v exported_objects:exported_objects filename:filename
		--
		--	/* RENAME OBJECTS BY EXPORT FILENAME */ 
		--	for i = 1 to source_objects.count do
		--	(
		--		convertTo exported_objects[i] PolyMeshObject
		--		
		--		PrintPostExporter.exported_object = exported_objects[i]
		--		PrintPostExporter.source_object   = source_objects[i]
		--
		--		/* RENAME EXPORTED COPY */ 
		--		PrintPostExporter.renameObject (this._getFrameSuffix(frame)) params[#EXPORTED_SUFFIX]
		--		
		--		--/* ADD SUFFIX */ 
		--		--PrintPostExporter.addSuffix(params[#EXPORTED_SUFFIX])
		--		
		--		/* COPY VERTEX COLOR */ 
		--		if this.params[#UNSMOOTH_VERTEX_COLOR] then
		--			PrintPostExporter.copyVertexColors(vertex_colors_source[ (getHandleByAnim source_objects[i]) as string ])
		--		
		--		if this.params[#INNER_BLACK] then
		--			PrintPostExporter.setBlackVertexColorToInnerVerts()
		--	
		--		/* REPLACE OLD VERSION OF OBJECT */ 
		--		PrintPostExporter.replaceOldVersionOfCopy(ExportNodePlugin_offset)
		--		
		--		/* ADD TO LAYER */ 
		--		--if params[#LAYER_BY_OBJ] then
		--			--PrintPostExporter.moveToLayer()
		--		
		--	)
		--			
		--	/* DELETE EXCLUDED OBJECTS */ 
		--	for i = 1 to export_copies.count where findItem exported_objects export_copies[i] == 0 do
		--		delete export_copies[i]
		--			
		--)
		--else
		--	delete export_copies
		

	),
	
	/** Get copy of export objects
	 */
	function _getCopyOfExportObjects ExportNode offset =
	(
		--format "\n"; print "PrintExporter_v._getCopyOfExportObjects()"

		source_objects = #()
		export_clones = #()
		
		
		/* CLONE NODES FOR EXPORT */ 
		maxOps.CloneNodes ExportNode expandHierarchy:true actualNodeList:&source_objects newNodes:&export_clones offset:offset
    

		/* COLLAPSE CLONES */ 
		for obj in export_clones  where classOf obj != ExportNodePlugin do
			convertTo obj PolyMeshObject
		
        this._removeAnimationFromExportedObjects(export_clones)
		
		for i = 1 to export_clones.count do
		(
			export_clones[i].name = source_objects[i].name
			
			--export_clones[i].parent = undefined
			
			--export_clones[i].name = export_node_children[i].name + "-EXPORTING"
			--export_clones[i].name = "export_copy"
		)
		
		export_clones --return
	),
	
    /** Move to export position
     */
    function _moveToExportPosition export_clones filename ExportNode frame =
	(
		format "\n"; print "PrintExporter_v._moveToExportPosition()"
		ExportNodePlugin_offset = undefined
		
		if ( same_name_objects = getNodeByName filename all:true ).count > 0 then
        (
            for same_name_object in same_name_objects where classOf same_name_object == ExportNodePlugin do
                ExportNodePlugin_offset = same_name_object
			format "ExportNodePlugin_offset: %\n" ExportNodePlugin_offset
		)
		
		if ExportNodePlugin_offset == undefined then 
			ExportNodePlugin_offset = ExportNodePlugin name:filename text:filename export_dir:ExportNode.export_dir size:ExportNode.size pos:(this._getOffsetByExportNodeWidth(ExportNode)(frame))
		
		/* OFFSET OBJECTS BY FRAME NUMBER */ 
		--move export_clones this.offset		
		move export_clones ExportNodePlugin_offset.pos		
		
	
		for export_clone in export_clones do
			export_clone.parent = ExportNodePlugin_offset

		ExportNodePlugin_offset --return
	),
	
	/** Get export node width
	 */
	function _getOffsetByExportNodeWidth ExportNode frame =
	(
		format "\n"; print "PrintExporter_v._getOffsetByExportNodeWidth()"
		format "frame: %\n" frame
		offset = [0,0,0]
		
		if frame != undefined and frame > 0 then 
		(
			bbox	= nodeGetBoundingBox ExportNode ( ExportNode.transform ) -- return array of min\max positions E.G.: bbox[1].z | bbox[2].z
			
			node_size = bbox[2].x - bbox[1].x 
			
			offset.x = node_size * frame
		)
		
		offset --return
	),
	
	/** Get frame suffix
	 */
	function _getFrameSuffix frame =
	(
		--format "\n"; print "PrintExporter_v._getFrameSuffix()"
		if frame != undefined then
		(
			if ( frame_string = (frame as integer ) as string ).count < 2 then
			   "0" + frame_string
		   else
			   frame_string
		)
		else
			""
	),

	/** Get offset by bbounding box size of obejct
	  * 
	  * IMPORTANT:
			BUNGINGBOX CAN CHANGE IF MESHMOOTH MODIFIER IS USED.
			So BoungingBox is get from baseobejcts to keep consistent exports.
	  * 
	 */
	function _getOffsetByBaseobject export_objects =
	(
		--format "\n"; print "PrintExporter_v._getOffsetByBaseobject()"
		
		/** Get temp meshes
		 */
		function getCopyOfBaseobjectMesh obj =
		(
			--format "\n"; print "PrintExporter_v.getTempMeshes()"
			source_base_object = obj.baseObject
			
			-- Check if the base object has a mesh property (e.g., it's a geometry object)
			if isProperty source_base_object #mesh then
			(
				-- 3. Create a new Editable_Mesh node
				local new_node = Editable_Mesh()
				
				-- 4. Copy the mesh from the source base object to the new node's mesh
				new_node.mesh = source_base_object.mesh
				
				-- Optional: Name the new node based on the source node
				new_node.name = uniquename (obj.name + "_basecopy")
				
				-- Optional: Copy the source node's transform to the new node
				new_node.transform = obj.transform
				
			)
			
			new_node --return
		)
		
		/** Get bbox of multiple objects
		 */
		function getBboxOfMultipleObjects objs =
		(
			--format "\n"; print "PrintExporter_v.getBboxOfMultip[leObjects()"
			--format "\n"; print "PrintExporter_v.getBboxOfMultip[leObjects()"
			min_x =	min_y = min_z = 1e9
			
			max_x = max_y = max_z = -1e9
			
			for obj in objs do
			(
				bbox	= nodeGetBoundingBox obj ( Matrix3 1) -- return array of min\max positions E.G.: bbox[1].z | bbox[2].z

				if bbox[1].x < min_x then min_x = bbox[1].x
				if bbox[1].y < min_y then min_y = bbox[1].y
                if bbox[1].z < min_z then min_z = bbox[1].z

				if bbox[2].x > max_x then max_x = bbox[2].x
				if bbox[2].y > max_y then max_y = bbox[2].y	
				if bbox[2].z > max_z then max_z = bbox[2].z	
				
			)
			
			#( [ min_x, min_y, min_z ], [ max_x, max_y, max_z ]   ) --return
		)
		
		temp_meshes = for obj in export_objects collect getCopyOfBaseobjectMesh obj
			
		bbox = getBboxOfMultipleObjects(temp_meshes)

		delete temp_meshes
		
		abs(bbox[2].x - bbox[1].x) --return
	),
	
	/** Save vertex colors
	 */
	function _saveVertexColors ExportNode =
	(
		--format "\n"; print "PrintExporter_v._saveVertexColors()"
		--export_sources_get_colors = #()
		
		export_node_children = ExportNode.getAllChildren()
		
		source_objects = this._excludeObjects(export_node_children)
		
		maxOps.CloneNodes source_objects expandHierarchy:true newNodes:&export_sources_get_colors

		--for export_source_get_colors in export_sources_get_colors do
		for i = 1 to source_objects.count do
		(
			get_color = export_sources_get_colors[i]
			get_color.name = "get_color"

			pointer = getHandleByAnim source_objects[i]
			
			/* COLLAPSE SMOOTH */ 
			verts_by_colors_wtf = smoothAndKeepVertexColors get_color quiet:true
			format "VERTS_BY_COLORS_WTF: %\n" verts_by_colors_wtf

			if verts_by_colors_wtf != false then
				vertex_colors_source[ pointer as string ] = verts_by_colors_wtf
		)

		delete export_sources_get_colors
	),
	
	/** Remove animation keys
	 */
	function _removeAnimationFromExportedObjects export_clones =
	(
		--format "\n"; print "PrintExporter_v._removeAnimationFromExportedObjects()"
		for obj in export_clones do
		(
			-- transform controllers: position, rotation, scale
			track_list = #(obj.position.controller, obj.rotation.controller, obj.scale.controller)
	
			for ctrl in track_list do
				deleteKeys track_list #allKeys
		)
	),
	

	/** Set exporter
	 */
	function _setExporter =
	(
		--format "\n"; prOptionsint "PrintExporter_v._setExporter()"
		this.Exporter = case this.params[#EXPORT_FORMAT] of
		(
			"obj":  ExporterOBJ_v(#Print)
			"stl":	ExporterSTL_v()
		)

		this.Exporter.setPresetFile("print")

		this.Exporter.setExportScale(this.params[#EXPORT_SCALE])
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
			node_groups = makeUniqueArray( for _node in this.ExportNodesToExport where _node.parent != undefined and isGroupHead _node.parent collect _node.parent)

			if node_groups.count > 0 then
			(
				extension = this.open_in_programs[this.params[#OPEN_IN]][2]

				final_file = (this._getExportDir(this.ExportNodesToExport[1].export_dir)) + "\\" + node_groups[1].name + "." + extension

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

		for ExportNode in this.ExportNodesToExport where (node_anim_keys = ExportNode.getAnimationKeys(controller_type) ).count > 0 do
			if node_anim_keys[node_anim_keys.count] > last_keyframe then  -- get last key if higher
				last_keyframe = node_anim_keys[node_anim_keys.count]

		last_keyframe --return
	),


	/** Export dir consist of CURRENT SCENE PATH + RELATIVE PATH of ExportNode.export_dir
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

		format "\n\n----- EXPORTED FILES: -----\n%\n\n" success_message
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
