function unmount-luks --description "Unmount a LUKS encrypted USB using fzf"
    if not sudo -v
        echo "Failed to authenticate with sudo."
        return 1
    end

    # Detect opened LUKS devices (crypt type)
    set luks_open (
        lsblk -rno NAME,TYPE,MOUNTPOINT | grep "crypt" | awk '{printf "%s %s\n", $1, $3}'
    )

    if test (count $luks_open) -eq 0
        echo "No LUKS volumes are currently unlocked."
        return 1
    end

    # Show them in fzf
    set selected (printf "%s\n" $luks_open | fzf --prompt="Select LUKS volume to unmount: ")

    if test -z "$selected"
        echo "No selection made."
        return 1
    end

    set luks_name (echo $selected | awk '{print $1}')
    set mount_point (echo $selected | awk '{print $2}')

    if test -z "$mount_point"
        echo "Error: cannot detect mount point for $luks_name"
        return 1
    end

    echo "Unmounting /dev/mapper/$luks_name from $mount_point ..."
    sudo umount $mount_point

    if test $status -ne 0
        echo "Failed to unmount."
        return 1
    end

    echo "Closing LUKS mapping $luks_name ..."
    sudo cryptsetup close $luks_name

    if test $status -eq 0
        echo "Successfully unmounted and closed $luks_name"
    else
        echo "Failed to close LUKS mapping."
    end
end