function txt = displayCoordinates(~,info)
    x = info.Position(1);
    y = info.Position(2);
    txt = ['frecuencia: ' num2str(x) ' Hz        '  'TL: ' num2str(y) ' dB'];
end