/** Print post exporter
 */
struct PrintPostExporter_v
(
	/* construct */
	exported_objects,
	
	exported_object,
	source_object,
	

	/* required */
	

	/* properties */
	filename,
	--basename,
	--layer_by_obj,

	/* private */
	/* dependency */
	/* reference */
	/* inhered */

	/** Rename object
	 */
	function renameObject frame_suffix suffix =
	(
		--format "\n"; print "PrintPostExporter_v.renameObject()"
		
		--exported_object.name = this.basename = source_object.name  + "-" + filename
		exported_object.name = source_object.name
		
		if frame_suffix != "" then
			exported_object.name += "-" + frame_suffix
		
		if suffix != "" then
			exported_object.name += "-" + suffix
	),
	
	--/** Rename Objects
	-- */
	--function addSuffix  suffix =
	--(
	--	--format "\n"; print "PrintPostExporter_v.addSuffix()"
	--	if suffix != "" then
	--		exported_object.name += "-" + suffix
	--),
	
	/** Replace old copy
	 */
	function replaceOldVersionOfCopy ExportNodePlugin_offset =
	(
		--format "\n"; print "PrintPostExporter_v.replaceOldVersionOfCopy()"
		old_version = undefined 
	
		if (old_version = this._getOldVersion() ) == undefined then
		(
			this.moveToLayer()
			
			--/* RELINK PARENT */ 
			--exported_object.parent = old_version.parent
			--
			--
			--/* COPY USER PROPERTIES TO NEW COPY */ 
			--if (user_prop_buffer = getUserPropBuffer old_version) != undefined then
			--	setUserPropBuffer exported_object user_prop_buffer
			--
			--
			--for child in old_version.children do 
			--	child.parent = exported_object
			--
			--/* DELETE OLD COPY */ 
			--delete old_version
		)
		else
		(
			--old_version.baseobject = exported_object.baseobject 	
			
			delete old_version
		)
		
	),

	/** Get old version
	 */
	function _getOldVersion =
	(
		--format "\n"; print "PrintPostExporter_v._getOldVersion()"
		old_version = undefined 

		if ( same_name_objects = getNodeByName exported_object.name all:true ).count > 1 then
		(
				
			/* SERACH FOR OLD VERSION OF OBJECT */ 
			for same_name_object in same_name_objects while old_version == undefined where same_name_object != exported_object do 
				old_version = same_name_object
		)
		
		old_version --return	
	),
	
	/** Move to layer
	 */
	function moveToLayer layer_name =
	(
		format "\n"; print "PrintPostExporter_v.moveToLayer()"
		top_layer_name =  "--- EXPORTED ---"
		
		exported_layer = LayerManager.getLayerFromName layer_name
		--format "layer_of_obj: %\n" layer_of_obj
		
		if exported_layer == undefined then
		(
			
			if (parent_layer = LayerManager.getLayerFromName top_layer_name) == undefined then
				parent_layer = LayerManager.newLayerFromName top_layer_name
				
				
			exported_layer = LayerManager.newLayerFromName layer_name
			
			exported_layer.setParent parent_layer
		)
		
		/* ADD NODE TO LAYER */ 
		exported_layer.addnodes  exported_objects
		
	),
	
	/** Copy vertex colors
	 */
	function copyVertexColors verts_by_colors =
	(
		format "\n"; print "PrintPostExporter_v.copyVertexColors()"
		format "VERTS_BY_COLORS: %\n" verts_by_colors
		--any_color_exists
		
		--if not (verts_by_colors.keys.count == 1 and verts_by_colors.keys[1] == white as string) then
		if verts_by_colors != undefined then 
			for vert_color in verts_by_colors.keys where not verts_by_colors[vert_color].isEmpty do
				polyop.setVertColor exported_object.baseobject 0 verts_by_colors[vert_color]  ( execute vert_color )
	),
	
	/** Set black vertex color to inner verts
	 */
	function setBlackVertexColorToInnerVerts =
	(
		format "\n"; print "PrintPostExporter_v.setBlackVertexColorToInnerVerts()"
		
		black_verts = polyop.getVertsByColor exported_object black 0.0 0.0 0.0
		
		if not black_verts.isEmpty then
		(
			format "black_verts: %\n" black_verts
			format "-black_verts: %\n" -black_verts
			inner_verts = getInternalVertsOfObject exported_object exported_objects verts:-black_verts
			format "inner_verts: %\n" inner_verts
			if not inner_verts.isEmpty then
				polyop.setVertColor exported_object.baseobject 0 inner_verts black
		)

	),

	private


	/**
	 */
	on create do
	(
		--format "\n"; print "PrintPostExporter.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)
	

)
