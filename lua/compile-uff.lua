#!/usr/bin/env lua
-- A compiler for "Autocento of the breakfast table" by Case Duckworth
-- check it in action at: www.autocento.me
-- Usage: `lua compile.lua [options] <files>
-- Where [options] are
-- -- -html: compiles html files
-- -- -river: compiles river files (only words, one per line)
-- -- -lozenge: updates lozenge.js file
-- vim: fdm=indent

defaults = {}
    defaults.dirs = {
        root = "/d/Copy/projects/autocento/",
        src  = "/d/Copy/projects/autocento/src/",
        lua  = "/d/Copy/projects/autocento/lua/",
        js   = "/d/Copy/projects/autocento/js/",
        css  = "/d/Copy/projects/autocento/css/",
    }
    defaults.files = {
        lozenge = defaults.dirs.js .. "lozenge.js",
    }
    defaults.formats = {
        html = {
            output_dir  = defaults.dirs.root,
            extension   = "html",
            pandoc_args = {
                from     = "markdown",
                to       = "html5",
                template = ".template.html",
                "smart",
                "mathml",
                "section-divs",
            }
        },
        river = {
            output_dir  = defaults.dirs.root .. "river/",
            extension   = "river",
            pandoc_args = {
                from     = "markdown",
                to       = defaults.dirs.lua.."river.lua",
            },
        },
    }
    defaults.compile_args = {
        '-html',
        '-river',
        '-lozenge',
    }
helpers = {
    -- Little helper functions
    filter = function (list, filter)
        -- Filter a list.
        -- 1st return is list of terms that match.
        -- 2nd return is list of terms that don't match.
        local output_match = {}
        local output_nomatch = {}
        for _,v in ipairs(list) do
            if string.match(v, filter) then
                output_match[#output_match+1] = v
            else
                output_nomatch[#output_nomatch+1] = v
            end
        end
        return output_match, output_nomatch
    end,
    in_table = function (table, term)
        -- Search for term in table
        for k,v in pairs(table) do
            if v == term then
                return k
            end
        end
        return nil
    end,
    tsub = function (table, pattern, replace, i)
        -- gsub on every term in a table
        local output = {}
        if i then -- 'i' option just does ipair part of table
            for k,v in ipairs(table) do
                output[k] = v:gsub(pattern, replace)
            end
        else
            for k,v in pairs(table) do
                output[k] = v:gsub(pattern, replace)
            end
        end
        return output
    end,
    scandir = function (directory)
        -- Find all files in a directory
        local i, t, popen = 0, {}, io.popen
        for filename in popen('ls -a "'..directory..'"'):lines() do
            i = i+1
            t[i] = filename
        end
        return t
    end
}

function compile (files, format_args)
    -- Run pandoc on <files>, producing <output_format>, with [pandoc_args].
    local errors = 0
    if not format_args then
        format_args = defaults.formats[output_format]
    end
    print("Compiling files to "..format_args.extension.." ...")
    args = format_args.pandoc_args
    for _, file in pairs(files) do
        local pandoc_run = {
            'pandoc',
            '-f', args.from,
            '-t', args.to,
            '-o',
            file:gsub('%.%a+$', "."..format_args.extension)
        }
        if args.template then
            table.insert(pandoc_run, '--template="'..args.template..'"')
        end
        for _,a in ipairs(args) do
            pandoc_run[#pandoc_run+1] = a:gsub("^", "--")
        end
        table.insert(pandoc_run, file)
        for k,v in pairs(pandoc_run) do
            print(k, v)
        end
        if not os.execute(table.concat(pandoc_run, " ")) then
            errors = errors+1
        end
        io.write(".")
    end
    print("Compiling "..#files.." files completed with "..errors.." errors.")
end

function move (files, destination)
    -- Move files to destination
    print("Moving files to "..destination.." ...")
    local errors = 0
    for _, file in pairs(files) do
        if not os.execute("mv "..file.." "..destination) then
            errors = errors+1
        end
    end
    print("Moving "..#files.." completed with "..errors.." errors.")
end

function lozenge_list (files, blacklist)
    -- Produce list for placement in lozenge.js
    local output = {}
    for _,file in pairs(files) do
        -- table.insert(output, #output+1, file:gsub('.*', '"%0"'))
        output[#output+1] = file:gsub(".*", '"%0",')
    end
    if blacklist then
        for _,unwanted in pairs(blacklist) do
            _,output = helpers.filter(files, unwanted)
        end
    end
    output = table.concat(output, " ")
    output = "var files = ["..output
    output = output:gsub('"",', '')
    output = output:gsub(",$", "]")
    print(output)
end

local args, files = helpers.filter(arg, "^%-")
if not files or #files == 0 then
    -- Error: need files to work on!
    -- TODO: don't technically need file list for -lozenge
    print("ERROR: No file list.")
    os.exit(1)
end
basenames = helpers.tsub(files, "^.*/", "")
basenames = helpers.tsub(files, "%.%a+$", "")
if not args or #args == 0 or args == { "-all" } then
    args = defaults.compile_args
end
-- Option parsing
if helpers.in_table(args, "-html") then
    compile(files, defaults.formats.html)
    move(helpers.tsub(basenames, "$", "%0.html"),
         defaults.formats.html.output_dir)
end
if helpers.in_table(args, "-river") then
    compile(files, defaults.formats.river)
    move(helpers.tsub(basenames, ".*", "%0.river"),
         defaults.formats.river.output_dir)
end
if helpers.in_table(args, "-lozenge") then
    -- TODO: should probably break this out into a function
    print("Updating lozenge.js file list...")
    local htmls = helpers.filter(helpers.scandir(defaults.dirs.root),
                                 "html$")
    local f = assert(io.open(defaults.files.lozenge, "r"))
    local buffer = {}
    for line in f:lines() do
        if line:find("var files=") then
            table.insert(buffer, lozenge_list(htmls))
        else
            table.insert(buffer, line)
        end
    end
    f:close()
    -- Write the file we've just read
    local F = assert(io.open(defaults.files.lozenge, "w"))
    F:write(table.concat(buffer, "\n"))
    F:close()
    print("Done.")
end
