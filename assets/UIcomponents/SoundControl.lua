gSounds = "assets/sounds/"

-- function SFX()
--     local tracks = {
--         ['explosion'] = love.audio.newSource(gSounds.."bombsound.wav","static"),
--         ['win'] = love.audio.newSource(gSounds.."win.wav", "static"),
--         ['start'] = love.audio.newSource(gSounds.."start.wav", "static"),
--         ['click'] = love.audio.newSource(gSounds.."click.wav", "static")
--     }
--     return {
--         play = function(effect)
--             assert(tracks[effect], "No found sound track")
--             tracks[effect]:play()
--         end,
--         stop = function(effect)
--             assert(tracks[effect], "No found sound track")
--             if tracks[effect]:isPlaying() then
--                 tracks[effect]:stop()
--             end
--         end,
--         setVolume = function(effect, volume)
--             tracks[effect]:setVolume(volume)
--         end
--     }
-- end
-- return SFX


local SFX = {}

function SFX.play(self, effect)
    assert(self.tracks[effect], "Not found: "..effect)
        self.tracks[effect]:play()
end

function SFX.stop(self, effect)
    assert(self.tracks[effect], "Not found: "..effect)
    if self.tracks[effect]:isPlaying() then
        self.tracks[effect]:stop()
    end
end

function SFX.setVolume(self, effect, volume)
    self.tracks[effect]:setVolume(volume)
end

return SFX