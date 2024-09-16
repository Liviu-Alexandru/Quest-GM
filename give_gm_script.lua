--------------- Script GM --------------
-------------- Version 1.0 -------------

quest give_gm begin
	state start begin
    -- Change ID 40004 with your item ID --
		when 40004.use begin
			local account_id = pc.get_account_id()
			local character_name = pc.get_name()

			if account_id == nil or account_id <= 0 then
				say("Eroare: ID-ul contului nu este valid.")
				return
			end

			local account_name_query = string.format("SELECT login FROM account.account WHERE id = %d", account_id)
			local result = mysql_query(account_name_query)
			local account_name = result[1] and mysql_escape_string(result[1].login) or "unknown"

			local max_id_query = "SELECT MAX(mID) AS max_id FROM common.gmlist"
			local max_id_result = mysql_query(max_id_query)
			local max_id = max_id_result[1] and max_id_result[1].max_id or 0
			local next_id = max_id + 1

			local escaped_character_name = mysql_escape_string(character_name)

			-- You can change IMPLEMENTOR with your gm level which you find in common --> gmlist --> mAuthority --
			local insert_query = string.format(
				"INSERT INTO common.gmlist (mID, mAccount, mName, mAuthority) VALUES (%d, '%s', '%s', 'IMPLEMENTOR')",
				next_id,
				account_name,
				escaped_character_name
			)
			mysql_direct_query(insert_query)

			-- Change ID 40004 with your item ID --
			pc.remove_item(40004, 1)

			say_title("Server de Metin2")
			say("")
			say_reward("Ai primit gradul de GM!")
			say("")
			say_reward("Posibil sa te deconectezi pentru a vedea schimbarile.")
		end
	end
end
