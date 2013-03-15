function [titchar2,saven] = ATL_names(buoyc,buoy,model,level,res)
titcharpt1=['Atlantic Hindcast Study [OWI Winds]   '];
titcharpt15=['WaveWatch III ','ST4',' (Res = ',num2str(1.0),'\circ)  '];
titcharpt17=['   [ ',num2str(model.lon),'\circ / ',num2str(model.lat),'\circ ]'];
titcharpt2=['NDBC = ',buoyc,' [',num2str(buoy.lon),'\circ / ', ...
    num2str(buoy.lat),'\circ]'];

titchar2=[titcharpt1;' ';{titcharpt2;titcharpt15;titcharpt17}];

saven = ['ATL-',level];

