SSH_EXEC=$(whereis ssh | awk '{ print $2 }')

fold_script() {
    SCRIPT=$1
    cat $SCRIPT | tr '\n' ';'
}

ssh() {
    BOF='<('
    EOF=')'
    $SSH_EXEC -t $@ \
        "bash --init-file ${BOF}echo '$(fold_script $HOME/.sshrc)'${EOF}"
}
