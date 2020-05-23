----------------------------------------
--- Discord Whitelist, Made by FAXES ---
----------------------------------------

-- Documentation: https://docs.faxes.zone/docs/discord-whitelist-setup
--- Config ---
notWhitelistedMessage = "You are not whitelisted for this server." -- Message displayed when they are not whitelist with the role

whitelistRoles = { -- Role nickname(s) needed to pass the whitelist
  "DISCORD_ROLE_ID",
}


blacklistRole = {
  "DISCORD_ROLE_ID",
}

bannedMessage = "You are currently banned from the server"
--- Code ---

AddEventHandler("playerConnecting", function(name, setCallback, deferrals)
    local src = source
    local passAuth = false
    deferrals.defer()
    deferrals.update("Checking Permissions...")

    for k, v in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            identifierDiscord = v
        end
    end

    if identifierDiscord then
        usersRoles = exports.discord_perms:GetRoles(src)
        local function has_value(table, val)
            if table then
                for index, value in ipairs(table) do
                    if value == val then
                        return true
                    end
                end
            end
            return false
        end
        for index, valueReq in ipairs (blacklistRole) do
          if has_value(usersRoles, valueReq) then
            passAuth = false
          else
            for index, valueReq in ipairs (whitelistRoles) do
              if has_value(usersRoles, valueReq) then
                passAuth = true
              end
              if next(whitelistRoles, index) == nil then
                if passAuth == true then
                  deferrals.done()
                else
                  deferrals.done(notWhitelistedMessage)
                end
              end
            end
            if next(blacklistRole, index) == nil then
              if passAuth == false then
                deferrals.done(bannedMessage)
              end
            end
          end
        end
      end
    end
  end
end
