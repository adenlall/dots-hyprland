function mount-luks --description "Mount a LUKS encrypted USB using fzf"
    if not sudo -v
        echo "Failed to authenticate with sudo."
        return 1
    end

    set luks_list (
        for dev in (sudo blkid | grep 'crypto_LUKS' | cut -d: -f1)
            set size (lsblk -no SIZE $dev)
            printf "%s  [%s]\n" $dev $size
        end
    )

    set selected (printf "%s\n" $luks_list | fzf --prompt="Select LUKS device: ")

    set dev (echo $selected | awk '{print $1}')

    echo "💢 Selected: $dev"

    read -s -P "Enter LUKS passphrase: " pass

    set luks_name (basename $dev)"_luks"

    echo "Unlocking $dev..."
    echo $pass | sudo cryptsetup open $dev $luks_name -

    if test $status -ne 0
        echo "Failed to unlock."
        return 1
    end

    read -P "Enter mount directory name (ex: mybackupusb): " dir

    if test -z "$dir"
        echo "You must enter a directory name."
        return 1
    end

    set mount_point "/mnt/$dir"
    sudo mkdir -p $mount_point


    set mapper_path "/dev/mapper/$luks_name"
    echo "Mounting $mapper_path → $mount_point..."
    sudo mount $mapper_path $mount_point

    if test $status -eq 0
        echo "🍥 Mounted successfully at $mount_point"
    else
        echo "Mount failed!"
    end
end