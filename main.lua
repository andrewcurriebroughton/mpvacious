require('subs2srs')
--
local mp = require('mp')
local utils = require('mp.utils')

local function construct_curl_command(data, route)
    local url = string.format('http://127.0.0.1:5000%s', route)
    return string.format("curl -X POST -H 'Content-Type: application/json' -d '%s' %s", utils.format_json(data), url)
end

local function post_subtitle(_, subtitle_start)
    if subtitle_start == nil then
        return
    end
    local subtitle_end = mp.get_property('sub-end')
    local subtitle_text = mp.get_property('sub-text')
    local data = {}
    data['subtitleStart'] = subtitle_start
    data['subtitleEnd'] = subtitle_end
    data['subtitleText'] = subtitle_text
    local curl_command = construct_curl_command(data, '/subtitle')
    os.execute(curl_command)
end
mp.observe_property('sub-start', 'string', post_subtitle)

local function post_primary_subtitles_path(_, primary_subtitles_path)
    if primary_subtitles_path == nil then
        return
    end
    local data = {}
    data['primarySubtitlesPath'] = primary_subtitles_path
    local curl_command = construct_curl_command(data, '/subtitles/load/primary')
    os.execute(curl_command)
end
mp.observe_property('current-tracks/sub/external-filename', 'string', post_primary_subtitles_path)

-- confirm `sub-start` is `string` type (to pass to `mp.observe_property`):
-- mp.add_forced_key_binding('z', display_subtitle_start_property)
-- local function display_subtitle_start_property()
--     local subtitle_start_property = mp.get_property('sub-start')
--     print(subtitle_start_property, type(subtitle_start_property))
-- end
