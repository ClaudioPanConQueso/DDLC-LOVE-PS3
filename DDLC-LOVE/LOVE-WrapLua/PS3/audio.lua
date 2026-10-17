snd.Init()
snd.SetVolumeBGMusic(127)

-- Musica por streaming (snd.*BGMusic): lee del USB y NO consume RAM.
-- (snd.SetVoice descomprimia cada pista entera en memoria, ~30-60 MB, y no la liberaba.)
-- Si las funciones BGMusic fallan, se usa el metodo viejo (voces).
local usebgm = true
local bgmpath = nil
local bgmplaying = false
local bgmwait = 0
local audioplaying = {}

local function startBGM(path)
    pcall(snd.StopBGMusic)
    pcall(snd.FreeBGMusic)
    local ok1 = pcall(snd.SetBGMusic, path)
    local ok2 = ok1 and pcall(snd.PlayBGMusic, 0, 0)
    return ok1 and ok2
end

function lv1lua.playsound()
    --musica BGMusic: si termino la pista, repetirla (todas se repiten)
    if usebgm and bgmplaying and bgmpath then
        if bgmwait > 0 then
            bgmwait = bgmwait - 1
        else
            bgmwait = 30 --revisar ~2 veces por segundo
            local ok, st = pcall(snd.StatusBGMusic)
            if ok and st ~= 1 then
                lv1lua.memlog("bgm repetir "..bgmpath)
                startBGM(bgmpath)
                bgmwait = 120
            end
        end
    end

    --metodo viejo (voces)
    for i = 1, #audioplaying do
        if audioplaying[i] == 1 then
            snd.PlayVoice(i,0,0,200,200,0)
            sys.TimerUsleep(0)
        end
    end
end

function love.audio.newSource(source,sourcetype)
    local ch
    local fullpath = lv1lua.dataloc.."game/"..source

    if sourcetype == "stream" then
        ch = 1
        if not usebgm then
            audioplaying[ch] = 0
            lv1lua.memlog("audio(voz) "..tostring(source))
            snd.SetVoice(ch,fullpath)
        end
    end

    local table = {
        channel = ch;
        path = fullpath;
        type = sourcetype;
        play = function(self)
            love.audio.play(self)
        end;
        stop = function(self)
            love.audio.stop(self)
        end;
        getVolume = function(self)
        end;
        setVolume = function(self,vol)
        end;
        setLooping = function(self,setloop)
            --todas las pistas se repiten hasta que se detienen
        end;
        isPlaying = function(self)
        end;
        isLooping = function(self)
        end;
        }
    return table
end

function love.audio.play(source)
    if not source.channel then return end
    if usebgm then
        lv1lua.memlog("audio(bgm) "..tostring(source.path))
        if startBGM(source.path) then
            bgmpath = source.path
            bgmplaying = true
            bgmwait = 120 --dar tiempo a que arranque antes de revisar
            return
        end
        --fallo BGMusic: volver al metodo viejo
        usebgm = false
        bgmplaying = false
        lv1lua.memlog("BGMusic fallo, uso voces")
        audioplaying[source.channel] = 0
        snd.SetVoice(source.channel, source.path)
    end
    audioplaying[source.channel] = 1
end

function love.audio.stop(source)
    if source.channel then
        if usebgm then
            bgmplaying = false
            bgmpath = nil
            pcall(snd.StopBGMusic)
            pcall(snd.FreeBGMusic)
        else
            audioplaying[source.channel] = 0
            snd.StopVoice(source.channel)
            snd.FreeVoice(source.channel)
            table.remove(audioplaying,source.channel)
        end
    end
end
