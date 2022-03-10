if [[ $QUICK_DEPLOY == false ]]; then
    python3 -m pip install --user --upgrade pip
    python3 -m pip install --user --upgrade -r Pipfile
fi
