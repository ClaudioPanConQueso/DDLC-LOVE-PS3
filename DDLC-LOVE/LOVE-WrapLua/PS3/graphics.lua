InitGFX(720,480)
InitFont("/dev_flash/data/font/SCE-PS3-RD-R-LATIN.TTF", 12)
defaultfont = nil

-- Log de memoria para diagnostico: DDLC-LOVE/memlog.txt en el USB.
-- (borra el archivo o pone lv1lua.memlogging = false para desactivarlo)
lv1lua.memlogging = true
local memlogstarted = false
function lv1lua.memlog(msg)
    if not lv1lua.memlogging then return end
    pcall(function()
        local f = io.open(lv1lua.dataloc.."memlog.txt", memlogstarted and "a" or "w")
        if not f then return end
        memlogstarted = true
        local avail = "?"
        local ok, rc, t = pcall(mem.GetUserMemorySize)
        if ok and type(t) == "table" and t.available then
            avail = math.floor(t.available/1048576).."MB"
        end
        f:write(os.time().." libre="..avail.." "..tostring(msg).."\n")
        f:close()
    end)
end

--set up stuff
lv1lua.current = {font=defaultfont,color=nil}

-- En PS3 las imagenes cargadas NUNCA se liberan (medido: ~0.6 MB por carga de un
-- sprite, el GC no las recupera). Por eso se guardan todas: cada archivo se
-- carga una sola vez y se reutiliza.
local imgcache = {}
local imgoffset = {}
local trimtable = {}
pcall(function() trimtable = dofile(lv1lua.dataloc.."LOVE-WrapLua/PS3/trim.lua") or {} end)
function love.graphics.newImage(filename)
    local cached = imgcache[filename]
    if cached then return cached end
    lv1lua.memlog("img "..tostring(filename))
    local img = surface()
    img:LoadIMG(lv1lua.dataloc.."game/"..filename)
    imgcache[filename] = img
    if trimtable[filename] then imgoffset[img] = trimtable[filename] end
    return img
end

function love.graphics.draw(drawable,x,y,r,sx,sy)
    if not x then x = 0 end
    if not y then y = 0 end
    if not r then r = 0 end
    if not sx then sx = 1 end
    if not sy then sy = 1 end
    if sx and not sy then sy = sx end
    
    --scale 1280x720 to 720x480
    x = x * 0.5625; y = y * 0.5625
    y = y + 37
    
    if not lv1lua.isPSP and lv1luaconf.imgscale == true then
        sx = sx * 0.5625
        sy = sy * 0.5625
    end
    
    if drawable then
        local o = imgoffset[drawable]
        if o then x = x + o[1]; y = y + o[2] end
        drawable:setRectPos(x,y)
        BlitToScreen(drawable)
    end
end

-- Fuentes PS3: usa InitFont (una fuente activa a la vez, tamano variable).
-- Si existe game/assets/fonts/<nombre>.ttf se usa esa; si no, game/assets/fonts/ps3font.ttf;
-- si tampoco, la fuente del sistema de la PS3.
local FLASHFONT = "/dev_flash/data/font/SCE-PS3-RD-R-LATIN.TTF"
local ps3fontcache = {}
local function fileExists(path)
    if ps3fontcache[path] ~= nil then return ps3fontcache[path] end
    local ok, f = pcall(io.open, path, "rb")
    local found = false
    if ok and f then f:close(); found = true end
    ps3fontcache[path] = found
    return found
end

-- Una sola fuente y un solo tamano para TODO el texto: cambiar con InitFont
-- cada frame (nombre vs dialogo) trababa la PS3 y se quedaba sin memoria.
local FONTSIZE = 13
local chosenfont = nil
local function resolveFontPath(path)
    if chosenfont then return chosenfont end
    local base = lv1lua.dataloc.."game/assets/fonts/"
    if fileExists(base.."Aller_Rg.ttf") then
        chosenfont = base.."Aller_Rg.ttf"
    elseif fileExists(base.."ps3font.ttf") then
        chosenfont = base.."ps3font.ttf"
    else
        chosenfont = FLASHFONT
    end
    return chosenfont
end

local activepath, activesize = FLASHFONT, 12
local currentfont = nil
local function applyFont(font)
    local path, size = resolveFontPath(), FONTSIZE
    if font then path, size = font.path, font.size end
    if path ~= activepath or size ~= activesize then
        activepath, activesize = path, size
        if not pcall(InitFont, path, size) then
            activepath = FLASHFONT
            pcall(InitFont, FLASHFONT, size)
        end
    end
end

function love.graphics.newFont(setfont, setsize)
    local path
    if tonumber(setfont) then
        setsize = tonumber(setfont)
    else
        path = setfont
        if not setsize then setsize = 12 end
    end

    return {path = resolveFontPath(path), size = FONTSIZE}
end

function love.graphics.setFont(setfont,setsize)
    currentfont = setfont
end

function love.graphics.setNewFont(setfont,setsize)
    newfont = love.graphics.newFont(setfont, setsize)
    love.graphics.setFont(newfont, setsize)
    return newfont
end

function love.graphics.print(text,x,y)
    if not x then x = 0 end
    if not y then y = 0 end
    
    --scale 1280x720 to 720x480
    x = x * 0.5625; y = y * 0.5625
    y = y + 37
    
    if text then
        applyFont(currentfont)
        DrawText(x,y,text)
    end
end

function love.graphics.setColor(r,g,b,a)
    if not a then a = 255 end
    --lv1lua.current.color = Color.new(r,g,b,a)
end

function love.graphics.setBackgroundColor(r,g,b)
    --Screen.clear(Color.new(r,g,b))
end

function love.graphics.rectangle(mode, x, y, w, h)
    --scale 1280x720 to 720x480
    x = x * 0.5625; y = y * 0.5625; w = w * 0.5625; h = h * 0.5625
    
    if mode == "fill" then
        --Graphics.fillRect(x, x+w, y, y+h, lv1lua.current.color)
    elseif mode == "line" then
        --Graphics.fillEmptyRect(x, x+w, y, y+h, lv1lua.current.color)
    end
end

function love.graphics.line(x1,y1,x2,y2)
    --Graphics.drawLine(x1,y1,x2,y2,lv1lua.current.color)
end

function love.graphics.circle(x,y,radius)
    --Graphics.fillCircle(x,y,radius,lv1lua.current.color)
end
