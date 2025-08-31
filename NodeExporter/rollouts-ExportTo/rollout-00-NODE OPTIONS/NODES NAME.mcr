--filein( getFilenamePath(getSourceFileName()) + "/Lib/ObjectRenamer/ObjectRenamer.ms" )	--"./Lib/ObjectRenamer/ObjectRenamer.ms"

/*------------------------------------------------------------------------------
	EDIT TEXT
--------------------------------------------------------------------------------*/

/**  SEARCH EDIT TEXT FIELD
  */
macroscript selection_edit_search_in_names
category:	"Selection"
buttonText:	"[search in name]"
tooltip:	"Search text in selection names"
icon:	"control:editText|across:3"
--icon:"offset:[-32,16]"											 -- BUG: offset does not work in groupsbox
(
	--format "EventFired	= % \n" EventFired
	--search_text = ROLLOUT_selection.search_in_name.text

	--format "search_text	= % \n" search_text
)

/**  REPlACE EDIT TEXT FIELD
  */
macroscript selection_edit_replace_in_names
category:	"Selection"
buttonText:	"[replace in name]"
tooltip:	"Replace text in selection names"
icon:	"control:editText|across:3"
(
	--format "EventFired	= % \n" EventFired

)

/*------------------------------------------------------------------------------
	BUTTON Search & Replace
--------------------------------------------------------------------------------*/

/**
  *
  */
macroscript selection_search_and_replace
category:	"Selection"
buttonText:	"Search & Replace"
tooltip:	"Regex Search & Replace in names of selection or all objects if nothing selected"
icon:	"across:3"
(
	on execute do
	(
		--format "EventFired	= % \n" EventFired
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-SELECTION\SEARCH AND REPLACE NAME.mcr"
		search_text  = ROLLOUT_node_options.ET_search_in_name.text
		replace_text = ROLLOUT_node_options.ET_replace_in_name.text

		selected_nodes = for obj in ( if selection.count > 0 then selection else objects ) where classOf obj == ExportNodePlugin collect obj

		if selected_nodes.count > 0 then
		(
			for export_node in selected_nodes do
				export_node.text = substituteString export_node.text search_text replace_text
	
			(NodeList_v()).refreshNodeList()
		)
	)
)
