function dots --wraps='cd ~/.config' --description 'Manage the dots on ~/Projects/dots'
    switch "$argv[1]"
        case cd
            cd ~/Projects/dots
        case pull
            switch "$argv[2]"
                case fast
                    echo "pulling with --skip-backup --skip-updateicons --skip-alldeps --skip-allgreeting"
                    ~/Projects/dots/setup install --skip-backup --skip-updateicons --skip-alldeps --skip-allgreeting
                case files
                    echo "pulling with --skip-backup --skip-alldeps"
                    ~/Projects/dots/setup install --skip-backup --skip-alldeps
                case deps
                    echo "pulling"
                    ~/Projects/dots/setup install
                case kill
                    echo "killing qs and pulling with fast"
                    kill qs
                    ~/Projects/dots/setup install --skip-backup --skip-alldeps --skip-allgreeting
                    qs -c ii
                case ''
                    echo "pulling with --skip-backup --skip-alldeps --skip-updateicons --skip-allgreeting"
                    ~/Projects/dots/setup install --skip-backup  --skip-alldeps --skip-updateicons --skip-allgreeting
                case '*'
                    echo "dots.fish pull [subcommand]: uknown $argv[2]"
                    return 1
            end
        case '*'
            cd ~/Projects/dots  $argv
            echo "cd ~/Projects/dots"
            echo "Unknown argument: $argv[1]"
            return 1
    end    
end
