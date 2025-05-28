macroscript nodeExporter_open
category:	"_nodeExporter"
buttontext:	"vT3"
toolTip:	"Open nodeExporter"
(
-- 	filein @"$userscripts\nodeExporter\nodeExporter-import-scripts.ms"
	--filein @"$userscripts\nodeExporter\includes.ms"
	
	if DIALOG_viltools != undefined and not keyboard.controlPressed then 
		VILTOOLS.create()

	else
		filein @"$userscripts\MAXSCRIPT-nodeExporter\nodeExporter.ms"
	
)