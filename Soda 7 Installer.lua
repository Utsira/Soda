local url = "https://raw.githubusercontent.com/Utsira/Soda/master/tabs/"
 

local function install(data)
    --parse plist into list of tab files
    local array = data:match("<key>Buffer Order</key>%s-<array>(.-)</array>")
    local files = {}
    
    for tabName in array:gmatch("<string>(.-)</string>%s") do
        table.insert(files, {name = tabName})
    end   
    
    --success function
    local function success(i, name, data)
        if not data then alert("No data", name) return end
        print("Loaded "..i.."/"..#files..":"..name)
        files[i].data = data
        for i,v in ipairs(files) do
            if not v.data then 
                return --quit this function if any files have mssing data
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
        setup() --and run
    end
    --request all the tab files
    for i,v in ipairs(files) do
        http.request(url..v.name..".lua", function(data) success(i, v.name, data) end, function(error) alert(error, v.name.." not found") end)
    end
     
end

http.request(url.."Info.plist", install, function (error) alert(error) end)
  