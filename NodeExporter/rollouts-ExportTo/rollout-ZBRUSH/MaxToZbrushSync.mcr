filein( getFilenamePath(getSourceFileName()) + "/Lib/MaxToZbrushSync.ms" )	--"./Lib/MaxToZbrushSync.ms"
/**
  *
  *
 */
macroscript	_3DsMaxSync_to_zbrush
category:	"_3DsMaxSync"
buttontext:	"Max > ZBrush"
toolTip:	""
icon:	"Across:2|width:190|height:48"
--icon:	"Groupbox:Nodes"
--icon:	"control:checkbutton"
(
	/* IMPORT ZBRUSH PLUGIN */
-- 	filein @"C:\GoogleDrive\ProgramsData\CG\ZBrush\Plugins\INSTALLED\MaxZbrushSync\3DsMax\Lib\MaxToZbrushSync.ms" --"./../../../../../../../../../../../../../../../GoogleDrive/ProgramsData/CG/ZBrush/Plugins/INSTALLED/MaxZbrushSync/3DsMax/Lib/MaxToZbrushSync.ms"

	on execute do
	(
		--SEARCH FOR THIS		
		--filein( getFilenamePath(getSourceFileName()) + "/../scripts/MAXSCRIPT-NodeExporter/NodeExporter/rollouts-ExportTo/rollout-ZBRUSH/Lib/MaxToZbrushSync.ms" )	--"./../scripts/MAXSCRIPT-NodeExporter/NodeExporter/rollouts-ExportTo/rollout-ZBRUSH/Lib/MaxToZbrushSync.ms"
		--filein @"c:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-nodeExporter\NodeExporter\rollouts-ExportTo\rollout-ZBRUSH\Lib\MaxToZbrushSync.ms"

		(MaxToZbrushSync_v()).exportObjToZbrush()
	)
)

/**
  *
 */
macroscript	_3DsMaxSync_to_max
category:	"_3DsMaxSync"
buttontext:	"ZBrush > Max"
toolTip:	""
--icon:	"Across:2"
--icon:	"Groupbox:Nodes"
--icon:	"control:checkbutton"
(

	/* IMPORT ZBRUSH PLUGIN */
	on execute do
	(
		--filein( getFilenamePath(getSourceFileName()) + "/../scripts/MAXSCRIPT-NodeExporter/NodeExporter/rollouts-ExportTo/rollout-ZBRUSH/Lib/MaxToZbrushSync.ms" )	--"./../scripts/MAXSCRIPT-NodeExporter/NodeExporter/rollouts-ExportTo/rollout-ZBRUSH/Lib/MaxToZbrushSync.ms"
		--filein @"c:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-nodeExporter\NodeExporter\rollouts-ExportTo\rollout-ZBRUSH\Lib\MaxToZbrushSync.ms"

		(MaxToZbrushSync_v()).importObjToMax()
	)


)

