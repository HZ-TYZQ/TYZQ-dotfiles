# Import ~/.config/environment.d for logins outside the systemd session (TTY, SSH).
# Values already set win, so the graphical session and temporary overrides are kept.
set -l generator /usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator
if test -x $generator
    for line in ($generator)
        set -l pair (string split -m 1 = -- $line)
        set -l name $pair[1]
        if test -z "$$name"
            set -gx $name $pair[2]
        end
    end
end
