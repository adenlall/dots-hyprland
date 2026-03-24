function dots --wraps='cd ~/.config' --description 'Manage the dots on ~/.dotsys'
    switch "$argv[1]"
        case cd
            cd ~/.dotsys
        case pull
            switch "$argv[2]"
                case fast
                    echo "pulling with --skip-backup --skip-alldeps --skip-allgreeting"
                    ~/.dotsys/setup install --skip-backup --skip-alldeps --skip-allgreeting
                case files
                    echo "pulling with --skip-backup --skip-alldeps"
                    ~/.dotsys/setup install --skip-backup --skip-alldeps
                case deps
                    echo "pulling"
                    ~/.dotsys/setup install
                case kill
                    echo "killing qs and pulling with fast"
                    kill qs
                    ~/.dotsys/setup install --skip-backup --skip-alldeps --skip-allgreeting
                    qs -c ii
                case ''
                    echo "pulling with --skip-backup --skip-alldeps --skip-allgreeting"
                    ~/.dotsys/setup install --skip-backup --skip-alldeps --skip-allgreeting
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
