-- Based on https://github.com/ChaosWormz/mt_terms_of_use
-- Based on https://github.com/davisonio/craig-server_game/blob/df8beb15e6b02ab6dd22f94349453c51819238c4/mods/_misc/rules.lua

local E = minetest.formspec_escape

local rules = [[
Die Nutzungsbedingungen bitte mit JA bestätigen, um Baurechte zu erhalten. 
1) Ich bin damit einverstanden, dass Daten, die notwendig sind für das Spiel, auf dem Server gespeichert werden (Gebaute und abgebaute Elemente sowie Äußerungen im Chat, IP-Adresse für das Bannen von Spielern, die sich nicht an die Regeln halten)
2) Ich werde nichts mutwillig zerstören, was andere gebaut haben.
3) Keine Beleidigungen im Chat.
4) Den Anweisungen der Admins ist Folge zu leisten.
Dieser Minetest Server wird gehostet auf einem dedizierten Ubuntu Linux Server der Firma Hetzner mit Standort in Falkenstein (Deutschland). 
Verantwortlich für den Datenschutz: Fabian Karg, LMZ Baden-Württemberg, karg@lmz-bw.de
]]

local formspec = "size[10,8]"
	.. "textarea[0.5,0.5;9.5,8;TOS;" .. E("NUTZUNGSBEDINGUNGEN") .. ";" .. E(rules) .. "]"
	.. "button_exit[6,7.5;1.5,0.5;accept;JA]"
	.. "button_exit[7.5,7.5;1.5,0.5;decline;NEIN]"

local function show_formspec(name)
	minetest.show_formspec(name, "rules", formspec)
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "rules" then return end
	local name = player:get_player_name()
	if fields.accept then
		if minetest.check_player_privs(name, {shout = true}) then
			minetest.chat_send_player(name, "Danke für die Besätigung der Nutzungsbedingungen, du bekommst jetzt Baurechte.")
			minetest.chat_send_player(name, "Viel Spaß beim Bauen.")
			local privs = minetest.get_player_privs(name)
			privs.interact = true
			minetest.set_player_privs(name, privs)
		end
		return
	elseif fields.decline then
		minetest.chat_send_player(name, "Du kannst dich umschauen, aber nicht aktiv bauen. Wenn du es dir anders überlegt hast, schreibe noch einmal /nutzungsbedingungen in den Chat.")
		return
	end
end)

minetest.register_chatcommand("nutzungsbedingungen", {
	description = "Zeigt die Nutzungsbedingungen des Servers",
	privs = {shout = true},
	func = show_formspec
})

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	if not minetest.check_player_privs(name, {interact = true}) then
		show_formspec(name)
	end
end)
