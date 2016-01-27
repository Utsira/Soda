--# Main

local url = "https://raw.githubusercontent.com/Utsira/Soda/master/tabs/"
 
local function install(data)
    --parse plist into list of tab files
    local array = data:match("<key>Buffer Order</key>%s-<array>(.-)</array>")
    local files = {}   
    for tabName in array:gmatch("<string>(.-)</string>%s") do
        table.insert(files, {name = tabName})
    end   
    --success function
    local function success(n, name, data)
        if not data then alert("No data", name) return end
        print("Loaded "..n.."/"..#files..":"..name)
        files[n].data = data
        for _,v in ipairs(files) do
            if not v.data then 
                return --quit this function if any files have missing data
            end
        end
        --if all data is present then save...
        for i,v in ipairs(files) do
            saveProjectTab(v.name, v.data)
            print("Saved "..i.."/"..#files..":"..v.name)
        end
        for i,v in ipairs(files) do --load...
            load(v.data)() 
        end
        setup() --...and run
    end
    --request all the tab files
    for i,v in ipairs(files) do 
        local function retry(error) --try each file twice, in case of time-outs
            print(error, v.name.." not found, retrying")
            http.request(url..v.name..".lua", function(data) success(i, v.name, data) end, function(error2) alert(error2, v.name.." not found") end)
        end
        http.request(url..v.name..".lua", function(data) success(i, v.name, data) end, retry)
    end
end
http.request(url.."Info.plist", install, function (error) alert(error) end)
  