#!/bin/sh
# Creates a service that runs a node application on startup

# init.d SCRIPT
# ==============================================================================
create_script() {
    cat <<EOF >$1
#!/bin/sh
### BEGIN INIT INFO
# Provides: $1
# Required-Start:        \$remote_fs \$syslog
# Required-Stop:         \$remote_fs \$syslog
# Default-Start:         2 3 4 5
# Default-Stop:            0 1 6
# Short-Description:     Start daemon at boot time
# Description:           Enable service provided by daemon.
### END INIT INFO

dir="$2"
cmd="$3"
user="$4"

name=\`basename \$0\`
pid_file="/var/run/\$name.pid"
stdout_log="/var/log/\$name.log"
stderr_log="/var/log/\$name.err"

get_pid() {
    cat "\$pid_file"
}

is_running() {
    [ -f "\$pid_file" ] && ps \`get_pid\` > /dev/null 2>&1
}

case "\$1" in
    start)
        if is_running; then
            echo "Already started"
        else
            echo "Starting \$name"
            cd "\$dir"
            if [ -z "\$user" ]; then
                sudo \$cmd >> "\$stdout_log" 2>> "\$stderr_log" &
            else
                sudo -u "\$user" \$cmd >> "\$stdout_log" 2>> "\$stderr_log" &
            fi
            echo \$! > "\$pid_file"
            if ! is_running; then
                echo "Unable to start, see \$stdout_log and \$stderr_log"
                exit 1
            fi
        fi
        ;;
    stop)
        if is_running; then
            echo -n "Stopping \$name.."
            kill \`get_pid\`
            for i in {1..10}
            do
                if ! is_running; then
                    break
                fi

                echo -n "."
                sleep 1
            done
            echo

            if is_running; then
                echo "Not stopped; may still be shutting down or shutdown may have failed"
                exit 1
            else
                echo "Stopped"
                if [ -f "\$pid_file" ]; then
                    rm "\$pid_file"
                fi
            fi
        else
            echo "Not running"
        fi
        ;;
    restart)
        \$0 stop
        if is_running; then
            echo "Unable to stop, will not attempt to start"
            exit 1
        fi
        \$0 start
        ;;
    status)
        if is_running; then
            echo "Running"
        else
            echo "Stopped"
            exit 1
        fi
        ;;
        *)
        echo "Usage: \$0 {start|stop|restart|status}"
        exit 1
        ;;
esac

exit 0
EOF
}

# SERVICE CREATION
# ==============================================================================
if [ $# -lt 3 ]; then
    echo "Usage: $0 <service-name> <directory> <command> [<user>]"
    echo "  <service-name> is the name of the service."
    echo "  <directory> is the absoulte path of the directory from where the command will be executed."
    echo "  <command> is the command that will be executed on service start."
    echo "  <user> is the user that will execute the service. If not provided, it will be root."
else
    create_script "$1" "$2" "$3" "$4"
    chmod a+x $1
    sudo mv $1 /etc/init.d/$1
    sudo update-rc.d $1 defaults
fi

exit 0