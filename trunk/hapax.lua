-- Pandoc Hapax writer
-- it takes out all formatting, leaving only a river of text
-- running down the page: one word per line, stripping all duplicates
-- vim: fdm=marker
-- invoke with: pandoc -t hapax.lua

os.setlocale("en_US.UTF-8")

function hapax(s)
    local function tablify (s, p)
        local t={}
        for w in s:gmatch(p) do
            table.insert(t, w)
        end
        return t
    end
    local function stripDupes (t)
        local seen = {}
        local remove = {}
        for i = 1, #t do
            element = t[i]
            if seen[element] then
                remove[element] = true
            else
                seen[element] = true
            end
        end
        for i = #t, 1, -1 do
            if remove[t[i]] then
                table.remove(t, i)
            end
        end
        return t
    end
    return table.concat(stripDupes(tablify(s, "%S+")), "\n")
end

function flow(s)
    return s:gsub("%s+", "\n")
end

function nude(s)
    s = s:lower()
    -- Expand contractions
    s = s:gsub("'ll", " will ")
    s = s:gsub("'ve", " have ")
    s = s:gsub("'re", " are ")
    s = s:gsub("i'm", " i am ")
    s = s:gsub("it's", "it is")
    s = s:gsub("n't", " not ")
    s = s:gsub("&", " and ")
    -- -- Remove dashes (not hyphens)
    s = s:gsub('%-[%-%s]+', ' ')
    -- Remove everything that is not letters or numbers
    s = s:gsub('[^A-Za-z0-9/\'-]', ' ')
    -- Remove extra spaces
    s = s:gsub('%s+', ' ')
    return " "..s.." "
end

-- This function is called once for the whole document. Parameters:
-- body is a string, metadata is a table, variables is a table.
-- One could use some kind of templating
-- system here; this just gives you a simple standalone HTML file.
function Doc(body, metadata, variables)
    local buffer = ""
    local function add(s)
        buffer = buffer .. nude(s) .. "\n"
    end
    if metadata['title'] then
        add(metadata['title'])
    end
    if metadata['subtitle'] then
        add(metadata['subtitle'])
    end
    add(body)
    return hapax(flow(buffer))
    -- return flow(buffer)
end

-- Remove all formatting {{{
function Note(s)
    return s
end

function Blocksep()
    return "\n"
end
function Emph(s)
    return s
end

function Strong(s)
    return s
end

function Subscript(s)
    return s
end

function Superscript(s)
    return s
end

function SmallCaps(s)
    return s
end

function Strikeout(s)
    return s
end

function Code(s, attr)
    return s
end

function CodeBlock(s, attr)
    return s
end

function InlineMath(s)
    return s
end

function DisplayMath(s)
    return s
end

function Span(s, attr)
    return s
end

function Cite(s)
    return s
end

function Plain(s)
    return s
end

-- Links only include the link text
function Link(s, src, tit)
    return s
end

-- Images have nothing to give us
-- (but add a space just in case)
function Image(s, src, tit)
    return "\n"
end

function RawBlock(s)
    return s
end

function RawInline(s)
    return s
end

function CaptionedImage(s, src, tit)
    return "\n"
end

function Str(s)
    return s
end

function Div(s, attr)
    return s
end

function Space(s)
    return "\n"
end

function LineBreak()
    return "\n"
end

function Para(s)
    return s
end

function Header(lev, s, attr)
    return s
end

function BlockQuote(s)
    return s
end

function HorizontalRule()
    return "\n"
end

function BulletList(items)
    local buffer = ""
    for _, item in pairs(items) do
        buffer = buffer .. " " .. item .. "\n"
    end
    return buffer .. "\n"
end

function OrderedList(items)
    local buffer = ""
    for _, item in pairs(items) do
        buffer = buffer .. " " .. item .. "\n"
    end
    return buffer .. "\n"
end

function DefinitionList(items)
    local buffer = ""
    for _, item in pairs(items) do
        for k, v in pairs(item) do
            buffer = buffer .. " " .. k .. "\n" .. v .. "\n"
        end
    end
    return buffer .. "\n"
end

function Table(caption, aligns, widths, headers, rows)
    local buffer = ""
    local function add(s)
        buffer = buffer .. " " .. s .. "\n"
    end
    if caption ~= "" then
        add(caption)
    end
    for _,h in pairs(headers) do
        add(h)
    end
    for _, row in pairs(rows) do
        for _, cell in pairs(row) do
            add(cell)
        end
    end
    return buffer
end
-- }}}

-- The following code will produce runtime warnings when you haven't defined
-- all of the functions you need for the custom writer, so it's useful
-- to include when you're working on a writer.
local meta = {}
meta.__index =
  function(_, key)
    io.stderr:write(string.format("WARNING: Undefined function '%s'\n",key))
    return function() return "" end
  end
setmetatable(_G, meta)
