function [worked] = myiinit(username,password)
    try

        %%%
        % string for writing out the environment file
        str = ['irodsHost irods.iplantcollaborative.org\n' ...
                'irodsPort 1247\n' ...
                'irodsUserName %var0%\n'...
                'irodsZone iplant\n'];
        %%%
        % write out the file
        iuser = username;
        %%%
        % make the .irods folder for storing the password and env files
        [res opath] = system('echo $HOME');
        opath(end) = [];
        opath = [opath '/.irods'];
        mkdir(opath);
        fn = [opath '/.irodsEnv']
        [fid msg] = fopen(fn, 'w');
        msg
        fprintf(fid, strrep(str,'%var0%',iuser));
        fclose(fid);
        %%%
        % init irods
        [statu,result] = system(['echo ''' password ''' | iinit'] );

        fidx = strfind(result,'failed');
           
        worked = isempty(fidx);
                
    catch
        
    end
end