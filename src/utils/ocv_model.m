function ocv = ocv_model(soc)
% soc in [0,1]
% Simple synthetic OCV curve for demo
soc = min(1,max(0,soc));
ocv = 3.0 + 1.2*soc - 0.1*soc.*(1-soc);  % smooth monotonic-ish curve
end
