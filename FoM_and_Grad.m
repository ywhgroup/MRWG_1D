function [FoM, Gradient] = FoM_and_Grad(PatternIn, B, FileName)

%% Parameters of MRWG structure 

    Hg = 160;
    Hw = 405;
    period = 870;
    Wavelength = 532;
    n_tio2 = 2.41321764861486;
    n_sio2 = 1.46070634489213;
    nTop = 1;
    nBot = n_sio2;
    nDevice = n_tio2;

%% Blur function & contrast function

    Rho2 = (B*(PatternIn'))';
    beta = 50;
    cutoff = 0.5;
    Rho3 = (tanh(beta*cutoff)+tanh((Rho2-cutoff).*beta))./(tanh(beta*cutoff)+tanh(beta*(1-cutoff)));
    Rho3_epsilon = Rho3*(nDevice^2 - nTop^2) + nTop^2;

 %% Reticolo 1D structure definition

    retio([],inf*1i);
    Rho3_index = (Rho3_epsilon).^(1/2);
    LayerTextures = cell(1,4);
    LayerTextures{1} = nTop; % 1
    LayerTextures{2} = {oneD(Rho3_index,1),oneD(Rho3_index,2)};
    LayerTextures{3} = nDevice;
    LayerTextures{4} = nBot;
    profile = {[0, Hg, Hw, 0], [1, 2, 3, 4]}; 

%% Foward calculation, FoM 

    nn = 40;
    angle_theta = 0; 
    k_parallel = nTop*sind(angle_theta);
    parm = res0;
    parm.res1.champ = 1; 
    parm.res3.npts = [0,50,0,0];
    angle_delta = 0;
    LayerResults = res1(Wavelength, period,LayerTextures,nn,k_parallel,angle_delta,parm);
    one_D = res2(LayerResults,profile);
    reflectance = one_D.TEinc_top_reflected;
    TargetIndex = find(reflectance.order(:,1)==1); % 3
    Abs_Efficiency = reflectance.efficiency_TE(TargetIndex);
    r = reflectance.amplitude_TE(TargetIndex);
    XX = linspace(0,period,192);
    [ForwardField,z,index] = res3(XX,LayerResults,profile,[0,1],parm);

%% Adjount calculation, gradient of FoM

    AdjointIncidence =[0,1*exp(1i*angle(conj(reflectance.amplitude_TE(TargetIndex))))];
    kParallelAdjoint = -nTop*reflectance.K(TargetIndex,1);
    LayerResults = res1(Wavelength,period,LayerTextures,nn,kParallelAdjoint,angle_delta,parm);
    [AdjointField,~,RefractiveIndex] = res3(XX,LayerResults,profile,AdjointIncidence,parm);
    FieldProduct = ForwardField(:,:,1).*AdjointField(:,:,1) + ...
                    ForwardField(:,:,2).*AdjointField(:,:,2) + ForwardField(:,:,3).*AdjointField(:,:,3);
    FieldProductWeighted(1,:,:) = FieldProduct;
    FieldAll = (2*squeeze(mean(sum(FieldProductWeighted,1),2)))';
    Gradient2 = abs(r)*real(-1i*FieldAll).*0.0515;
    TNT = (beta*((sech((Rho2-cutoff).*beta)).^2)./(tanh(beta*cutoff)+tanh(beta*((nDevice^2 + nTop^2)-cutoff))));
    Gradient1 = Gradient2.*TNT; 
    Gradient = (B*(Gradient1'))';
    FoM = -Abs_Efficiency*100;

%% Figures

    figure(1)
    subplot(1,2,1)
    plot(XX,Rho3)
    xlabel('Postion (nm)');     ylabel('Structural distribution, \rho_3');
    ylim([0 1]);                xlim([0 870]);
    subplot(1,2,2)
    plot(-FoM)
    xlabel('Iterations');
    ylabel('Absolute efficiency (%)');
    ylim([0 100]);
    set(gca, 'box', 'off'); 
    set(gca, 'XColor', 'k', 'YColor', 'k');

%% Iterations and file saving

    Rho = PatternIn;
    save(append(FileName,'.mat'),'FoM', 'Rho');

end