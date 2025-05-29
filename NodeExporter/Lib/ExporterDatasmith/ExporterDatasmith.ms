filein( getFilenamePath(getSourceFileName()) + "/ExportChecker/ExportChecker.ms" )


/** Exporter datasmith
  *
  *
  * UNREAL ENGINE IMPORT HELP: https://docs.unrealengine.com/4.27/en-US/Basics/AssetsAndPackages/AutoReImport/
  */
struct ExporterDatasmith_v
(
	__construct = #( #ExportNodePlugins ),

	/* construct */
	ExportNodePlugins = #(),

	/* construct */
	/* dependency */
	/* reference */
	/* inhered */
	/* properties */

	/** Export
	  *
	  * @param	boolean	pre_export	if true then export
	 */
	function export pre_export:false =
	(
		GLOBAL_SELECTION_LAST_ENABLED = false

		ExportChecker = ExportChecker_v ExportNodePlugins: ExportNodePlugins

		ExportChecker.validateNodes()

		ExportChecker.analyzeGroups()

		holdMaxFile()

		if( ExportChecker.groups_to_attach.count > 0 ) then
			GroupToObjectBaker_v groups:ExportChecker.groups_to_attach

		node_name = ExportChecker.ExportNodePlugins[1].name

		try
		(
			/* EXPORT */
			for ExportNodePlugin in ExportChecker.ExportNodePlugins do
			(
				if pre_export == false then
					this._exportNode (ExportNodePlugin) (getUserProp ExportNodePlugin "export-dir")
				else
					this._preExportNode (ExportNodePlugin) (getUserProp ExportNodePlugin "export-dir")
			)
		)
		catch(
			messageBox "Export Failed" title:"Export Failed"  beep:true

			getCurrentException()
		)

		fetchMaxFile quiet:true

		print ("EXPORT OF " +node_name+ " SUCCESSFUL " + (getLocalTime())[5] as string + ":"+ (getLocalTime())[6] as string )

		GLOBAL_SELECTION_LAST_ENABLED = true
	),

	/** Select child nodes
	 */
	function selectChildNodes =
	(
		format "\n"; print "ExporterDatasmith_v.selectChildNodes()"

		all_children	= #()

		for ExportNodePlugin in ExportNodePlugins do
			all_children += this._getAllChildren(ExportNodePlugin)

		all_children --return
	),


	private


	/** Export
	 */
	function _exportNode ExportNodePlugin export_dir =
	(
		print("ExporterDatasmith_v._exportNode() " + ExportNodePlugin.name )

		all_children = (this._getAllChildren(ExportNodePlugin))

		for o in all_children where o.ishidden do
			o.ishidden = false

		select all_children

		DatasmithExport.IncludeTarget	= #SelectedObjects
		DatasmithExport.AnimatedTransforms	= #CurrentFrame

		DatasmithExport.Export (export_dir+"\\"+ExportNodePlugin.name+".udatasmith") true    -- set your own path and filename
	),

	/** Save Eported nodes as separated max files in export folder
	  *
	  *
	  *
	 */
	function _preExportNode ExportNodePlugin export_dir =
	(
		print("ExporterDatasmith_v._exportNode() " + ExportNodePlugin.name )

		select (this._getAllChildren(ExportNodePlugin))

		selection.isHidden = false

		--DatasmithExport.IncludeTarget	= #SelectedObjects
		--DatasmithExport.AnimatedTransforms	= #CurrentFrame
 		saveNodes selection (export_dir+"\\"+ExportNodePlugin.name+".max") quiet:true

	),

	/**  Get all nested children
	  */
	function _getAllChildren obj &arr:#() =
	(
		for child in obj.children do
		(
			append arr child

			this._getAllChildren child arr:arr
		)
		arr
	),

	/**
	 */
	on create do
	(
		--print("ExporterDatasmith_v.onCreate()")
		ConstructPropeties test:this
	)
)