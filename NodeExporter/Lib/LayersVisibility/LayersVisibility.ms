struct LayersVisibility_v
(
	SceneExplorerInstance,
	
	/*------------------------------------------------------------------------------
		MAIN FUNCTION
	--------------------------------------------------------------------------------*/

	/** Hide all layers except selected
	  *
	  */
	function showOnly _objects ISOLATE:false =
	(
		format "\n"; print "LayersManager_v.hideUnselected()"

		--_selection = selection
		
		layers_selected = this.getLayersByObjects(_objects)
		layers_in_tree = this.getLayersTree(layers_selected)

		top_layers =  this.getTopLayers(this.getAllLayers())

		with redraw off
		(
			this.setVisibility (layers_selected) (true)
	
			this._setVisibilityOthers (top_layers)(layers_selected)(layers_in_tree) STATE:false ISOLATE:ISOLATE
			
			for obj in objects where not obj.isHidden and not obj.isSelected do 
				obj.isHidden = true
				
			for obj in _objects do 
				obj.isHidden = false
			
		)
		
		redrawViews()
	),

	/*------------------------------------------------------------------------------
		GET LAYERS
	--------------------------------------------------------------------------------*/

	--/** Get current
	--  *
	--  */
	--function getCurrent =
	--(
	--	for layer in this.getAllLayers() where layer.current do return layer
	--),

	/** Get layers
	  *
	  */
	function getLayers layers =
	(
		if classOf layers != Array then layers = #(layers)

		for layer in layers where (layer = this._getLayer(layer)) != undefined collect layer
	),

	--/** Get selected layers
	--  *  1) By selection in layer manager
	--  *  2) By current objects selection if nothing is selected in layer manager
	--  *
	--  * Return array of layers
	-- */
	--function getSelectedLayers _objects =
	--(
	--	format "\n"; print "LayersManager_v.getSelectedLayers()"
	--	--if  (selected_layers = this.getSelectedByManager()).count == 0 then
	--		selected_layers = this.getLayersByObjects( _objects )
	--	--selected_layers --return
	--),

	--/** Get selected layers from Layers manager
	-- */
	--function getSelectedByManager =
	--(
	--	format "\n"; print "LayersManager_v.getSelectedByManager()"
	--	selected_layers = #()
	--	
	--	if LayerManager.isDialogOpen() and SceneExplorerInstance != undefined then
	--		for layer in SceneExplorerInstance.SelectedItems() where superClassOf layer == Base_Layer collect this._getLayer(layer) --return
	--	
	--	selected_layers --return
	--),

	/** Get layers by objects
	  *
	  */
	function getLayersByObjects _objects =
	(
		format "\n"; print "LayersManager_v.getLayersByObjects()"
		layers_by_obj	= #()

		for obj in _objects do
			appendIfUnique layers_by_obj obj.layer
			
		layers_by_obj --return
	),

	/** Get all layers
	  *
	  */
	function getAllLayers =
	(
		for i = 0 to LayerManager.count - 1 collect LayerManager.getLayer i --return
	),

	/** Get tree of layers including parents
	  *
	  */
	function getLayersTree layers =
	(
		layers = this.getLayers(layers)

		layers_in_tree = deepCopy layers

		for curent_layer in layers do
			while curent_layer.getParent() != undefined do
				appendIfUnique layers_in_tree (curent_layer = curent_layer.getParent())

		layers_in_tree --return
	),

	/** Get top layers (no parent)
	  *
	  */
	function getTopLayers layers =
	(
		layers = 	if layers == #ALL then this.getAllLayers() else this.getLayers(layers)

		for layer in this.getLayersTree(layers) where layer.getParent() == undefined collect layer
	),

	/*------------------------------------------------------------------------------
		VISIBILITY
	--------------------------------------------------------------------------------*/

	/** Set visibility for layers and parents recursively
	  *
	  */
	function setVisibility layers state =
	(
		layers = this.getLayers(layers)

		for layer in layers do
		(
			layer.on = state

			if state == true and (parent_layer = layer.getParent()) != undefined then
				this.setVisibility(parent_layer)(true)
		)
	),

	/** Recursive hide/show layers except those selected or in tree
	  *
	  */
	function _setVisibilityOthers layers not_toggle layers_in_tree STATE:true ISOLATE:false =
	(
		for layer in layers do
			if (findItem layers_in_tree layer) > 0 then
			(
				if ISOLATE then
					for obj in this.getObjectsInLayers(layer) where findItem not_toggle layer == 0 do
						obj.isHidden = not STATE


				this._setVisibilityOthers (this.getChildren(layer))(not_toggle)(layers_in_tree) STATE:STATE ISOLATE:ISOLATE
			)
			else
				layer.on = STATE
	),

	/** Get objects in layers
	  *
	  */
	function getObjectsInLayers layers =
	(
		layers = this.getLayers(layers)

		layers_nodes = #()

		for layer in layers do
		(
			layer.nodes &layer_nodes

			layers_nodes += layer_nodes
		)

		layers_nodes --return
	),

	/** Get children layers
	  *
	  */
	function getChildren layers =
	(
		layers	= this.getLayers(layers)

		children = #()

		if layers.count > 0 then
			for layer in layers do
				children = join children ( for i = 1 to layer.getNumChildren() collect layer.getChild i )

		children --return
	),


	--/** Get selected or current
	--  *
	--  */
	--function getSelectedOrCurrent =
	--(
	--	format "\n"; print "LayersManager_v.getSelectedOrCurrent()"
	--	if  (selected_layers = this.getSelectedLayers()).count == 0 then
	--		selected_layers = #(this.getCurrent())
	--
	--	selected_layers --return
	--),

	/*------------------------------------------------------------------------------
		PRIVATE
	--------------------------------------------------------------------------------*/

	/** Private: Get layer from unknown input
	  *
	  */
	function _getLayer layer =
	(
		if isKindOf layer Layer then return layer
		if isKindOf layer string then return LayerManager.getLayerFromName layer
		if isKindOf layer Integer then return LayerManager.getLayer layer
		undefined -- return
	),

	/*------------------------------------------------------------------------------
		on create
	--------------------------------------------------------------------------------*/

	on create do
	(
		--SceneExplorerInstance = dotNetObject "Autodesk.Max.Wrappers.LayerSceneExplorer"
		SceneExplorerInstance = SceneExplorerManager.GetActiveExplorer()
	)
)
