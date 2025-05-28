clearListener(); print("Cleared in:"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../MAXSCRIPT-UI-framework/Lib/FileInImporter/FileInImporter.ms" )	--"./../MAXSCRIPT-UI-framework/Lib/FileInImporter/FileInImporter.ms"
filein( getFilenamePath(getSourceFileName()) + "/../MAXSCRIPT-UI-framework/Lib/StartUpScriptImporter/StartUpScriptImporter.ms" )	--"./../MAXSCRIPT-UI-framework/Lib/StartUpScriptImporter/StartUpScriptImporter.ms"
filein( getFilenamePath(getSourceFileName()) + "/../MAXSCRIPT-UI-framework/Lib/PlugInImporter/PlugInImporter.ms" )	--"./../MAXSCRIPT-UI-framework/Lib/PlugInImpoerter/PlugInImpoerter.ms"

filein( getFilenamePath(getSourceFileName()) + "/../MAXSCRIPT-UI-framework/Lib/MacroscriptGenerator/generateMacroscripts.ms" )	--"./../MAXSCRIPT-UI-framework/Lib/MacroscriptGenerator/generateMacroscripts.ms"

filein( getFilenamePath(getSourceFileName()) + "/../MAXSCRIPT-UI-framework/Lib/ContentLoader/ContentLoader.ms" )	-- "./../MAXSCRIPT-UI-framework/Lib/ContentLoader/ContentLoader.ms"


--RUN_ON_STARTUP = true

--global NodeExporter
global DIALOG_nodeexporter

global ROLLOUT_export
global ROLLOUT_3d_print
--global ROLLOUT_viewports


/* DIRECTORY WHERE TO LOAD CONTENT */ 
content_dir = "NodeExporter"
--content_dir = "/Rollouts-Test" -- DEV

current_dir = getFilenamePath(getSourceFileName())

current_dir_name = trimRight ( pathConfig.stripPathToLeaf(current_dir)) "\\"

rollouts_dir = "$userscripts/"+current_dir_name+"/"+content_dir+"/rollouts-Tools"

/*------------------------------------------------------------------------------
	IMPORT FILES
--------------------------------------------------------------------------------*/
std_scripts = #(
	--( current_dir + "/../MAXSCRIPT-UI-framework/Lib/CallbackManager/CallbackManager.ms"),	--"./../MAXSCRIPT-UI-framework/Lib/CallbackManager/CallbackManager.ms"
	"/rollout-EXPORT/rollouts-ExportTo/rollout-ZBRUSH/Lib/MaxToZbrushSync.ms", -- "./VilTools/rollouts-Tools/rollout-EXPORT/rollouts-ExportTo/rollout-ZBRUSH/Lib/MaxToZbrushSync.ms"
	
	"" -- last blank item to prevent errors on development
)

startup_scripts = #(
	( current_dir + "/../MAXSCRIPT-UI-framework/Lib/Dialog/Dialog.ms" ), -- "./../MAXSCRIPT-UI-framework/Lib/Dialog/Dialog.ms"
	
	--"/rollout-VIEWPORTS/Lib/ViewportHud/_importHUD.ms", --"./VilTools/rollouts-Tools/rollout-VIEWPORTS/Lib/ViewportHud/_importHUD.ms"
	
	"" -- last blank item to prevent errors on development
)

filein_files = #(
)

StartUpScriptImporter = StartUpScriptImporter_v root:rollouts_dir filename:content_dir

/*------------------------------------------------------------------------------
	INSTALL STD SCRIPTS
--------------------------------------------------------------------------------*/
StartUpScriptImporter.createStartUpFile(std_scripts) std:true

/*------------------------------------------------------------------------------
	INSTALL START SCRIPTS
--------------------------------------------------------------------------------*/
--StartUpScriptImporter.createStartUpFile(startup_scripts)

/*------------------------------------------------------------------------------
	INSTALL PLUGINS
--------------------------------------------------------------------------------*/
--(PlugInImporter_v ( rollouts_dir + "/rollout-EXPORT/Lib/ExportNode/ExportNodePlugin.ms" )).install() --"./VilTools/rollouts-Tools/rollout-EXPORT/Lib/ExportNode/ExportNodePlugin.ms"

/*------------------------------------------------------------------------------
	GENERATE MACROS
--------------------------------------------------------------------------------*/
--generateMacroscripts( rollouts_dir )


/*------------------------------------------------------------------------------
     IMPORTANT CALLBACKS
--------------------------------------------------------------------------------*/
--CALLBACKMANAGER.import( getFilenamePath(getSourceFileName()) + "/Callbacks" ) --"./CallBacks/"	


/*------------------------------------------------------------------------------
	IMPORT FILES
--------------------------------------------------------------------------------*/
--(FileInImporter_v root:current_dir files:filein_files blacklist:"*Test*" ).import()




/* CONVERT RELATIVE PATHS TO ABSOLUTE */
--filein_files = for file_path in filein_files collect if ( matchPattern file_path pattern:@"/*" ) then pathConfig.convertPathToAbsolute(current_dir + file_path) else file_path

--
--try(
--	/* FILE IN FILES */
--	for file_path in filein_files where not matchPattern file_path pattern:"*Test*" do
--	(
--		format "FILE IN: % \n" (file_path)
--		if doesFileExist file_path then
--			filein( file_path)
--	)
--
--)catch
--(
--	format "\n——————————————— ERROR IN FILE ———————————————\n\n%\n" (getSourceFileName())
--	format "\n————————————————— EXCEPTION —————————————————\n\n%\n" (getCurrentException())
--    format "\n——————————————————— TRACE ———————————————————\n%\n"   (getCurrentExceptionStackTrace())
--    format "\n——————————————————— STACK ———————————————————\n%\n" 	(getCurrentExceptionCallStack())
--)
--




/*------------------------------------------------------------------------------
	
	
	CREATE VilTools DILAOG
	
	
------------------------------------------------------------------------------*/
try(
	/** LOAD CONTENT */
	----ContentLoader	= ContentLoader_v path:(current_dir+content) -- WITHOUT INI FILE --DEV
	
	ContentLoader	= ContentLoader_v path:(current_dir + content_dir)  ini:( getSourceFileName()) width:400

	/* CHANGE PROPERTIES oF ROLLOUTS */
	ContentLoader.Dialog.title = "NodeExporter"

	
	/* CREATE DIALOG */
	VILTOOLS = ContentLoader.create height:1024

	VILTOOLS.register()

)catch(
	format "\n——————————————— ERROR IN FILE ———————————————\n\n%\n" (getSourceFileName())
	format "\n————————————————— EXCEPTION —————————————————\n\n%\n" (getCurrentException())
    format "\n——————————————————— TRACE ———————————————————\n%\n"   (getCurrentExceptionStackTrace())
	format "\n——————————————————— STACK ———————————————————\n%\n"   (getCurrentExceptionCallStack())
)





/*------------------------------------------------------------------------------

	IMPORT FILES

--------------------------------------------------------------------------------*/

/* import when UI exists */
try
(
    --filein( getFilenamePath(getSourceFileName()) + "/VilTools/rollouts-Tools/rollout-EXPORT/Lib/ExportNodeCallbacks/ExportNodeCallback.ms" )	-- "./Rollouts/rollouts-Tools/rollout-EXPORT/Lib/ExportNodeCallbacks/ExportNodeCallback.ms"

	--(NodeList_v()).loadNodes()

	--selectExportNodeInListCallbactAdd()

	--filein( getFilenamePath(getSourceFileName()) + "/generateMacroscripts.ms" ) -- "./generateMacroscripts.ms"

	--if ROLLOUT_layers.CBXBTN_layer_manager.state then
		--showLayerManagerCallback()


)
catch
(
	format "\n——————————————— ERROR IN FILE ———————————————\n\n%\n" (getSourceFileName())
	format "\n————————————————— EXCEPTION —————————————————\n\n%\n" (getCurrentException())
    format "\n——————————————————— TRACE ———————————————————\n%\n"   (getCurrentExceptionStackTrace())
	format "\n——————————————————— STACK ———————————————————\n%\n"   (getCurrentExceptionCallStack())
)




















