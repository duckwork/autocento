-- Pandoc "Just the text, Ma'am"
-- (JTTM): a custom writer that
-- strips everything except for
-- the TEXT from a pandoc source
-- vim: fdm=marker
-- invoke with: pandoc -t jttm/jttm.lua

-- Table to store footnotes so they are at the END of the document
local notes = {}

-- This function is called once for the whole document. Parameters:
-- body is a string, metadata is a table, variables is a table.
-- One could use some kind of templating
-- system here; this just gives you a simple standalone HTML file.
function Doc(body, metadata, variables)
    local buffer = {}
    local function add(s)
        table.insert(buffer, s)
    end
    if metadata['title'] and metadata['title'] ~= "" then
        add(string.upper(metadata['title']))
    end
    if metadata['subtitle'] and metadata['subtitle'] ~= "" then
        add(": " .. metadata['subtitle'])
    end
    add("\n")
    -- TODO: epigraph.content, epigraph.attrib, dedication, other metadata?
    add(body)
    -- TODO: add notes at the end.
    return table.concat(buffer, '\n')
end

-- TODOs {{{
function align(align)
    -- TODO: is this necessary?
end

function Note(s)
    -- TODO
end

-- convert Tables to csv? or tab-separated?
function Table(caption, aligns, widths, headers, rows)
    local buffer = {}
    local function add(s)
        table.insert(buffer, s)
    end
    add("\n\n")
    if caption ~= "" then
        add("[" .. caption .. "]")
    end
    -- TODO: finish
end

-- }}}
-- Remove all formatting {{{
function Blocksep()
    return "\n\n"
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
    return " "
end

function Str(s)
    return s
end

function Div(s, attr)
    return s
end

function Space(s)
    return " "
end

function LineBreak()
    return "\n"
end

function Para(s)
    -- add paragraphing
    return s .. "\n\n"
end
-- }}}
-- Leave just a little formatting {{{
function Header(lev, s, attr)
    if lev == 1 then
        return "\n\n    " .. string.upper(s) .. "\n\n"
    elseif lev == 2 then
        return "\n    " .. string.upper(s) .. "\n"
    else
        return s
    end
end

function Blockquote(s)
    return "\n\n" .. string.gsub(s, "*\n", "    %0")
end

function HorizontalRule(s)
    return "\n\n\n"
end

function BulletList(items)
    local buffer = {}
    for _, item in pairs(items) do
        table.insert(buffer, "- " .. item .. "\n")
    end
    return "\n\n" .. table.concat(buffer, "\n") .. "\n\n"
end

function DefinitionList(items)
    local buffer = {}
    for _, item in pairs(items) do
        for k, v in pairs(item) do
            table.insert(buffer, "\n" .. k .. ":\n    " ..
                         table.concat(v, "\n    "))
        end
    end
    return "\n\n" .. table.concat(buffer, "\n") .. "\n\n"
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

