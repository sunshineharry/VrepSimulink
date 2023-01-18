function blkStruct = slblocks

Browser.Library = 'VrepLib';    % 此处可根据模型名字修改
Browser.Name    = 'VrepLib';    % 该名字为库中所看到的名字
Browser.IsFlat  = 0;            % 判断模块是否有下一级
blkStruct.Browser = Browser;    % 此处命名随意