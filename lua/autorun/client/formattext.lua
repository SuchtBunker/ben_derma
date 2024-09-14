-- [[ THIS CODE IS WRITTEN BY BENN20002 (76561198114067146) DONT COPY OR STEAL! ]] --

function Ben_Derma.FormatText(text,font,maxW,addWFirstLine)
  local curLineW = addWFirstLine or 0

  surface.SetFont(font)
  local spaceW = surface.GetTextSize(" ")

  local finalLines = {}
  local lines = string.Explode("\n",text)
  for i=1, #lines do
    local lineWords = string.Explode(" ",lines[i])
    local curLine = ""

    // SPLIT LINE IF TOO LONG
    for i2=1, #lineWords do
      local word = lineWords[i2]
      local wordWidth = surface.GetTextSize(word)
      
      // New line if its too long for the current
      local firstWord = i2==1
      if !firstWord and (curLineW + wordWidth + spaceW) > maxW then
        table.insert(finalLines,curLine)
        curLine = ""
        curLineW = 0
        firstWord = true
      end
      
      // Add current workd
      curLine = curLine..(firstWord and "" or " ")..word
      curLineW = curLineW + wordWidth + (firstWord and 0 or spaceW)
    end

    // Add the last line aswell
    table.insert(finalLines,curLine)
    curLineW = 0
  end

  return table.concat(finalLines,"\n"), finalLines
end