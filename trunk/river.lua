-- Pandoc River writer
-- it takes out all formatting, leaving only a river of text
-- running down the page: one word per line
-- vim: fdm=marker
-- invoke with: pandoc -t river.lua

os.setlocale("en_US.UTF-8")

local function flow(s)
    return s:gsub("%s+", "\n")
end

local function nude(s)
    -- Expand contractions
    s = s:gsub("'%a+%s", function (x)
        if x == "'ll" then
            return " will "
        elseif x == "'ve" then
            return " have "
        elseif x == "'re" then
            return " are "
        else
            return x
        end
    end)
    s = s:gsub("it's", "it is")
    s = s:gsub("n't", " not ")
    -- Get rid of quotes around words
    s = s:gsub('"', ' ')
    s = s:gsub("%s+'", ' ')
    s = s:gsub("'%s+", ' ')
    -- Remove HTML entities
    s = s:gsub('&.-;', ' ')
    s = s:gsub('%b<>', ' ')
    -- Remove end-of-line backslashes
    s = s:gsub('%s+\\$', ' ')
    -- Remove dashes (not hyphens)
    s = s:gsub('%-%-+', ' ')
    s = s:gsub('%-%s', ' ')
    -- Remove everything that is not letters or numbers
    s = s:gsub('[%.!%?:;,%[%]%(%)<>]', ' ')
    -- Remove extra spaces
    s = s:gsub('%s+', ' ')
    return s:lower()
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
    -- TODO: epigraph.content, epigraph.attrib, dedication, other metadata?
    add(body)
    return flow(buffer)
end

-- Remove all formatting {{{
function Note(s)
    return nude(s)
end

function Blocksep()
    return "\n"
end
function Emph(s)
    return nude(s)
end

function Strong(s)
    return nude(s)
end

function Subscript(s)
    return nude(s)
end

function Superscript(s)
    return nude(s)
end

function SmallCaps(s)
    return nude(s)
end

function Strikeout(s)
    return nude(s)
end

function Code(s, attr)
    return nude(s)
end

function CodeBlock(s, attr)
    return nude(s)
end

function InlineMath(s)
    return nude(s)
end

function DisplayMath(s)
    return nude(s)
end

function Span(s, attr)
    return nude(s)
end

function Cite(s)
    return nude(s)
end

function Plain(s)
    return nude(s)
end

-- Links only include the link text
function Link(s, src, tit)
    return nude(s)
end

-- Images have nothing to give us
-- (but add a space just in case)
function Image(s, src, tit)
    return "\n"
end

function CaptionedImage(s, src, tit)
    return "\n"
end

function Str(s)
    return nude(s)
end

function Div(s, attr)
    return nude(s)
end

function Space(s)
    return "\n"
end

function LineBreak()
    return "\n"
end

function Para(s)
    return nude(s)
end

function Header(lev, s, attr)
    return nude(s)
end

function BlockQuote(s)
    return nude(s)
end

function HorizontalRule()
    return "\n"
end

function BulletList(items)
    local buffer = ""
    for _, item in pairs(items) do
        buffer = buffer .. nude(item) .. "\n"
    end
    return buffer .. "\n"
end

function OrderedList(items)
    local buffer = ""
    for _, item in pairs(items) do
        buffer = buffer .. nude(item) .. "\n"
    end
    return buffer .. "\n"
end

function DefinitionList(items)
    local buffer = ""
    for _, item in pairs(items) do
        for k, v in pairs(item) do
            buffer = buffer .. nude(k) .. "\n" .. nude(v) .. "\n"
        end
    end
    return buffer .. "\n"
end

function Table(caption, aligns, widths, headers, rows)
    local buffer = ""
    local function add(s)
        buffer = buffer .. nude(s) .. "\n"
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

