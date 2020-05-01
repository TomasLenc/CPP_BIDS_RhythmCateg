function results = bids_runtests(pth)
% Run tests
% List all the 'test_*.m' files located in the same directory as this
% function, run them and keep track of how many passed, failed or are
% incomplete.
%__________________________________________________________________________

% Copyright (C) 2019, Guillaume Flandin, Wellcome Centre for Human Neuroimaging
% Copyright (C) 2020--, CPP_BIDS developers

%-Get the path of where this file is located
if ~nargin, pth = fileparts(mfilename('fullpath')); end

%-List all the 'test_*.m' files located in the same directory as this
% function
d = dir(pth);
d([d.isdir]) = [];
d(arrayfun(@(x) isempty(regexp(x.name,'^test_.*\.m$','once')),d)) = [];

results = struct('Passed',{},'Failed',{},'Incomplete',{},'Duration',{});
for i=1:numel(d)

    results(i).Failed = false;
    results(i).Passed = false;
    results(i).Incomplete = false;

    tstart = tic;

    %-Run each test file and catch error message in case of failure
    try

        fprintf('%s',d(i).name(1:end-2));
        feval(d(i).name(1:end-2));
        results(i).Passed = true;
    catch err
        results(i).Failed = true;
        fprintf('\n%s',err.message);
    end

    results(i).Duration = toc(tstart);

    fprintf('\n');

end

if ~nargout
    fprintf(['Totals (%d tests):\n\t%d Passed, %d Failed, %d Incomplete.\n' ...
        '\t%f seconds testing time.\n\n'],numel(results),nnz([results.Passed]),...
        nnz([results.Failed]),nnz([results.Incomplete]),sum([results.Duration]));
end
