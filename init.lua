# Based on https://github.com/ChaosWormz/mt_terms_of_use

local RULES = [[
Nutzungsbedingungen
1) Ich bin damit einverstanden, dass Daten, die notwendig sind für das Spiel, auf dem Server gespeichert werden (Gebaute und abgebaute Elemente sowie Äußerungen im Chat)
2) Ich werde nichts mutwillig zerstören, was andere gebaut haben. 
Auf JA klicken, um Baurechte zu erhalten.
Danke 
]]

local function make_formspec()
	local size = { "size[10,8]" }
	table.insert(size, "textarea[0.5,0.5;9.5,8;TOS;Das sind die Nutzungsbedingungen. Bitte klicken, um sie zu bestätigen;"..RULES.."]")
	table.insert(size, "button_exit[6,7.4;1.5,0.5;accept;JA]")
	table.insert(size, "button[7.5,7.4;1.5,0.5;decline;NEIN]")
	return table.concat(size)
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "rules" then return end
	local name = player:get_player_name()
	if fields.accept then
		if minetest.check_player_privs(name, {shout=true}) then
			minetest.chat_send_player(name, "Danke für die Besätigung der Nutzungsbedingungen, du bekommst jetzt Baurechte.")
			minetest.chat_send_player(name, "Viel Spaß beim Bauen.")
			local privs = minetest.get_player_privs(name)
			privs.interact = true
			minetest.set_player_privs(name, privs)
		end
		return
	elseif fields.decline then
		minetest.chat_send_player(name, "Du kannst dich umschauen, aber nicht aktiv bauen. Wenn du es dir anders überlegt hast, schreibe noch einmal /nutzungsbedingungen in den Chat")
		return
	end
end)

minetest.register_chatcommand("nutzungsbedingungen",{
	params = "",
	description = "Zeigt die Nutzungsbedingungen des Servers",
	privs = {shout=true},
	func = function (name,params)
	local player = minetest.get_player_by_name(name)
		minetest.after(1, function()
			minetest.show_formspec(name, "rules", make_formspec())
		end)
	end
})
