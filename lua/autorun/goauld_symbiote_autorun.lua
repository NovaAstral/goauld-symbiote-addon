if SERVER then
    hook.Add("PlayerSay","GoauldControlBlockChat",function(ply,str,team,dead) 
        if(ply.IsGoauldControlled == true) then
            ply.GoauldPly:PrintMessage(3,"Your host tried to say: \n"..str) --Chat/Console
            ply.GoauldPly:PrintMessage(4,"Your host tried to say: \n"..str) --Center of the screen

            ply:PrintMessage(4,"You are being controlled by a Goa'uld symbiote, only your symbiote can hear you.") --Center of the screen
            ply:PrintMessage(2,"You are being controlled by a Goa'uld symbiote, only your symbiote can hear you.") --Console
            return "" --suppress chat if you're being controlled by goa'uld
        end
    end)

    hook.Add("PlayerCanHearPlayersVoice","GoauldControlBlockVoiceChat",function(listener,talker)
        if(talker.IsGoauldControlled == true and listener ~= talker.GoauldPly) then
            return false
        end
    end)

    local blockspawnhooks = {"PlayerSpawnEffect","PlayerSpawnNPC","PlayerSpawnObject","PlayerSpawnProp","PlayerSpawnRagdoll","PlayerSpawnSENT","PlayerSpawnSWEP","PlayerSpawnVehicle","PlayerGiveSWEP"}

    for k,hooks in ipairs(blockspawnhooks) do
        hook.Add(hooks,"GoauldControlBlockSpawns",function(ply)
            if(ply.IsGoauldControlled == true) then
                ply:PrintMessage(4,"You are being controlled by a Goa'uld symbiote, you cannot spawn anything") --Center of the screen
                ply:PrintMessage(2,"You are being controlled by a Goa'uld symbiote, you cannot spawn anything") --Console
                return false
            end
        end)
    end
end

if CLIENT then
    hook.Add("PlayerStartVoice", "ImageOnVoice", function(ply)
        ply:PrintMessage(4,"You are being controlled by a Goa'uld symbiote, only your symbiote can hear you.") --Center of the screen
        ply:PrintMessage(2,"You are being controlled by a Goa'uld symbiote, only your symbiote can hear you.") --Console
    end)
end