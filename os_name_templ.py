import pg_type_template

model = {
    "ext_name": "os_name",
    "ext_version": "0.0.4",
    "types": [
        {
            "type_name": "os_name",
            "type_values": [
                { "name": "android", "value": 20 },
                { "name": "android-tv", "value": 30 },
                { "name": "bada", "value": 40 },
                { "name": "blackberry", "value": 60 },
                { "name": "fire-tv", "value": 70},
                { "name": "ios", "value": 80 },
                { "name": "linux", "value": 100 },
                { "name": "macos", "value": 120 },
                { "name": "roku-tv", "value": 130 },
                { "name": "samsung-tv", "value": 135 },
                { "name": "server", "value": 140 },
                { "name": "symbian", "value": 160 },
                { "name": "webos", "value": 180 },
                { "name": "windows", "value": 200 },
                { "name": "windows-phone", "value": 220 },
                { "name": "unknown", "value": 255 },
            ]
        }
    ]
}
templ = pg_type_template.TypeTemplate(model)
templ.render_to_dir(".")
