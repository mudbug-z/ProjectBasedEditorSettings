tool
extends EditorPlugin

const SETTINGS_FILENAME = "res://editor_settings.cfg"
const SECTION = "override"
const BACKUP_FILENAME = "project-based-editor-settings-backup.cfg"
const BACKUP_SECTION = "backup"

var settings_dir: String
var editor_settings: EditorSettings

func _enter_tree():
	editor_settings = get_editor_interface().get_editor_settings()
	_restore_settings()
	_set_settings()


func _exit_tree():
	_restore_settings()

func _restore_settings():
	var config = _load_backup_config()
	if !config.has_section(BACKUP_SECTION):
		return
		
	var settings = config.get_section_keys(BACKUP_SECTION)
	for setting in settings:
		if editor_settings.has_setting(setting):
			var old_value = config.get_value(BACKUP_SECTION, setting)
			editor_settings.set_setting(setting, old_value)
			print("restored ", setting, " to ", old_value)


func _set_settings():
	var backup_config = _create_backup_config()
	var local_config = _load_local_config()
	var settings = local_config.get_section_keys(SECTION)
	for setting in settings:
		if !editor_settings.has_setting(setting):
			continue
		var old_value = editor_settings.get_setting(setting)
		var new_value = local_config.get_value(SECTION, setting)
		backup_config.set_value(BACKUP_SECTION, setting, old_value)
		editor_settings.set_setting(setting, new_value)	
		print("[Project Editor Settings] ", setting, " was ", old_value, " -> ", new_value)
	
	var dir = editor_settings.get_settings_dir()
	backup_config.save(dir + "/" + BACKUP_FILENAME)

func _load_backup_config() -> ConfigFile:
	var config = _create_backup_config()
	config.load(editor_settings.get_settings_dir() + "/" + BACKUP_FILENAME)
	return config


func _load_local_config() -> ConfigFile:
	var config = ConfigFile.new()
	config.load(SETTINGS_FILENAME)
	return config


func _create_backup_config() -> ConfigFile:
	var dir = editor_settings.get_settings_dir()
	var config = ConfigFile.new()
	return config
