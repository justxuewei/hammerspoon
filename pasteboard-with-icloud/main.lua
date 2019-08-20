PASTEBOARD_MENUBAR_ICON = ""
PASTEBOARD_FILE_PATH = ""
PASTEBOARD_SEPARATOR = "$fengefu$"
PASTEBOARD_ESCAPED_SEPARATOR = "%$fengefu%$"

--[[
    BASIC FUNTION: table print
--]]
function tprint(tbl, indent)
    if not indent then indent = 0 end
    for k, v in pairs(tbl) do
        formatting = string.rep("  ", indent) .. k .. ": "
        if type(v) == "table" then
            print(formatting)
            tprint(v, indent + 1)
        elseif type(v) == 'boolean' then
            print(formatting .. tostring(v))
        else
            print(formatting .. v)
        end
    end
end

--[[
    BASIC FUNCTION: get length of table
--]]
function table_len(t)
    if not t then return 0 end

    local length_num = 0
    for k, v in pairs(t) do -- for every key in the table with a corresponding non-nil value 
        length_num = length_num + 1
    end
    return length_num
end

--[[
    a meunbar tool for pasteboard stuffs with iCloud
    author: xavier niu
--]]
pasteboard = hs.menubar.new()

pasteboard:setIcon(PASTEBOARD_MENUBAR_ICON)

pasteboard:setMenu(function()

    -- load paste content from iCloud
    local file = io.open(PASTEBOARD_FILE_PATH, "r")
    if not file then print(">>> PASTEBOARD FILE NOT FOUND") end

    local pasteboard_items = {}
    local text = ""
    for line in file:lines() do
        print('>>> line: ' .. line)
        local i, j = string.find(line, PASTEBOARD_ESCAPED_SEPARATOR)
        if i and j then
            print(">>> separator found")
            text = text .. string.sub(line, 0, i - 1)
            table.insert(pasteboard_items, text)
            text = ""
        else
            print(">>> do string concatenation with a line break")
            text = text .. line .. "\n"
        end
    end

    file:close()

    local menu_items = {
        {
            title = "Copy to iCloud",
            shortcut = "C",
            fn = function()
                -- read the first of string from pasteboard
                local pb_string = hs.pasteboard.readString()
                if not pb_string then
                    hs.notify.new({
                        title = "Error",
                        informativeText = "Pasteboard may empty or has content with unsupported types."
                    }):send()
                end

                -- copy to iCloud
                local file = io.open(PASTEBOARD_FILE_PATH, "r")
                local lines = {}
                for line in file:lines() do
                    table.insert(lines, line)
                end
                file:close()
                table.insert(lines, 1, pb_string .. PASTEBOARD_SEPARATOR)
                file = io.open(PASTEBOARD_FILE_PATH, "w")
                for _, line in ipairs(lines) do
                    file:write(line .. "\n")
                end
                file:close()

                hs.notify.new({
                    title = "Success",
                    informativeText = '"' .. pb_string ..
                        '" has been copied to iCloud.'
                }):send()
            end
        }, {title = "-"}
    }

    if table_len(pasteboard_items) == 0 then
        table.insert(menu_items, {title = "No data in iCloud.", disabled = true})
    else
        for _, item in ipairs(pasteboard_items) do

            -- substr for display in menubar
            local display_text
            if string.len(item) >= 20 then
                display_text = string.sub(item, 0, 19) .. "..."
            else
                display_text = item
            end

            -- add the item into menubar
            table.insert(menu_items, {
                title = display_text,
                fn = function()
                    local result = hs.pasteboard.writeObjects(item)
                    if result then
                        hs.notify.new({
                            title = "Success",
                            informativeText = "The text has been copied."
                        }):send()
                    else
                        hs.notify.new({
                            title = "Error",
                            informativeText = "Please check information from the console of Hammerspoon."
                        }):send()
                    end
                end
            })
        end
    end

    return menu_items
end)

