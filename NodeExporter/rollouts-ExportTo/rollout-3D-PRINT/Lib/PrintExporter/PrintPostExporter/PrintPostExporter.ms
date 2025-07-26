/** Print post exporter
 */
struct PrintPostExporter_v
(
	/* construct */
	source_object,
	exported_object,
	

	/* required */
	

	/* properties */
	basename,
	--layer_by_obj,

	/* private */
	/* dependency */
	/* reference */
	/* inhered */

	/** Rename Objects
	 */
	function renameObjects filename suffix =
	(
		
		--format "\n"; print "PrintPostExporter_v.addSuffix()"
		if suffix != "" then
			suffix = "-" + suffix
		
		this.basename = source_object.name  + "-" + filename
		
		exported_object.name = basename + suffix
		
	),
	
	/** Move to layer
	 */
	function moveToLayer =
	(
		--format "\n"; print "PrintPostExporter_v.moveToLayer()"
		layer_of_obj = LayerManager.getLayerFromName basename
		--format "layer_of_obj: %\n" layer_of_obj
		
		if layer_of_obj == undefined then
		(
			LayerManager.newLayerFromName basename
				
			layer_of_obj = LayerManager.getLayerFromName basename
			
			layer_of_obj.setParent source_object.layer
		)
		
		layer_of_obj.addNode exported_object
		
	),
	
	/** Copy vertex colors
	 */
	function copyVertexColors verts_by_colors =
	(
		--format "\n"; print "PrintPostExporter_v.copyVertexColors()"
		
		for vertex_color in verts_by_colors.keys do
			polyop.setVertColor exported_object.baseobject 0 verts_by_colors[vertex_color]  ( execute vertex_color )
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
