function dots --wraps='cd ~/.config' --description 'Manage the dots on ~/.dotsys'
    switch "$argv[1]"
        case cd
            cd /path/to/your/specific/folder
        case pull
            switch "$argv[2]"
                case fast
                    echo "pulling with --skip-alldeps --skip-allgreeting"
                    ./setup install --skip-alldeps --skip-allgreeting
                case files
                    echo "pulling with --skip-alldeps"
                    ./setup install --skip-alldeps
                case deps
                    echo "pulling with"
                    ./setup install
                case kill
                    echo "killing qs and pulling with fast"
                    kill qs
                    ./setup install --skip-alldeps --skip-allgreeting || qs -c ii
                case ''
                    echo "pulling with --skip-alldeps --skip-allgreeting"
                    ./setup install --skip-alldeps --skip-allgreeting
                case '*'
                    echo "dots.fish pull [subcommand]: uknown $argv[2]"
                    return 1
            end
        case '*'
            cd ~/.dotsys  $argv
            echo "cd ~/.dotsys"
            echo "Unknown argument: $argv[1]"
            return 1
    end    
end
