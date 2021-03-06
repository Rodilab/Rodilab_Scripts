-- @description Move cursor rigth to nearest item edge in selected tracks and set time selection
-- @author Rodilab
-- @version 1.0
-- @about
--   Move cursor right to nearest item edge in selected tracks and set time selection
--   If no track is selected, is a normal "Move cursor right to nearest item edge".
--
--   by Rodrigo Diaz (aka Rodilab)

reaper.Undo_BeginBlock()
reaper.PreventUIRefresh(1)

-- Save selected items in a list
local count = reaper.CountSelectedMediaItems(0)
local selected_items = {}
for i=0, count-1 do
  selected_items[i] = reaper.GetSelectedMediaItem(0,i)
end

local old_cursor = reaper.GetCursorPosition()

-- Unselect all items
reaper.Main_OnCommand(40289,0)
-- Select all items on selected track
reaper.Main_OnCommand(40421,0)
-- Move edit cursor right
reaper.Main_OnCommand(40319,0)
-- Unselect all items
reaper.Main_OnCommand(40289,0)
-- Recover selection
for i=0, count-1 do
  reaper.SetMediaItemSelected(selected_items[i],true)
end

local new_cursor = reaper.GetCursorPosition()
local sel_in, sel_out = reaper.GetSet_LoopTimeRange(false,false,0,0,false)

if sel_in ~= sel_out and sel_in < new_cursor then
  reaper.GetSet_LoopTimeRange(true, true, sel_in, new_cursor, false )
else
  reaper.GetSet_LoopTimeRange(true, true, old_cursor, new_cursor, false )
end

reaper.Undo_EndBlock("Move cursor right to nearest item edge in selected tracks",0)
reaper.PreventUIRefresh(-1)
reaper.UpdateArrange()
