--filein( getFilenamePath(getSourceFileName()) + "/../PrinterVolume/PrinterVolume.ms" )	-- "./../PrinterVolume/PrinterVolume.ms"

--filein( getFilenamePath(getSourceFileName()) + "/PrintPostExporter/PrintPostExporter.ms" )	--"./PrintPostExporter/PrintPostExporter.ms"

/** Print exporter
  *
  * Template files for new projects: -- "./../../Final-Files-Templates/"
  *
  * @param 2DMatrix open_in_programs #( #("C:\Path\to\program.exe", "project_file_extension") )
  *
  * HOW TO EXPORT OBJECTS ON EXACT POSITION AND ROTATION:
  * 		Dummy boxes are exported in corners of printer plate (this will keep objects on right position)
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
	PostExporter,

	/* store */ 	
	/* reference */
	/* inhered */

	
	/** Export
		
		- Get nodes and animation frames to export
		
		IF KEEP EXPORT and UNSMOOTH VERTEX COLORS:
			- Save vertex colors for each exported object if meshmooth exists
		
		- Set export frame
		
		
		1) PREPARE EXPORT FOR EACH NODE ON FRAME:
		---------------------------------------------------------------------------------------------------------------------------
			- get name of export node suffixed wtih current frame E.G.: "export-node" >>> "export-node-01"
			- get old export nodes and its chidren
			
			- IF OFFSET then find EXPORT POSITION by:
					A) position of old node
					B) offset position by frame and width of node on X axis
			
			
			- make clones of export node and children ( DO NOT OFFSET ON COPY )
			- reset names of clones
			- suffix object names by frame number 
			- collapse clones to editable poly
			- remove animation keys
			- move export node to export position
			
			- exclude and delete not exported objects from node
			- relink objects to node - fix hierarchy after exclude ( in case of any excluded objects is in hierarchy between objects and node )
		
		
		2) EXPORT ALL NODES ON FRAME
		---------------------------------------------------------------------------------------------------------------------------
			- Save path exported file
		
		
		3) POST EXPORT
		---------------------------------------------------------------------------------------------------------------------------
			IF #KEEP_EXPORTED:
				- move objects to layers ( use old exported layers or create new layers )
				- paste unsmoothed vertex colors from source objects
				- set inner verts to black vertex color
				- add exported suffix to object				
				- Inherit from old exported objects:
					A) user props
					B) children of objects ( 3D print suports )
					C) layer

			
	  
			IF NOT #KEEP_EXPORTED:
				- delete exported objects
	  
			- delete old clones
	 */
	function export =
	(
		format "\n"; print "PrintExporter_v.export()"
		format "\n-----------\nDICTIONARY:params:%\n" params; for data_pair in params do format "%:	%\n" data_pair.key data_pair.value
			
		this._setExporter()

		this._holdMaxState()

		current_time = currentTime.frame as integer
		
		end_time = if params[#ANIMATION] then animationRange.end.frame as integer else current_time

		export_keys = for export_key = current_time to end_time collect export_key 
		
		/* COMFIRM EXPORT ANIOMATION */ 
		if params[#ANIMATION] and not queryBox ("EXPORT ANIMATION ?\n\n FRAMES: " + (amin export_keys) as string +" - "+ (amax export_keys) as string ) title:"EXPORT ANIMATION"  beep:false then
			 return false
		
		
		/* COMFIRM KEEP EXPORTED OBJECTS */ 
		keep_exported = params[#KEEP_EXPORTED] and queryBox ("Keep copies of exported objects ?") title:"PrintExporter_v"
		
		
		/* CLOSE LAYER MANAGER BEFORE SELECTION */
		if LayerManager.isDialogOpen() then
			is_manager_open = LayerManager.closeDialog()
		
		/* FIX POSTIION OF EXPORT */ 
		this._fixExportPosition()
		
		
		try(
			/* SAVE VERTEX COLORS */ 
			if keep_exported and this.params[#UNSMOOTH_VERTEX_COLOR] then
				for export_node in this.ExportNodesToExport do
					this._saveVertexColors (export_node)
			
			/*------------------------------------------------------------------------------
				FOR EACH FRAME
			--------------------------------------------------------------------------------*/
			for frame in export_keys do 
			(
				ExportNodes_old  = #()
				ExportNodes_new = #()
				all_source_objects = #()
				all_exported_objects = #()
				excluded_objects_all = #()
				
				if export_keys.count == 1 then
					frame = undefined
				
				if frame != undefined then 
					sliderTime = frame

				/*==============================================================================
					PREPARE FOR EXPORT
				================================================================================*/
				for ExportNode in this.ExportNodesToExport do
				(
					/* STORE ALL SOURCE OBJECTS */ 
					all_source_objects += ExportNode.getAllChildren() 
					
					/* get name of export node suffixed wtih current frame E.G.: "export-node" >>> "export-node-01" */
					export_node_name = ExportNode.text + (this._getFrameSuffix frame)
					
					/* get old export nodes and its chidren */
					ExportNode_old = this._findExportNode(export_node_name)
					
					
					/* IF OFFSET then find EXPORT POSITION: */
					if params[#OFFSET] then
						export_pos = if ExportNode_old != undefined then ExportNode_old.pos else this._getOffsetByExportNodeWidth (ExportNode) (frame)

					/* MAKE CLONES OF EXPORT NODE AND CHILDREN ( DO NOT OFFSET ON COPY ) */
					ExportNode_new = this._cloneExportObjects ExportNode frame

					ExportNode_new.text = export_node_name
					
					export_clones = ExportNode_new.getAllChildren() 
					format "ExportNode_new: %\n" ExportNode_new
					all_exported_objects += export_clones

					/* move export node to export position */
					if export_pos != undefined then 
						ExportNode_new.pos = export_pos
					
					/* exclude and delete not exported objects from node */
					excluded_objects = this._getExcludeObjects(export_clones)
					
					excluded_objects_all += excluded_objects
										
					/* relink objects to node - fix hierarchy after exclude ( in case of any excluded objects is in hierarchy between objects and node ) */
					for export_clone in export_clones where isValidNode export_clone do
						export_clone.parent = ExportNode_new
					
					
					append ExportNodes_old ExportNode_old
					append ExportNodes_new ExportNode_new
					
				)
				
				/*==============================================================================
					EXPORT ALL NODES ON FRAME
				================================================================================*/
				for ExportNode in ExportNodes_new do
					this._exportNode (ExportNode) --frame:frame --offset_x:this.params[#OFFSET] frame:frame keep_exported:keep_exported
			
				
				/*==============================================================================
					POST EXPORT
				================================================================================*/
				if keep_exported then
				(
					for i = 1 to ExportNodes_new.count do
						if ( ExportNode_old = ExportNodes_old[i] ) != undefined then
						(
							ExportNode_new = ExportNodes_new[i]
	
							objects_old = ExportNode_old.getAllChildren()
							objects_new = ExportNode_new.getAllChildren()
							
							/*------------------------------------------------------------------------------
								EDIT EACH EXPORTED OBJECT
							--------------------------------------------------------------------------------*/
							for exported_object in objects_new do
							(
								source_pointer = getUserPropVal exported_object "EXPORT_SOURCE"
								
								source_obj = this._getSourceObjectByPointer (all_source_objects)(source_pointer)
								
								/*------------------------------------------------------------------------------
									INHERIT FROM SOURCE OBJECT
								--------------------------------------------------------------------------------*/
								
								/* PASTE UNSMOOTHED VERTEX COLORS */ 
								if this.params[#UNSMOOTH_VERTEX_COLOR] then
									this._pasteUnsmoothedVertexColors(exported_object)(vertex_colors_source[ source_pointer as string ])							
								
								
								/* add exported suffix to object */							
								if this.params[#EXPORTED_SUFFIX] != "" then
									exported_object.name += "-" + this.params[#EXPORTED_SUFFIX]
									
									
								/* SET INNER VERTS TO BLACK VERTEX COLOR */
								if this.params[#INNER_BLACK] then
									this._setBlackVertexColorToInnerVerts(exported_object)( all_exported_objects )		
								
									
								/*------------------------------------------------------------------------------
									INHERIT FROM OLD COPY
								--------------------------------------------------------------------------------*/
								
								if exported_object_old != undefined then
								(
									/* COPY USER PROPERTIES TO NEW COPY */ 
									if (user_prop_buffer = getUserPropBuffer exported_object_old) != undefined then
										setUserPropBuffer exported_object user_prop_buffer
									
									/* RELINK CHILDREN */ 
									for child in exported_object_old.children() do
										child.parent = exported_object
									
									/* ADD TO LAYER */ 
									exported_object_old.layer.addNode exported_object
								)
								else /* MOVE TO LAYER */ 
									this._moveToLayer exported_object ExportNode_new.name
							)
							
							/* DELETE OLD CLONES */
							delete (ExportNode_old.getAllChildren())
							
							delete ExportNode_old
						)
						
					delete excluded_objects_all
				)
				/*------------------------------------------------------------------------------
					DELETE EXPORTED COPIES
				--------------------------------------------------------------------------------*/
				else
				(
					
					for ExportNode in ExportNodes_new do
					(
						delete (ExportNode.getAllChildren())
						
						delete ExportNode
					)
				)
			)
			
			this._setSuccessMessage()

			this._openExportedFiles()

			delete this.fix_position_dummy

			sliderTime = current_time
		
			/* REOPEN LAYER MANAGER */
			if is_manager_open != undefined then
				LayerManager.editLayerByName ""
		
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

		export_objects = ExportNode.getAllChildren()
				
			
		/* ENABLE MODIFIERS */
		if this.params[#MESHSMOOTH] then
            for obj in export_objects where ( _mod = obj.modifiers[ meshsmooth ]) != undefined do
                _mod.enabled = true

				
		/* EXPORTED OBJECTS */ 
		export_objects = this._excludeObjects(export_objects)
		
		/*==============================================================================
			EXPORT
		================================================================================*/
		export_result = Exporter.export ( export_objects + this.fix_position_dummy ) (export_path)
		--format "FIX_POSITION_DUMMY: %\n" fix_position_dummy
		--export_result = Exporter.export ( export_objects  ) (export_path)
		

		/* APPEND EXPORT PATH TO OTHER PATHS */
		if export_result != false then
			append this.exported_paths export_path
	),
	
	/** Get copy of export objects
	  
		• reset names of clones
		• suffix object names by frame number 
		• collapse clones to editable poly
		• remove animation keys
		
		@return copy of export node
	 */
	function _cloneExportObjects ExportNode frame =
	(
		--format "\n"; print "PrintExporter_v._cloneExportObjects()"
		/** Get old ecport node
		 */
		function getExportNode objs =
		(
			found_node = undefined
			
			for obj in objs while found_node == undefined where classOf obj == ExportNodePlugin do
				found_node = obj
			
			found_node --return
		)
		
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
		)
	
		source_objects = #()
		export_clones = #()
		
		/* CLONE NODES FOR EXPORT */ 
		maxOps.CloneNodes ExportNode expandHierarchy:true actualNodeList:&source_objects newNodes:&export_clones --offset:offset
    

		/* COLLAPSE CLONES */ 
		for obj in export_clones  where classOf obj != ExportNodePlugin do
			convertTo obj PolyMeshObject

		/* ADJUST CLONES */ 
		for i = 1 to export_clones.count do
		(
			/* RENAME OBJECTS */ 
			export_clones[i].name = source_objects[i].name + (this._getFrameSuffix frame)
			
			/* SAVE SOURCE OBJECT POINTER TO USER OF OBJECT COPY */ 
			setUserPropVal export_clones[i] "EXPORT_SOURCE" ( getHandleByAnim source_objects[i] ) --asString:true
		)
		
		/* REMOVE ANIMATION KEYS */ 
		_removeAnimationFromExportedObjects(export_clones)

		getExportNode (export_clones) --return
	),
	
	/** Find export node in scene
	 */
	function _findExportNode export_node_name search_in:shapes =
	(
		--format "\n"; print "PrintExporter_v._findExportNode()"
		found_node = undefined
		
		for obj in search_in while found_node == undefined where classOf obj == ExportNodePlugin and obj.name == export_node_name do
			found_node = obj
		
		found_node --return
	),
	
	/** Paste unsmoothed vertex colors
	 */
	function _pasteUnsmoothedVertexColors exported_object verts_by_colors =
	(
		format "\n"; print "PrintPostExporter_v._pasteUnsmoothedVertexColors()"
		format "VERTS_BY_COLORS: %\n" verts_by_colors
		--any_color_exists
		
		--if not (verts_by_colors.keys.count == 1 and verts_by_colors.keys[1] == white as string) then
		if verts_by_colors != undefined then 
			for vert_color in verts_by_colors.keys where not verts_by_colors[vert_color].isEmpty do
				polyop.setVertColor exported_object.baseobject 0 verts_by_colors[vert_color]  ( execute vert_color )
	),
	
	/** Set black vertex color to inner verts
	 */
	function _setBlackVertexColorToInnerVerts obj masking_objects =
	(
		format "\n"; print "PrintPostExporter_v._setBlackVertexColorToInnerVerts()"
		format "obj: %\n" obj
		format "masking_objects: %\n" masking_objects
		black_verts = #{}
		
		/* TEST IF VERTEX COLORS ARE SUPPORTED */ 
		has_vertex_color_map_channel = polyop.getMapSupport obj 0

		/* GET BLAVK VERTS */ 
		if has_vertex_color_map_channel then
			black_verts = polyop.getVertsByColor obj black 0.0 0.0 0.0
		
		/* GET IINER VERTS */ 
		inner_verts = getInternalVertsOfObject obj masking_objects verts:-black_verts
		
		/* SET INNER VERTS AS BLACK */ 
		if not inner_verts.isEmpty then
		(
			/* ENABLE VERTEX COLORS */ 
			if not has_vertex_color_map_channel then
				polyop.setMapSupport obj 0 true
			
			/* SET VERTEX COLOR */ 
			polyop.setVertColor obj.baseobject 0 inner_verts black
		)
	),
	
	
	/** Move to layer
	 */
	function _moveToLayer exported_object layer_name =
	(
		format "\n"; print "PrintPostExporter_v._moveToLayer()"
		top_layer_name =  "--- EXPORTED ---"
		
		/* GET LAYER */ 
		exported_layer = LayerManager.getLayerFromName layer_name
		
		/* CREATE LAYER */ 
		if exported_layer == undefined then
		(
			if (parent_layer = LayerManager.getLayerFromName top_layer_name) == undefined then
				parent_layer = LayerManager.newLayerFromName top_layer_name
				
				
			exported_layer = LayerManager.newLayerFromName layer_name
			
			exported_layer.setParent parent_layer
		)
		
		/* ADD NODE TO LAYER */ 
		exported_layer.addnode  exported_object
	),
	
	/** Get export node width
	 */
	function _getOffsetByExportNodeWidth ExportNode frame =
	(
		format "\n"; print "PrintExporter_v._getOffsetByExportNodeWidth()"
		format "frame: %\n" frame
		--offset = [0,0,0]
		offset = ExportNode.pos
		
		if frame != undefined and frame > 0 then 
		(
			bbox	= nodeGetBoundingBox ExportNode ( ExportNode.transform ) -- return array of min\max positions E.G.: bbox[1].z | bbox[2].z
			
			node_size = bbox[2].x - bbox[1].x 
			
			offset.x = node_size * frame
		)
		
		offset --return
	),
	
	/** Get source object by pointer
	 */
	function _getSourceObjectByPointer objs pointer =
	(
		--format "\n"; print "PrintExporter_v.getSourceObjectByPointer()"
		source_obj = undefined

		for obj in objs while source_obj == undefined where getUserPropVal obj "EXPORT_SOURCE" == pointer do 
			source_obj = obj

		source_obj --return
	),
	
	/** Get frame suffix
	 */
	function _getFrameSuffix frame =
	(
		--format "\n"; print "PrintExporter_v._getFrameSuffix()"
		if frame != undefined then
		(
			if ( frame_string = (frame as integer ) as string ).count < 2 then
			   "-0" + frame_string
		   else
			   "-"+frame_string
		)
		else
			""
	),
	
	/** Save vertex colors
	 */
	function _saveVertexColors ExportNode =
	(
		--format "\n"; print "PrintExporter_v._saveVertexColors()"
		--export_sources_get_colors = #()
		export_node_children = ExportNode.getAllChildren()
		
		source_objects = this._excludeObjects(export_node_children)
		format "source_objects: %\n" source_objects
		format "source_objects.count: %\n" source_objects.count
		maxOps.CloneNodes source_objects expandHierarchy:true newNodes:&export_sources_get_colors


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

		format "vertex_colors_source.keys: %\n" vertex_colors_source.keys
		
		delete export_sources_get_colors
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

		--sliderTime = this._getLastAnimKey()
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


	/** Export dir consist of CURRENT SCENE PATH + RELATIVE PATH of ExportNode.export_dir
	*
	*/
	function _getExportDir node_export_dir =
	(
		maxFilePath + (trimLeft node_export_dir ".\\")
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
		excluded_objects = this._getExcludeObjects (export_objects) 
		
		for obj in export_objects where findItem excluded_objects obj == 0 collect obj
	),
	
	/** Exclude obejcts matching name
	 */
	function _getExcludeObjects export_objects =
	(
		--format "\n"; print "PrintExporter_v.excludeObejcts()"
		
		/** Matching name
		 */
		function matchingName _string pattern = (( dotNetClass "System.Text.RegularExpressions.RegEx" ).match _string pattern ( dotNetClass "System.Text.RegularExpressions.RegexOptions" ).IgnoreCase ).success

		/* EXCLUDE NON GEOMTERY OBJECTS -- SHpaes, helpers etc. */ 
		excluded_objects = for obj in export_objects \
			where not ( superClassOf obj == GeometryClass or classOf obj == ExportNodePlugin )\
				collect obj

		
		/* EXCLUDE BY OJECT NAME */ 
		if ( params[#EXCLUDE] ) != "" then
			for obj in export_objects where matchingName obj.name (".*("+params[#EXCLUDE]+").*") do
				append excluded_objects  obj

		excluded_objects --return
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
