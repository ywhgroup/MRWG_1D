function [stop, History] = TO_outfun(x, optimValues, state)

    persistent OptHistory
    if isempty(OptHistory)
        OptHistory = struct;
        OptHistory.fval = [];
        OptHistory.x = [];
    end
    stop = false;
 
    switch state
        case 'init'
            hold on
        case 'iter'
            OptHistory.fval = [OptHistory.fval; optimValues.fval];
            OptHistory.x(:,end+1) = x;
            History = OptHistory;
            scatter(optimValues.iteration,-optimValues.fval,'blue')
        case 'done'
            hold off
            save(['history_su' '.mat'],'OptHistory')
        otherwise
    end

end